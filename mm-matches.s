@ Used the CPUlator to run and debug your code: https://cpulator.01xz.net/?sys=arm-de1soc&d_audio=48000
@ Note, that the CPUlator simulates a DE1-SoC device, and here you should use the HEX displays to show the numbers
@ See the Tutorials on LED, Button, and HEX displays in the F28HS course (Weeks 8 and 9)

@ This ARM Assembler code should implement a matching function, for use in MasterMind program, as
@ described in the CW3 specification. It should produce as output 2 numbers, the first for the
@ exact matches (peg of right colour and in right position) and approximate matches (peg of right
@ color but not in right position). Make sure to count each peg just once!
	
@ Example (first sequence is secret, second sequence is guess):
@ 1 2 1
@ 3 1 3 ==> 0 1
@ Display the result as two digits on the two rightmost HEX displays, from left to right
@

@ -----------------------------------------------------------------------------

.text
.global         main
main: 
	LDR  R2, =secret	@ pointer to secret sequence
	LDR  R3, =guess		@ pointer to guess sequence
	LDR R10, =HEXBASE   @ pointer to hex display buttons
	MOV R12, #0			@ counter used to check if certain functions should be executed
	MOV R11, #0			@ value of digits to display in the hex buttons 
	
match:

	LDR  R2, =secret	@ pointer to secret sequence
	LDR  R3, =guess		@ pointer to guess sequence
	MOV  R5, #0			@ counter used to check if certain functins should be executed and temporary regsiter holder
	MOV  R6, #0			@ counter used to check if certain functins should be executed and temporary regsiter holder
	
	CMP R12, #3			@ compare R12 and the number 3
	BLT exactmatchloop  @ if R12 is less than 3 exactmatchloop will be executed 
	
	CMP R11, #0					@ compare R11 and the number 0
	BEQ foundnoexactmatches		@ if R11 is equal to 0 then foundnoexactmatches will be executed
	
	CMP R11, #1					@ compare R11 and the number 1
	BEQ foundoneexactmatch 		@ if R11 is equal to 1 then foundoneexactmatche will be executed
	
	CMP R11, #2					@ compare R11 and the number 2
	BEQ foundtwoexactmatches	@ if R11 is equal to 2 then foundtwoexactmatches will be executed
	
	CMP R11, #3					@ compare R11 and the number 3
	BEQ foundthreeexactmatches  @ if R11 is equal to 3 then foundthreeexactmatches will be executed
	
	B matchloop					@ branch to the function matchloop

@ used to check the all the appropriate values of the secret against
@ the second value of the guess
secondcheck:
	MOV  R5, #0
	MOV  R6, #0
	LDR  R3, =guess
	ADD  R2, #4 				@ moves to the next value in the secret sequence
	ADD  R8, #1
	B matchloop					@ executes another matchloop
	
thirdcheck:
	MOV  R5, #0
	MOV  R6, #0
	LDR  R3, =guess
	ADD  R2, #4					@ moves to the next value in the secret sequence
	ADD  R8, #1
	B matchloop					@ executes another matchloop
	


@ loops through each value in the guess and compares it to each value in the guess sequence. 
@ if a matching value is found, the register R1 will be incremented by 1. The appropriate function
@ will then be called based on how many matches in the wrong position were found.
matchloop:

	CMP R5, #3					@ if R5 is equal to 3 then branch to the thirdcheck function
	BEQ thirdcheck
	
	LDR R0, [R2]				@ loads the value in R2 into R0
	LDR R1, [R3]				@ loads the value in R3 into R1
	
	CMP R0, R1					@ checks to see if R0 is equal to R1
	BEQ matchingvalue			@ branches to the matchingvalue function if R0 and R1 are equal
	
	ADD R5, #1					@ increments the R5 counter by 1 
	ADD R3, #4					@ go to the next value in the guess sequence memory
	
	CMP R5, #3					@ compares R5 and the number 3
	BNE matchloop				@ if R5 does not equal 3 then branch to matchloop (start from the start)
	
	CMP R8, #0					@ compares R8 and the number 0
	BEQ secondcheck				@ if R8 equals 0 then branch to the secondcheck function
	
	CMP R8, #1					@ compares R8 and the number 1
	BEQ thirdcheck				@ if R8 equals 1 then branch to the thirdcheck function
	
	MOV R1, R4					@ move the value of R4 into R1
	
	CMP R1, #0					@ compares the R1 and the number 0
	BEQ foundnone				@ if R1 equals 0 no matching values were found and the foundnone function will be branched to
	
	CMP R1, #1					@ compares the R1 and the number 1
	BEQ foundone				@ if R1 equals 1, one matching value was found and the foundone function will be branched to
	
	CMP R1, #2					@ compares the R1 and the number 2
	BEQ foundtwo				@ if R1 equals 2, two matching values were found and the foundtwo function will be branched to
	
	CMP R1, #3					@ compares the R1 and the number 3
	BEQ foundthree				@ if R1 equals 3, three matching values were found and the foundthree function will be branched to
	
	B exit						@ branch to the exit funciton 
	
	
