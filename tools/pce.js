let fs = require('fs'),
    upng = require('./upng.js'),
    memoizedEncoding = new Map();

// To convert the given number to a binary string with the given bit length
function toBinaryString(num, length){
    let str = num.toString(2);
    while(str.length < length) str = '0' + str;
    return str;
}

// To process the given image to compress to 5 colors
class ImageEncoder {
    constructor(pixels, output){
        this.pixels = pixels;
        
        this.headerColors = '';
        this.headerCounters = '';
        this.body = '';
        this.compilation = '';
        
        this.colors = ['W','L','D','B','A'];

        this.encode();
        this.compile(output);
    }
    encode(){   
        let output = [],
            color = this.pixels[0],
            currentData = { color };

        this.firstEncounter = { [color] : true };
        this.lastEncounter = { [color] : currentData };

        this.addHeaderColor(color);
    
        this.index = 0;
        while(++this.index < this.pixels.length){
            let color = this.pixels[this.index];
    
            if(currentData.color != color){
                // Update the end point and last encounter info for this color and store to output
                currentData.end = this.index-1;
                this.lastEncounter[currentData.color] = currentData;
                output.push(currentData);

                // Update the current color data
                currentData = { color };
                // Store the gap since the last time this color was encountered
                this.storeGapSinceLastEncounter(color);
            }
        }
        // Remove the 'previous data' for the last color
        delete this.lastEncounter[currentData.color] ;
        
        // Finish out the end for each color
        this.colors.forEach(color => this.storeGapSinceLastEncounter(color) );
        
        this.addToBody(...output.map( data => this.encodeNumber(data.next) ) );

        return this;
    }
    compile(filepath){
        this.compilation += this.headerColors + this.headerCounters + this.body;

        // Pad to a full byte
        while( this.compilation.length % 8 ) this.compilation += '0';
        
        let bytes = [];

        for(let i=0; i<(this.compilation.length/8); i++){
            let str = this.compilation.substring(i*8, (i+1)*8),
                byte = parseInt(str, 2);

            bytes.push(byte)
        }

        fs.writeFileSync(filepath, Buffer.from(bytes));
    }
    // To store the gap since the last time the color was encountered (or add it to the header if this was the first time it was encountered)
    storeGapSinceLastEncounter(color){
        // If this color has not been encountered yet, add it to the header
        if(!this.firstEncounter[color]){
            this.firstEncounter[color] = true;
            this.addHeaderColor(color);
            this.addHeaderCounter(this.index);
        }
        // If this color has been previously encountered, update the 'next' value for that prior data
        else if(this.lastEncounter[color]){
            this.lastEncounter[color].next = this.index - this.lastEncounter[color].end - 1;
        }
    }
    encodeColor(color){
        let str = this.colors.indexOf(color).toString(2);
        while(str.length < 8 ) str = '0'+str;
        return str;
    }
    addHeaderColor(color){
        this.headerColors += this.encodeColor(color);
    }
    addHeaderCounter(num){
        this.headerCounters += this.encodeNumber(num);
    }
    addToBody(...args){
        args.forEach(value => this.body += value);
    }
    encodeNumber(num){
        num -= 1;
        if( memoizedEncoding.has(num) ){
            return memoizedEncoding.get(num);
        }
    
        let prefix = '',
            startIndex = 0,
            numBits = 1,
            nextIndex = Math.pow(2,numBits);
    
        while(num >= nextIndex){
            prefix += '1';
            startIndex = nextIndex;
            nextIndex += Math.pow(2,++numBits);
        }
        
        let encoding = prefix + '0' + toBinaryString(num-startIndex, numBits);
        memoizedEncoding.set(num, encoding);
        return encoding;
    }
}

