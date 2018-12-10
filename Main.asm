; Main.asm
; Name:
; UTEid: 
; Continuously reads from x4600 making sure its not reading duplicate
; symbols. Processes the symbol based on the program description
; of mRNA processing.
               .ORIG x4000
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

loop LDR R0, R3, #0
BRz loop
TRAP x21
STR R4, R3, #0

BR loop


TRAP x25

mask		.fill x4000
KBSR		.fill xFE00
KBDR		.fill xFE02
ivt		.fill x0180
stackpointer 	.fill x4000
isr		.fill x2600
mask2		.fill x8000
global		.fill x4600

		.END
