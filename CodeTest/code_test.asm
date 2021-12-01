addi	x10,x0,0
addi	x11,x10,0
addi	x12,x10,1
addi	x15,x0,2
addi	x16,x0,3

LOOP1:
lw	x13,0(x11)
lw	x14,0(x12)
blt	x14,x13,SWAP

CONTINUE:
addi	x12,x12,1
blt	x12,x16,LOOP1

addi	x11,x11,1
addi	x12,x10,1
blt	x11,x15,LOOP1

DONE:
addi 	x7,x10,0
addi	x9,x0,3

LOOP3:
lw	x8,0(x7)
sw	x8,3(x7)
addi	x7,x7,1
bltu	x7,x9,LOOP3
jal	x17,END_SORT

SWAP:
sw	x14,0(x11)
sw	x13,0(x12)
jal	x17,CONTINUE

END_SORT:
START_FACTORIAL:
lw	x5,5(x10)
addi	x5,x5,1
addi	x1,x0,1
addi	x2,x0,1

MUL:
addi	x3,x0,0
addi	x4,x0,0

LOOP4:
add	x4,x4,x1
addi	x3,x3,1
bne	x3,x2,LOOP4

addi	x1,x4,0
addi	x2,x2,1
bne	x2,x5,MUL
addi	x6,x1,0

sw	x6,6(x10)

END_FACTORIAL:
START_FIBONACCI:
lw	x18,5(x10)
addi	x18,x18,-2
addi	x19,x0,1
addi	x20,x0,1

LOOP5:
add	x21,x20,x19
addi	x19,x20,0
addi	x20,x21,0
addi	x18,x18,-1
bne	x18,x0,LOOP5

sw	x20,7(x10)

END:
add	x0,x0,x0