@ increments R4 by 1 as a matching value has been found. increments the R5 counter by 1 and 
@ moves to the next value in the guess sequence
@ branches back to the matchloop when finished
matchingvalue:
	
	ADD R4, #1
	ADD R5, #1
	ADD R3, #4
	B matchloop

foundnone:
	MOV R0, R11					@ moves the value of R11 into R0 which is the number of exact matches found
	MOV R1, #0x0000003f 		@ moves the display value of 1 into the register R1
	ADD R0, R1					@ adds the display value of exact matches and correct but wrong position matches to R0
	STR R0, [R10]				@ stores the value of R0 into the memory at R10
	B exit						@ branches to the exit function

foundone:
	MOV R0, R11					@ moves the value of R11 into R0 which is the number of exact matches found
	MOV R1, #0x00000086			@ moves the display value of 1 into the register R1
	ADD R0, R1					@ adds the display value of exact matches and correct but wrong position matches to R0
	STR R0, [R10]				@ stores the value of R0 into the memory at R10
	B exit						@ branches to the exit function

foundtwo:
	MOV R0, R11					@ moves the value of R11 into R0 which is the number of exact matches found
	MOV R1, #0x0000005b			@ moves the display value of 1 into the register R1
	ADD R0, R1					@ adds the display value of exact matches and correct but wrong position matches to R0
	STR R0, [R10]				@ stores the value of R0 into the memory at R10
	B exit						@ branches to the exit function

foundthree:
	MOV R0, R11					@ moves the value of R11 into R0 which is the number of exact matches found
	MOV R1, #0x0000004f			@ moves the display value of 1 into the register R1
	ADD R0, R1					@ adds the display value of exact matches and correct but wrong position matches to R0
	STR R0, [R10]				@ stores the value of R0 into the memory at R10
	B exit						@ branches to the exit function

@ loops through the secret and guess sequences to loook for exact matches. 
@ If one is found both values will be changed in the memory to an invalid
@ value so they can't be correctly checked again
exactmatchloop:
	
	CMP R12, #3
	BEQ match
	
	LDR R0, [R2]				@ loads the value in R2 into R0
	LDR R1, [R3]				@ loads the value in R3 into R1
	
	CMP R0, R1					@ if R0 and R1 are equal then an exact match has been found and the funciton foundexactmatch will be branched to
	BEQ foundexactmatch
	
	ADD R2, #4					@ move to the next value in the secret sequence memory
	ADD R3, #4					@ move to the next value in the guess sequence memory
	ADD R12, #1					@ increment the R12 counter by 1
	
	B exactmatchloop			@ branch back to the start of exactmatchloop
	
@ if an exact match is found, change both values in the guess and secret sequence to an invalid value. 
foundexactmatch:

	ADD R11, #1					
	
	MOV R0, #0x00001000 		@ invalid value change
	MOV R1, #0x00002000			@ invalid value change
	
	STR R0, [R2]				@ store the value in R0 in the memory at R2
	STR R1, [R3]				@ store the value in R1 in the memory at R3
	
	ADD R2, #4					@ move to the next value in the secret sequence memory
	ADD R3, #4					@ move to the next value in the guess sequence memory
	ADD R12, #1					@ increment the R12 counter by 1
	
	B exactmatchloop			@branch to the function exactmatchloop
	

@ changes the second value in the secret sequence to an invalid value
changesecondsecretvalue:
	MOV R1, #0x00000097
	MOV R0, R2
	ADD R0, #4
	STR R1, [R0]
	B removeduplicate

@ changes the third value in the secret sequence to an invalid value
changethirdsecretvalue:
	MOV R1, #0x00000096
	MOV R0, R2
	ADD R0, #8
	STR R1, [R0]
	B removeduplicate

@ changes the second value in the guess sequence to an invalid value 
changesecondguessvalue:
	MOV R1, #0x00000099
	MOV R0, R3
	ADD R0, #4
	STR R1, [R0]
	B removeduplicate

