.eqv PICTURE_ROW 16 #number of rows of picture 
.eqv C_START 22
.eqv E_START 42
.data

    #original one contain 16 strings 
    String1: .asciiz  "                                          *************\n"
    String2: .asciiz  "**************                            *3333333333333*\n"
    String3: .asciiz  "*222222222222222*                         *33333********\n"
    String4: .asciiz  "*22222******222222*                       *33333*\n"
    String5: .asciiz  "*22222*      *22222*                      *33333********\n"
    String6: .asciiz  "*22222*       *22222*      *************  *3333333333333*\n"
    String7: .asciiz  "*22222*       *22222*    **11111*****111* *33333********\n"
    String8: .asciiz  "*22222*       *22222*  **1111**       **  *33333*\n"
    String9: .asciiz  "*22222*      *222222*  *1111*             *33333********\n"
    String10: .asciiz "*22222*******222222*  *11111*             *3333333333333*\n"
    String11: .asciiz "*2222222222222222*    *11111*              *************\n"
    String12: .asciiz "***************       *11111*\n"
    String13: .asciiz "      ---              *1111**\n"
    String14: .asciiz "    / o o \\             *1111****    *****\n"
    String15: .asciiz "    \\   > /              **111111***111*\n"
    String16: .asciiz "     -----                 ***********    tubh.hust.edu.vn\n"
    ImgArray: .space 64
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
addi $s0, $0, 1    #bien dem =0 
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

#procedure change_color
#change character color 
#@param_in
#   $a0,$a1,$a2 color of D,C,E
#use registers 
#   $t0,$t1,$t2
#------------------------------------------------------------------
change_color:
    addi $s0, $0, 0    #bien dem tung hang =0
    la $s2,String1    # $s2 la dia chi cua string1
        
    Loop2:    
	beq $s0,PICTURE_ROW, main #all rows are printed
	nop    
    CheckBorder:
        lb $t2, 0($s2)    # $t2 luu gia tri cua tung phan tu trong string1
	beq $t2, $0, End2 # if t2 = \0, it is end of row
	nop
	
	#check colored 
	li $t5,0x30 #ascii of 0
	slt $t6,$t2,$t5
	li $t5,0x39 #ascii of 9
	sgt $t7,$t2,$t5
	add $t7,$t6,$t7 #if $t2 is not a number => $t7 ==1
	beq $t7, 1, PrintBorder #neu t2 != number thi in luon
	nop
    IsNotBorder:
	addi $t2, $0, 0x20 # thay doi $t2 thanh dau cach neu khong phai la vien
    PrintBorder:
    li $v0, 11 # print char
    add $a0, $t2, $0 
    syscall
    
    addi $s2 $s2 1 #sang chu tiep theo
    j CheckBorder
    nop 
End2:     
    addi $s2,$s2,1 #sang hang tiep theo
    addi $s0 $s0, 1 # tang bien dem hang += 1
    j Loop2
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
    
    la $a0,String1
    Loop1:        
	beq $s0, PICTURE_ROW, main
        li $v0, 4
        syscall
        NextStr:
        	lb  $t0,0($a0)
        	addi $a0, $a0, 1
        	bne $t0,$0,NextStr
        	nop
        	
        addi $s0, $s0, 1
        j Loop1

#------------------------ chi in ra vien cac chu------------------------------------
Menu2:     
    addi $s0, $0, 0    #bien dem tung hang =0
    la $s2,String1    # $s2 la dia chi cua string1
        
    Loop2:    
	beq $s0,PICTURE_ROW, main #all rows are printed
	nop    
    CheckBorder:
        lb $t2, 0($s2)    # $t2 luu gia tri cua tung phan tu trong string1
	beq $t2, $0, End2 # if t2 = \0, it is end of row
	nop
	
	#check colored 
	li $t5,0x30 #ascii of 0
	slt $t6,$t2,$t5
	li $t5,0x39 #ascii of 9
	sgt $t7,$t2,$t5
	add $t7,$t6,$t7 #if $t2 is not a number => $t7 ==1
	beq $t7, 1, PrintBorder #neu t2 != number thi in luon
	nop
    IsNotBorder:
	addi $t2, $0, 0x20 # thay doi $t2 thanh dau cach neu khong phai la vien
    PrintBorder:
    li $v0, 11 # print char
    add $a0, $t2, $0 
    syscall
    
    addi $s2 $s2 1 #sang chu tiep theo
    j CheckBorder
    nop 
