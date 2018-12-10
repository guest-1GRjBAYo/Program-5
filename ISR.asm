; ISR.asm
; Name:
; UTEid: 
; Keyboard ISR runs when a key is struck
; Checks for a valid RNA symbol and places it at x4600
               .ORIG x2600

ST R0, savR0
ST R1, savR1 
ST R2, savR2
ST R3, savR3 
ST R4, savR4
ST R5, savR5 
ST R7, savR7


LD 	R0, KBDR
LDR 	R4, R0, #0
LD 	R1, mask
AND 	R1, R4, R1
;R1 has input ascii

NOT R4, R1
ADD R4, R4, #1

LD R5, globalvar


LD R2, ascii_A
ADD R2, R2, R4
BRz end

LD R2, ascii_C
ADD R2, R2, R4
BRz end

LD R2, ascii_G
ADD R2, R2, R4
BRz end

LD R2, ascii_U
ADD R2, R2, R4
BRz end
BR skip

end 

STR R1, R5, #0

skip 


LD R0, savR0
LD R1, savR1 
LD R2, savR2
LD R3, savR3 
LD R4, savR4
LD R5, savR5
LD R7, savR7


RTI

mask		.fill xFF
ascii_A		.fill x41
ascii_C		.fill x43
ascii_G		.fill x47
ascii_U		.fill x55
KBDR 		.fill xFE02
KBIEN		.fill x4000
globalvar	.fill x4600


savR0		.blkw 1	
savR1		.blkw 1
savR2		.blkw 1
savR3		.blkw 1
savR4		.blkw 1
savR5		.blkw 1
savR7		.blkw 1
		.END
