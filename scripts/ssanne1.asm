SSAnne1Script:
	call EnableAutoTextBoxDrawing
	ret

SSAnne1TrainerHeader0:
	db TrainerHeaderTerminator

SSAnne1TextPointers:
	dw SSAnne1Text1
	dw SSAnne1Text2

SSAnne1Text1:
	fartext _SSAnne1Text1
	done

SSAnne1Text2:
	fartext _SSAnne1Text2
	done
