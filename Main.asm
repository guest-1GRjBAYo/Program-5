; Main.asm
; Name: Nicholas Wang
; UTEid: ngw294
; Continuously reads from x4600 making sure its not reading duplicate
; symbols. Processes the symbol based on the program description
; of mRNA processing.
               .ORIG x4000
BR skip
reset
TRAP x25
skip
; initialize the stack pointer

LD R6, stackpointer

;set up keyboard interrupt vector table entry

LD R0, ivt
LD R1, isr
STR R1, R0, #0

;enable keyboard interrupts

LD R1, KBSR
LD R2, mask
STR R2, R1, #0

; start of actual program

LD R3, global
AND R4, R4, #0
STR R4, R3, #0

LD R5, queue
STR R4, R5, #0			;fill end of queue with a zero

loop LDR R0, R3, #0
BRz loop
TRAP x21
STR R4, R3, #0

STI R4, KBSR			;disable interrupt

;fill the queue
LD R5, queue	

LDR R2, R5, #-3
STR R2, R5, #-4

LDR R2, R5, #-2
STR R2, R5, #-3

LDR R2, R5, #-1
STR R2, R5, #-2

STR R0, R5, #-1


;check if start codon
;loop through both strings checking if equal
ADD R5, R5, #-3


LEA R2, start
whileloop 
LDR R1, R2, #0
LDR R4, R5, #0
NOT R4, R4
ADD R4, R4, #1
ADD R4, R1, R4
BRnp notstart

ADD R5, R5, #1
ADD R2, R2, #1
LDR R1, R2, #0
BRnp whileloop

LD R0, ascii_bar
TRAP x21
BR nextphase

notstart

AND R4, R4, #0
STR R4, R3, #0
LD R2, mask
STI R2, KBSR			;re-enable interrupt

BR loop


;**************************************************************
nextphase			;check for stop codon



;need to clear queue first

AND R4, R4, #0

LD R5, queue
STR R4, R5, #-1
STR R4, R5, #-2
STR R4, R5, #-3

STR R4, R3, #0
LD R2, mask
STI R2, KBSR			;re-enable interrupt

LD R3, global
AND R4, R4, #0
STR R4, R3, #0

LD R5, queue
STR R4, R5, #0			;fill end of queue with a zero

loopy LDR R0, R3, #0
BRz loopy
TRAP x21
STR R4, R3, #0

STI R4, KBSR			;disable interrupt

;fill the queue
LD R5, queue	

LDR R2, R5, #-3
STR R2, R5, #-4

LDR R2, R5, #-2
STR R2, R5, #-3

LDR R2, R5, #-1
STR R2, R5, #-2

STR R0, R5, #-1

ADD R5, R5, #-3

;UAG
LEA R2, stop1
whileloopy 
LDR R1, R2, #0
LDR R4, R5, #0
NOT R4, R4
ADD R4, R4, #1
ADD R4, R1, R4
BRnp trystop2

ADD R5, R5, #1
ADD R2, R2, #1
LDR R1, R2, #0
BRnp whileloopy
BR end



end BR reset

mask		.fill x4000
KBSR		.fill xFE00
KBDR		.fill xFE02
ivt		.fill x0180
stackpointer 	.fill x4000
isr		.fill x2600
mask2		.fill x8000
global		.fill x4600
queue 		.fill x4400    ;queue will be a 3 char null terminated string
start		.STRINGZ "AUG"
stop1		.STRINGZ "UAG"
stop2		.STRINGZ "UAA"
stop3		.STRINGZ "UGA"

ascii_A		.fill x41
ascii_C		.fill x43
ascii_G		.fill x47
ascii_U		.fill x55
ascii_bar	.fill x7C
		.END
