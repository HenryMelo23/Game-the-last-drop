.data

PER_POS: .half 0,0


.text
SETUP:		la a0,maps
		li a1,0
		li a2,0
		li a3,0
		call PRINT
		li a3,1
		call PRINT

GAME_LOOP:	call KEY2

		xori s0,s0,1
		
		la t0,PER_POS
		
		la a0, per
		lh a1,0(t0)
		lh a2,2(t0)
		mv a3,s0
		call PRINT
		
		li t0,0xFF200604
		sw s0,0(t0)
		
		j GAME_LOOP
		
#		a0 = endereço imagem
#		a1= X
#		a2=y
#		a3= frame(0 ou 1)

#		t0= endereço do bitmap diplay
#		t1= endereço de imagem
#		t2= contador de linha
#		t3= contador de coluna
#		t4= largura
# 		t5= altura
		
KEY2:		li t1,0xFF200000	# carrega o endereço de controle
		lw t0,0(t1)		# le bit do controle  teclado 
		andi t0,t0,0x0001	# mascara o bit menos significativo
		beq t0,zero,FIM		# se não há tecla  pressionada então vai para o FIM
		lw t2,4(t1)		# le o valor  da tecla
		
		li t0,'a'
		beq t2,t0,PER_ESQ
		
		li t0,'d'
		beq t2,t0,PER_DIR
		
		li t0,'w'
		beq t2,t0,PER_CIM
		
		li t0,'s'
		beq t2,t0,PER_BAIX
		
		
FIM: 		ret		#retorna

PER_ESQ:	la t0,PER_POS
		

		lh t1,0(t0)
		addi t1,t1,-8
		sh t1,0(t0)
		ret
		
PER_DIR:	la t0,PER_POS
		
		
		lh t1,0(t0)
		addi t1,t1,8
		sh t1,0(t0)
		ret

PER_CIM:	la t0,PER_POS
		
		lh t1,2(t0)
		addi t1,t1,-8
		sh t1,2(t0)
		ret
		
PER_BAIX:	la t0,PER_POS
		
		lh t1,2(t0)
		addi t1,t1,8
		sh t1,2(t0)
		ret

PRINT:		li t0,0xFF0
		add t0,t0,a3
		slli t0,t0,20
		
		add t0,t0,a1
		
		li t1,320
		mul t1,t1,a2
		add t0,t0,t1
		
		addi t1,a0,8
		
		mv t2,zero
		mv t3,zero
		
		lw t4,0(a0)
		lw t5,4(a0)
		
PRINT_LINHA:	lw t6,0(t1)
		sw t6,0(t0)
		
		addi t0,t0,4
		addi t1,t1,4
		
		addi t3,t3,4
		blt t3,t4,PRINT_LINHA
		
		addi t0,t0,320
		sub t0,t0,t4
		
		mv t3,zero
		addi t2,t2,1
		bgt t5,t2,PRINT_LINHA
		
		ret	
.data
.include "maps.data"
.include "per.data"