@ changes the third value in the guess sequence to an invalid value	
changethirdguessvalue:
	MOV R1, #0x00000098
	MOV R0, R3
	ADD R0, #8
	STR R1, [R0]
	B removeduplicate

@ no exact mathces have been found so the hex display for 
@ exact matches will be set to 0 and stored in R11
foundnoexactmatches:

	MOV R11, #0x00003f00
	B removeduplicate

@ one exact mathce has been found so the hex display for 
@ exact matches will be set to 1 and stored in R11
foundoneexactmatch:

	MOV R11, #0x00008600 
	B removeduplicate

@ two exact mathces have been found so the hex display for 
@ exact matches will be set to 2 and stored in R11
foundtwoexactmatches:
	
	MOV R11, #0x00005b00
	B removeduplicate 
	
@ the user has guessed the correct sequence so the hex display value for exact 
@ matches will be 3 and matching value but wrong position will be 0
foundthreeexactmatches:
	
	MOV R11, #0x00004f3f	
	STR R11, [R10]		@ the value that will display 3 0 will be stored in the memory at R10
	B exit				@ branch to exit

@remove duplicate guess by changing the duplicate value in the guess 
@sequence to an invalid value for checking
removeduplicate:

	LDR R5, [R3]						@ load the first value in the guess sequence into R5
	LDR R6, [R3, #4]					@ load the second value in the guess sequence into R6
	LDR R7, [R3, #8]					@ load the third value in the guess sequence into R7

	CMP R5, R6							@ compares the first and second value in the guess sequence
	BEQ changesecondguessvalue			@ if they're equal change the second value by calling the changesecondguessvalue
	
	CMP R5, R7							@ compares the first and third value in the guess sequence
	BEQ changethirdguessvalue			@ if they're equal change the third value by calling the changethirdguessvalue
	
	CMP R6, R7							@ compares the second and third value in the guess sequence
	BEQ changethirdguessvalue			@ if they're equal change the third value by calling the changethirdguessvalue
	
	LDR R5, [R2]						@ do the same for the secret sequence
	LDR R6, [R2, #4]
	LDR R7, [R2, #8]

	CMP R5, R6
	BEQ changesecondsecretvalue
	
	CMP R5, R7
	BEQ changethirdsecretvalue
	
	CMP R6, R7
	BEQ changethirdsecretvalue
	
	B match								@ branch back to the match function

exit:	
	@MOV	 R0, R4		@ load result to output register
	MOV 	 R7, #1		@ load system call code
	SWI 	 0		@ return this value
	
@ =============================================================================

.data
.equ MASK, 0x000000ff
.equ EOS, 0
.equ ARRAYSIZE, 3
@ constants about the basic setup of the game: length of sequence and number of colors	
.equ LEN, 3
.equ COL, 3
.equ NAN1, 8
.equ NAN2, 9

@ constants needed to interface with external devices	
.equ BUTTONBASE, 0xFF200050
.equ HEXBASE,	 0xFF200020
.equ BUTTON_NO,  1	

@ you probably want to define a table here, encoding the display of digits on the HEX display	
.align 1	
digits:
	.byte  0b0111111	@ 0
	.byte  0b0000110	@ 1
	.byte  0b1011011	@ 2
	.byte  0b1001111	@ 3
	.byte  0b1100110	@ 4
	.byte  0b1101101	@ 5
	.byte  0b1111100	@ 6
	.byte  0b0000111	@ 7
	.byte  0b1111111	@ 8
	.byte  0b1101111	@ 9

.align 1
char_o:	.byte  0b1011100	@ o
char_n:	.byte  0b1010100	@ n
char_f:	.byte  0b1110001	@ f

@ INPUT DATA for the matching function
.align 4
secret: .word 1
	.word 2 
	.word 1 

.align 4
guess:	.word 3 
	.word 1 
	.word 3 

@ Not strictly necessary, but can be used to test the result	
@ Expect Answer: 0 1
.align 4
expect: .byte 0
	.byte 1

.align 4
secret1: .word 1 
	.word 2 
	.word 3 

.align 4
guess1:	.word 1 
	.word 1 
	.word 2 

@ Not strictly necessary, but can be used to test the result	
@ Expect Answer: 1 1
.align 4
expect1: .byte 1
	.byte 1

.align 4
secret2: .word 2 
	.word 3
	.word 2 

.align 4
guess2:	.word 3 
	.word 3 
	.word 1 

@ Not strictly necessary, but can be used to test the result	
@ Expect Answer: 1 0
.align 4
expect2: .byte 1
	.byte 0
	
array: 
	.rept ARRAYSIZE
	.word 0
	.endr