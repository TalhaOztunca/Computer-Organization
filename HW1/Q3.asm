.data
.text
.globl main 


main:
    li $v0, 5      #
    syscall        #
    move $s0, $v0  # s0 = getint()

    blt $s0, $zero, END # if (s0<0) end program

    sll $t0, $s0, 2 # t0 is memory needed for array
    move $s2, $sp # s2 is where array finishes
    sub $sp, $sp, $t0 # needed memory is got from stack
    move $s1, $sp # s1 is where array starts

    move $t0, $s1 # t0 is pointer where it shows first element of array
    getInput:
    li $v0, 5      #
    syscall        #
    sw $v0, 0($t0) # *t0 = getint()
    addi $t0, $t0, 4 # ++t0
    blt $t0, $s2, getInput # if t0 is still in the boundry of array repeat getInput

    move $a0, $s1     #
    addi $a1, $s2, -4 #
    jal qsort         # qsort(start address, end address)

    move $t0, $s1 # t0 is pointer where it shows first element of array
    printArr:
    li $v0, 1      #
    lw $a0, 0($t0) #
    syscall        # print(*t0)
    li $a0, ' ' #
    li $v0, 11  #
    syscall     # print(" ")
    addi $t0, $t0, 4 # ++t0
    blt $t0, $s2, printArr # if t0 is still in the boundry of array repeat printArr

    END:
    li $v0, 10 # 
    syscall    # terminate program


qsort: # qsort(a0, a1)
       # a0 start adress a1 end address
    
    blt $a0, $a1, qsortCont #
    jr $ra                  # if there are less than 2 element directly return

    qsortCont:
    lw $t3, 0($a1) # t3 is pivot

    move $t0, $a0 # t0 is start
    addi $t1, $a1, -4 # t1 is the element before end

    qsortLoop: bgt $t0, $t1, qsortLoopEnd # while(t0<=t1) {
    lw $t2, 0($t0) # t2 = *t0
    ble $t2, $t3, leftSmallerPivot
    j leftBiggerPivot

    leftSmallerPivot:
    addi $t0, $t0, 4 # left one shifted to one right
    j qsortLoop

    leftBiggerPivot:
    lw $t5, 0($t1) #
    sw $t2, 0($t1) #
    sw $t5, 0($t0) # swap left and right
    addi $t1, $t1, -4 # right one shifted to one left
    j qsortLoop   
    qsortLoopEnd: # }

    ##  current value of important registers
    # $a0 start of array
    # $a1 end of array also where is pivot
    # $t0 where is the first element which is bigger than pivot
    # $ra where we will return 
    ##  not save to stack but use for swap ones
    # $t3 value of pivot

    lw $t1, 0($t0) #
    sw $t1, 0($a1) #
    sw $t3, 0($t0) # swap pivot and t0, t0 is pivot now

    addi $sp, $sp, -16 #
    sw $a0, 0($sp)     #
    sw $a1, 4($sp)     #
    sw $t0, 8($sp)     #
    sw $ra, 12($sp)    # save to stack before calling

    addi $a1, $t0, -4 #
    jal qsort         # call qsort for from start till the element before pivot

    lw $a0, 8($sp)   #   
    addi $a0, $a0, 4 #
    lw $a1, 4($sp)   #
    jal qsort        # call qsort for from the element after pivot till end

    lw $ra, 12($sp)   #
    addi $sp, $sp, 16 #
    jr $ra            # restore ra and stack than return