End2:     
    addi $s2,$s2,1 #sang hang tiep theo
    addi $s0 $s0, 1 # tang bien dem hang += 1
    j Loop2
    nop
#################doi vi tri chu ############
Menu3:    
    addi $s0, $0, 0    #bien dem tung hang =0
    la $s2,String1 #$s2 luu dia chi cua string1
Lap2:    
    beq $s0, PICTURE_ROW, End3
    #tao thanh 3 string nho
    sb $0 C_START($s2)
    sb $0 E_START($s2)

    #doi vi tri
    li $v0, 4 
    la $a0 44($s2) #in chu E
    syscall
    
    li $v0, 4 
    la $a0 22($s2) # in chu C
    syscall
    
    li $v0, 4 
    la $a0 0($s2) # in chu D
    syscall
    
    li $v0, 4 
    la $a0 66($s2)
    syscall
    # ghep lai thanh string ban dau
    addi $t1 $0 0x20
    sb $t1 21($s2)
    sb $t1 43($s2)
    sb $t1 65($s2)
    
    addi $s0 $s0 1
    addi $s2 $s2 68
    j Lap2
End3:
    addi $a0,$0,' '
    sb $a0 C_START($s2)
    sb $a0 E_START($s2)
    j main
    nop

############ doi mau cho chu ################
Menu4: 
NhapmauD:    li     $v0, 4        
        la     $a0, ChuD
        syscall
    
        li     $v0, 5        # lay mau cua ki tu D
        syscall

        blt    $v0,0, NhapmauD
        bgt    $v0,9, NhapmauD
        
        addi     $s3 $v0 48    #$s3 luu mau cua chu D
NhapmauC:    li     $v0, 4        
        la     $a0, ChuC
        syscall
    
        li     $v0, 5        # lay mau cua ki tu C
        syscall

        blt    $v0, 0, NhapmauC
        bgt    $v0, 9, NhapmauC
                
        addi     $s4  $v0 48    #$s4 luu mau cua chu C
NhapmauE:    li     $v0, 4        
        la     $a0, ChuE
        syscall
    
        li     $v0, 5        # lay mau cua ki tu E
        syscall

        blt    $v0, 0, NhapmauE
        bgt    $v0, 9, NhapmauE
            
        addi     $s5 $v0 48    #$s5 luu mau cua chu E
    
    addi $s0, $0, 0    #bien dem tung h�ng =0
    addi $s1, $0, PICTURE_ROW
    la $s2,String1    # $s2 la dia chi cua string1
    li $a1 48 #gia tri cua so 0
    li $a2 57 #gia tri cua so 9
#    li $t3 21 
#    li $t4 43 
Lapdoimau:    beq $s1, $s0, updatemau
        addi $t0, $0, 0    # $t0 la bien dem tung k� tu cua 1 h�ng =0
        addi $t1, $0, 68 # $t1 max 1 h�ng l� 68 k� tu
    
In1hangdoimau:
    beq $t1, $t0, Enddoimau
    lb $t2, 0($s2)    # $t2 luu gia tri cua tung phan tu trong string1
    CheckL: bgt    $t0, 21, CheckP #kiem tra het chu D chua
        beq    $t2, $t5, fixL
        j Tmpdoimau
    CheckP: bgt    $t0, 43, CheckT #kiem tra het chu C chua
        beq    $t2, $t6, fixP
        j Tmpdoimau
    CheckT: beq    $t2, $t7, fixT
        j Tmpdoimau
        
fixL:     sb $s3 0($s2)
    j Tmpdoimau
fixP:     sb $s4 0($s2)
    j Tmpdoimau
fixT:     sb $s5 0($s2)
    j Tmpdoimau
Tmpdoimau:     addi $s2 $s2 1 #sang chu tiep theo
        addi $t0, $t0, 1# bien dem chu
        j In1hangdoimau
Enddoimau:        li $v0, 4  
        addi $a0 $s2 -68
        syscall
        addi $s0 $s0 1 # tang bien dem h�ng l�n 1
        j Lapdoimau
updatemau: move $t5 $s3
    move $t6 $s4
    move $t7 $s5
    j main    
Exit:
