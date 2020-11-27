.data
.text
.globl main 


main:
    li $v0, 5      #
    syscall        #
    move $s0, $v0  # s0 = getint()

    ble $s0, $zero, END # if (s0<0) goto END
    # since we already know it is bigger than 0 we don't need to recheck at start
    # we can directly use do while instead while

    printLoop: #  printLoop{
    move $s1, $s0 # s1 = s0
    addi $s0, $s0, -1 # s0 -= 1
    printAst: #  printAst{
    li $a0, '*' #
    li $v0, 11  #
    syscall     # print("*")
    addi $s1, $s1, -1 # s1 -= 1
    bgt $s1, $zero, printAst # }printAst
    li $a0, '\n' #
    li $v0, 11   #
    syscall      # print("\n")
    bgt $s0, $zero, printLoop # }printLoop 

    END:
    li $v0, 10 # 
    syscall    # terminate program
