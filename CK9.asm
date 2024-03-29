.eqv PICTURE_ROW 16 #number of rows of picture 
.eqv D_END 21
.eqv C_START 22
.eqv C_END 41
.eqv E_START 42
.eqv E_END 57
.data

    #original one contain 16 strings 
    String1: .asciiz  "                                          *************   \n"
    String2: .asciiz  "**************                            *3333333333333* \n"
    String3: .asciiz  "*222222222222222*                         *33333********  \n"
    String4: .asciiz  "*22222******222222*                       *33333*         \n"
    String5: .asciiz  "*22222*      *22222*                      *33333********  \n"
    String6: .asciiz  "*22222*       *22222*      *************  *3333333333333* \n"
    String7: .asciiz  "*22222*       *22222*    **11111*****111* *33333********  \n"
    String8: .asciiz  "*22222*       *22222*  **1111**       **  *33333*         \n"
    String9: .asciiz  "*22222*      *222222*  *1111*             *33333********  \n"
    String10: .asciiz "*22222*******222222*  *11111*             *3333333333333* \n"
    String11: .asciiz "*2222222222222222*    *11111*              *************  \n"
    String12: .asciiz "***************       *11111*                             \n"
    String13: .asciiz "      ---              *1111**                            \n"
    String14: .asciiz "    / o o \\             *1111****    *****                \n"
    String15: .asciiz "    \\   > /              **111111***111*                  \n"
    String16: .asciiz "     -----                 ***********    tubh.hust.edu   \n"
    ImgArray: .space 68
    Message0: .ascii  "------------Menu-----------\n"
    Phan1:    .ascii  "1. In ra chu\n"
    Phan2:    .ascii  "2. In ra chu rong\n"
    Phan3:    .ascii  "3. Thay doi vi tri\n"
    Phan4:    .ascii  "4. Doi mau cho chu\n"
    Thoat:    .ascii  "5. Thoat\n"
    Nhap:     .asciiz  "Nhap gia tri: "
    ChuD:     .asciiz  "Nhap mau cho chu d(0->9): "
    ChuC:     .asciiz  "Nhap mau cho chu c(0->9): "
    ChuE:     .asciiz  "Nhap mau cho chu e(0->9): "
.text

#store row address into ImgArray
addi $s0, $0, 0    #bien dem =0 
la $s1, ImgArray
la $a0, String1
StoreArray:
    sw $a0, 0($s1)        
	beq $s0, PICTURE_ROW, main
    NextStr:
       	lb  $t0,0($a0)
       	addi $a0, $a0, 1
       	bne $t0,$0,NextStr
       	nop
        	
    addi $s0, $s0, 1
    addi $s1, $s1, 4

    j StoreArray
    nop

#procedure print_char
#detect color and change it, print line  
#@param_in 
#   $s1:begin address 
#   $a1:color (number)
#   $a2:last address
#registers : t0
#-----------------------------------------------------
print_char:

li $v0,11
pcloop:
    bge $s1,$a2,endpc
    lb $a0,0($s1)
	blt $a0,0x30, pcprint 
	bgt $a0,0x39,pcprint
    nop 
    add $a0,$0,$a1
    pcprint: syscall
    addi $t0,$t0,1
    
    addi $s1,$s1,1
    j pcloop
    nop
endpc:
jr $ra 
nop


#----------------------------------------------------------------------------------

main:
    la $a0, Message0    # nhap menu
    li $v0, 4
    syscall
    
    li $v0, 5 #chon menu
    syscall
    
    #switch-case
    #Case1
        beq $v0 1 Menu1
        nop
    #Case2
        beq $v0 2 Menu2
        nop
    #Case3
        beq $v0 3 Menu3
        nop
    #Case4
        beq $v0 4 Menu4
        nop
    #Case5:
        beq $v0 5 Exit
        nop
    #defaul
        j main
        nop
#---------------------------------in ra binh thuong-------------------------------   
Menu1:    
    addi $s0, $0, 0    #bien dem =0   
    la $s1,ImgArray
        li $v0, 4
    Loop1: 
        lw $a0, 0($s1)       
        syscall
        addi $s0, $s0, 1
        addi $s1,$s1,4
        beq $s0, PICTURE_ROW, main
        nop
        j Loop1
        nop

#------------------------ chi in ra vien cac chu------------------------------------
Menu2:     
    la $s0, ImgArray    #bien dem tung hang =0
    lw $s1,0($s0)    # $s1 la dia chi cua string1    
    li $a1, ' '
    lw $a2, 64($s0)


    jal print_char
    nop
    j main
    nop
#################doi vi tri chu ############
Menu3:    
    addi $s0, $0, 0    #bien dem tung hang =0
    la $s1, ImgArray
Loop3:    
    lw $s2, 0($s1) 
    beq $s0, PICTURE_ROW, main
    #tao thanh 3 string nho
    sb $0 D_END($s2)
    sb $0 C_END($s2)
    sb $0 E_END($s2)

    #doi vi tri
    li $v0, 4 
    la $a0 E_START($s2) #in chu E
    syscall
    
    la $a0 C_START($s2) # in chu C
    syscall
    
    la $a0 0($s2) # in chu D
    syscall
     
    li $v0,11
    addi $a0,$0,'\n' 
    syscall
    
    #tra lai chuoi nhu cu
    addi $a0,$0,' '
    sb $a0 D_END($s2)
    sb $a0 C_END($s2)
    sb $a0 E_END($s2)
    
    addi $s0,$s0,1 #counter ++
    addi $s1,$s1,4 #next line

    j Loop3
    nop

############ doi mau cho chu ################
Menu4: 
    NhapmauD:    
        li     $v0, 4        
        la     $a0, ChuD
        syscall
    
        li     $v0, 5        # lay mau cua ki tu D
        syscall

        blt    $v0,0, NhapmauD
        bgt    $v0,9, NhapmauD
        nop
        addi     $s3 $v0 48    #$s3 luu mau cua chu D
    NhapmauC:
        li     $v0, 4        
        la     $a0, ChuC
        syscall
    
        li     $v0, 5        # lay mau cua ki tu C
        syscall

        blt    $v0, 0, NhapmauC
        bgt    $v0, 9, NhapmauC
        nop
        addi     $s4  $v0 48    #$s4 luu mau cua chu C
    NhapmauE:
        li     $v0, 4        
        la     $a0, ChuE
        syscall
    
        li     $v0, 5        # lay mau cua ki tu E
        syscall

        blt    $v0, 0, NhapmauE
        bgt    $v0, 9, NhapmauE
        nop
        addi     $s5 $v0 48    #$s5 luu mau cua chu E
PrintColor:
    la $s0, ImgArray    
    li $s6,0 #line counter 
EachLine4:
    beq $s6,PICTURE_ROW,main
    lw $s1,0($s0)
    InD:
        
        add $a1, $s3,$0 #color of D
        addi $a2,$s1, D_END

        jal print_char
        
        addi $s1,$s1,1 #next char -> into C
        li $a0, ' '
        li $v0, 11
        syscall  

    InC:
        
        add $a1, $s4,$0 #color of C
        addi $a2,$s1, C_END
        addi $a2,$a2,-C_START

        jal print_char
        
        addi $s1,$s1,1
        li $a0, ' '
        li $v0, 11
        syscall  

    InE:
        
        add $a1, $s5,$0 #color of E
        lw $a2,4($s0)

        jal print_char
        
    addi $s0,$s0,4
    addi $s6,$s6,1
    j EachLine4
    nop
Exit:
