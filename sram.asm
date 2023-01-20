SECTION "Sprite Buffers", SRAM, BANK[0]

	sHallOfFame:: ds HOF_TEAM * HOF_TEAM_CAPACITY ; a598
	sPCESpriteBuffer:: ds 7 * 7 * 16
	sPCESpriteBuffer2:: ds 7 * 7 * 16
	sPCESpriteBufferRaw:: ds 1824

SECTION "Save Data", SRAM, BANK[1]

sPermanentData:: ds 28
sPermanentDataEnd:: ; includes checksum

	ds 1404

sPlayerName::  ds NAME_LENGTH ; a598
sMainData::    ds wMainDataEnd   - wMainDataStart ; a5a3
sSpriteData::  ds wSpriteDataEnd - wSpriteDataStart ; ad2c
sPartyData::   ds wPartyDataEnd  - wPartyDataStart ; af2c
sCurBoxData::  ds wBoxDataEnd    - wBoxDataStart ; b0c0
sTilesetType:: ds 1 ; b522
sMainDataCheckSum:: ds 1 ; b523


SECTION "Saved Boxes 1", SRAM, BANK[2]

sBox1:: ds wBoxDataEnd - wBoxDataStart ; a000
sBox2:: ds wBoxDataEnd - wBoxDataStart ; a462
sBox3:: ds wBoxDataEnd - wBoxDataStart ; a8c4
sBox4:: ds wBoxDataEnd - wBoxDataStart ; ad26
sBox5:: ds wBoxDataEnd - wBoxDataStart ; b188
sBox6:: ds wBoxDataEnd - wBoxDataStart ; b5ea
sBank2AllBoxesChecksum:: ds 1 ; ba4c
sBank2IndividualBoxChecksums:: ds 6 ; ba4d


SECTION "Saved Boxes 2", SRAM, BANK[3]

sBox7::  ds wBoxDataEnd - wBoxDataStart ; a000
sBox8::  ds wBoxDataEnd - wBoxDataStart ; a462
sBox9::  ds wBoxDataEnd - wBoxDataStart ; a8c4
sBox10:: ds wBoxDataEnd - wBoxDataStart ; ad26
sBox11:: ds wBoxDataEnd - wBoxDataStart ; b188
sBox12:: ds wBoxDataEnd - wBoxDataStart ; b5ea
sBank3AllBoxesChecksum:: ds 1 ; ba4c
sBank3IndividualBoxChecksums:: ds 6 ; ba4d