function load_png(filepath){
    let image = upng.decode( fs.readFileSync(filepath) ),
        data = new Uint8Array( upng.toRGBA8(image)[0] );

    let height = image.height,
        width = image.width,
        colors = new Set,
        pixels = [];

    let i=0;
    while(i < data.length){
        let r = data[i++],
            g = data[i++],
            b = data[i++],
            a = data[i++];

        if(a === 0 ){
            pixels.push('A');
        }
        else if(a !== 255 ){
            throw Error('Invalid Alpha Value');
        }
        else{
            // Convert to grayscale
            let color = 0.299*r + 0.587*g + 0.114*b;
            pixels.push(color);
            colors.add(color);
        }
    }

    let color_names = ["B", "D", "L", "W"],
        sorted_colors = [...colors.values()].sort((a,b) => a-b),
        color_map = { "A" : "A" };

    if(colors.size > 4){
        console.log('Warning: More than 4 colors detected');

        let range = 256/4;

        // Place each color in a bin, based on where it falls within the range
        sorted_colors.forEach( value => color_map[value] = color_names[Math.floor(value/range)] );
    }
    else{
        // If less than 4 colors, then determine which colors should be mapped:
        if(colors.size < 4){
            console.log('Warning: Less than 4 colors detected');

            let color_bins = color_names.map( x => [] ),
                range = 256/4,
                bin_thresholds = color_names.map( (x, i) => range*(i+1) ),
                adjustment_occurred = false;
            
            // Place each color in a bin, based on where it falls within the range
            sorted_colors.forEach( value => color_bins[Math.floor(value/range)].push(value) )

            //Go through each bin, and shift the color that is closest to the neighbor
            color_bins.forEach( (color_bin, i) => {

                // If all 3 are in this bin, then simply spread them out
                if(color_bin.length == 3){
                    // Shift upwards if i == 2 or 3
                    if(i >= 2){
                        color_names.splice(0,1);
                    }
                    adjustment_occurred = true;
                }
                // If there are only two in this bin, shift one to neighbor
                else if(color_bin.length == 2){
                    adjustment_occurred = true;
                    if(i == 0){
                        // Remove color 2 if there is a color in bin 3
                        if( color_bins[3].length == 1 ){
                            color_names.splice(2, 1);
                        }
                    }
                    else if(i == 1){
                        // if bin 0 is empty:
                        if( color_bins[0].length == 0 ){
                            // if bin 2 is empty:
                            if(color_bins[2].length == 0){
                                let low_gap = color_bin[0] - bin_thresholds[0],
                                    high_gap = bin_thresholds[1] - color_bin[1];
                                    
                                // Remove color 0 if gap to low color is greater than gap from high color to color 2
                                if(low_gap > high_gap){
                                    color_names.splice(0, 1);
                                }
                                // Otherwise, if there is a color in bin 3, remove color 2
                                else if( color_bins[3].length == 1 ){
                                    color_names.splice(2, 1);
                                }
                            }
                            // Otherwise, shift if gap to low color is greater than gap from color 2 to color 3
                            else{
                                let low_gap = color_bin[0] - bin_thresholds[0],
                                    high_gap = bin_thresholds[2] - color_bins[2][0];

                                if(low_gap > high_gap){
                                    color_names.splice(0, 1);
                                }
                            }
                        }
                    }
                    else if(i==2){
                        // shift if bin 3 is not empty
                        if( color_bins[3].length == 1 ){
                            color_names.splice(0, 1);
                        }
                        else{
                            // if bin 1 is empty:
                            if( color_bins[1].length == 0 ){
                                let low_gap = color_bin[0] - bin_thresholds[1],
                                    high_gap = bin_thresholds[2] - color_bin[1];
                                
                                // Remove color 1 if gap to low color is greater than gap from high color to color 3
                                if(low_gap > high_gap){
                                    color_names.splice(1, 1);
                                }

                                // Also remove Color 0 if empty
                                if( color_bins[0].length == 0 ){
                                    color_names.splice(0, 1);
                                }
                            }
                            // Otherwise, shift if gap to high color is less than gap from color 1 to color 0
                            else{
                                let high_gap = bin_thresholds[2] - color_bin[1],
                                    low_gap = color_bins[1][0] - bin_thresholds[0];

                                if(high_gap < low_gap){
                                    color_names.splice(0, 1);
                                }
                            }
                        }
                    }
                    else if(i==3){
                        // Remove color 0  if there is a color in 2
                        if( color_bins[2].length == 1 ){
                            color_names.splice(0, 1);
                        }
                        else{
                            // Remove color 1 if there is no color in it
                            if( color_bins[1].length == 0 ){
                                color_names.splice(1, 1);
                            }
                            // Remove color 0 if there is no color in it
                            if( color_bins[0].length == 0 ){
                                color_names.splice(0, 1);
                            }
                        }
                    }
                }
            });

            // If no adjustment, they are already in separate bins.
            // So remove the empty ones
            if(adjustment_occurred == false){
                for(let i=3;i>=0;i--){
                    if( color_bins[i].length == 0 ){
                        color_names.splice(i, 1);
                    }
                }
            }

        }
        sorted_colors.forEach( (value, i) => color_map[value] = color_names[i] );
    }
    
    return [height, width, pixels.map(x => color_map[x])];
}

function tileize([height, width, pixels]){
    let tiles = [],
        tile_height = height/8,
        tile_width = width/8;

    // swap order of w & h based on if tile-izing vertically or horizontally
    for(let w=0; w<tile_width; w++){
        for(let h=0; h<tile_height; h++){
            let tile = [];
            let tile_start = (h*8) * width + (w*8);

            for(let y=0; y<8; y++){
                let row = [],
                    row_start = tile_start + (y*width);
                for(let x=0; x<8; x++){
                    row.push( pixels[row_start + x] );
                }
                tile.push(row)
            }
            tiles.push(tile);
        }
    }

    let new_pixels = [];
    tiles.forEach(tile => tile.forEach(row => row.forEach(pixel => new_pixels.push(pixel))))
    return new_pixels;
}

function convert(input, output){
    let image_data = load_png(input),
        tilized_pixels = tileize(image_data);
    
    new ImageEncoder(tilized_pixels, output);
}

convert(process.argv[2], process.argv[3])
