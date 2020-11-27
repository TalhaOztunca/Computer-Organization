.data
.text
.globl main 


main:
    li $v0, 5      #
    syscall        #
    move $s0, $v0  # s0 = getint()

    blt $s0, $zero, END # if (s0<0) end program

    move $a0, $s0 #
    jal factorial #
    move $s1, $v0 # s1 = factorial(s0)

    li $v0, 1     #
    move $a0, $s1 #
    syscall       # print(s1)

    END:
    li $v0, 10 # 
    syscall    # terminate program


factorial: # factorial(int a0) -> int
           # factorial(0) = 1
           # factorial(n) = factorial(n-1)*n

    bne $a0, $zero, factCnt #
    li $v0, 1               #
    jr $ra                  # if(a==0) return 0;
    
    factCnt:
    addi $sp, $sp, -8 #
    sw $a0, 0($sp)    #
    sw $ra, 4($sp)    # save before calling itself

    addi $a0, $a0, -1 #
    jal factorial     # v0 = factorial(a0-1)

    lw $a0, 0($sp)   #
    lw $ra, 4($sp)   #
    addi $sp, $sp, 8 # load after function calling

    mul $v0, $v0, $a0 # 
    jr $ra            # return factorial(a0-1)*a0