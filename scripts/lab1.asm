Lab1Script:
	call EnableAutoTextBoxDrawing
	ret

Lab1TrainerHeader0:
	db TrainerHeaderTerminator

Lab1TextPointers:
	dw Lab1Text1
	dw Lab1Text2
	dw Lab1Text3
	dw Lab1Text4
	dw Lab1Text5

Lab1Text1:
	fartext _Lab1Text1
	done

Lab1Text2:
	fartext _Lab1Text2
	done

Lab1Text3:
	fartext _Lab1Text3
	done

Lab1Text4:
	fartext _Lab1Text4
	done

Lab1Text5:
	fartext _Lab1Text5
	done
