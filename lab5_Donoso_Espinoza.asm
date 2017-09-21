.data
	array1: .word 0:32 # Array que permite reservar 32 numeros que representan a los 32 bits del primer numero ingresado
	array2: .word 0:32 # Array que permite reservar 32 numeros que representan a los 32 bits del segundo numero ingresado
	opArray: .word 0:32 # Array que representa a la suma o resta de dos numeros decimales, se representa en 32 bits binario
	bienvenida: .asciiz "Bienvenido al programa realizado para el laboratorio 5 de Estructura de computadores\n"
	menu: .asciiz "1.- Complemento a 1 y complemento a 2 de un numero decimal\n2.- Suma binaria de dos numeros decimales\n3.- Resta binaria de dos numeros decimales\n"
	integrantes: .asciiz "Integrantes:\nCristobal Donoso\nCristian espinoza\n"
	pedirOpcion: .asciiz "¿Que desea hacer?: "
	pedirDecimal: .asciiz "Ingresa un numero decimal:"
	pedirPrimerDecimal: .asciiz "Ingresa el primer numero entero positivo:"
	pedirSegundoDecimal: .asciiz "Ingresa el segundo numero entero positivo:"
	rComplemento1: .asciiz "El complemento a 1 del numero decimal ingresado es:"
	rComplemento2: .asciiz "El complemento a 2 del numero decimal ingresado es:"
	rSuma: .asciiz "La suma binaria de los numeros decimales ingresados es:"
	rResta: .asciiz "La resta binaria de los numeros decimales ingresados es:"	
	numero: .asciiz "Ingrese numero a convertir:"
	saltoLinea: .asciiz "\n"
.text

# Constantes
li $s0,1 # Opcion 1
li $s1,2 # Opcion 2
li $s2,3 # Opcion 3


## Observaciones ##
# li $v0, 4: syscall 4, imprime una cadena.
# la $a0, .data: Se almacena la cadena ingresada en .data en $a0

# li $v0, 6: syscall 6, realiza una lectura de un numero decimal.
# li $v0, 2: syscall 2, imprime un numero flotante.
# li $v0, 10: syscall 10, termina el programa "exit"
# li $v0, 35: syscall 35, imprime el numero almacenado en $a0 en su forma binaria
#################################################################

## Inicio del programa ##
li $v0, 4
la $a0, bienvenida
syscall
li $v0, 4
la $a0, integrantes
syscall
#########################


## Menu del programa ##

# Se muestra el menu del programa
li $v0, 4
la $a0, menu
syscall

# Se pide la opcion 
li $v0, 4
la $a0, pedirOpcion
syscall

# Se almacena la opcion ingresada en $t7
li $v0, 5 		
syscall
add $t7, $zero, $v0
#########################

# Se ejecuta el codigo correspondiente a la opcion ingresada
beq  $t7,$s0, complemento
beq  $t7,$s1, suma
beq  $t7,$s2, resta

#######################  Opcion 1: Complemento a 1 y complemento a 2 ###############################
complemento:
	# se pide el numero entero (positivo o negativo)
	li $v0, 4 
	la $a0, pedirDecimal
	syscall
	li $v0,5
	syscall

	# se copia el valor de $v0 en $t0
	move $t0, $v0
	move $t5, $v0
	
	#si el numero ingresado es menor a 0 se realiza un jump a negativo
	bltz $t5,negativo 
	
	# se convierte el numero en binario
	
	li $t1, 2 # se guarda el valor 2 en $t1 para luego servir 
                  # como denominador en las divisiones
	addi $t3, $zero, 124 # Se inicia desde la ultima posicion del array para llenar desde adelante hacia atras

	binario: 
		beqz $t0, exitBinario
        	divu $t0, $t1 # Se divide $t4 por $t1, la division entera es
		      # almacenada en LO mientras que el resto es almacenado en HI,
		      # esto implica: LO = $t4 / 2, HI = $t4 % 2
        	mfhi $t2 # esta funcion permite acceder a la variable HI que fue obtenida
        	 	 # por la funcion divu, este valor es almacenado en $t2
        	 
        	mflo $t0 # esta funcion permite acceder a la variable LO que fue obtenida
                 	 # por la funcion divu, este valor es almacenado en $t4
        
        	sw $t2, array1($t3) 
        	
       		addi $t3, $t3, -4 # Se actualzia el contador
        
	        j binario
	exitBinario:
	
	############################### C1 y C2 para numeros positivos #####################################
	# en caso de que sea un numero entero positivo, el complemento a 1 y complemento a 2
	# es el mismo que su representacion en binario del numero positivo que el numero negativo
	# por lo que se entrega el resultado inmediatamente sin hacer una conversion
	
	# se muestra el resultado del complemento a 1 y 2 para el numero ingresado
	li $v0, 4
	la $a0, rComplemento1
	syscall 
	addi $t2, $zero, 1 # identificador para no mostrar el codigo de complemento a 2 (mostrar C2)
	addi $t3, $zero, 0 # se inicia el contador desde 0 para mostrar el array desde el primer elemento
	mostrarC1:
		bge $t3, 128, exitMostrarC1
	
		lw $t6, array1($t3)
		li $v0, 1
		move $a0, $t6  # se almacena el bit en $a0 para ser mostrado
                       		# por pantalla.
        	syscall
        
        	addi $t3, $t3, 4
        	j mostrarC1
	exitMostrarC1: 
		li $v0, 4
		la $a0, saltoLinea   
		syscall
		li $v0, 4
		la $a0, rComplemento2
		syscall 
		addi $t3, $zero, 0 # se resetea el indicador de posicion
	mostrarC2Positive:
		bge $t3, 128, exitMostrarC2Positive
	
		lw $t6, array1($t3)
		li $v0, 1
		move $a0, $t6  # se almacena el bit en $a0 para ser mostrado
                       		# por pantalla.
        	syscall
        
        	addi $t3, $t3, 4
        	j mostrarC2Positive
	exitMostrarC2Positive: 
		beq $t2, 1, exitMostrarC2
		li $v0, 4
		la $a0, saltoLinea   
		syscall
		li $v0, 4
		la $a0, rComplemento2
		syscall 
		addi $t3, $zero, 0 # se resetea el indicador de posicion
		
	mostrarC2:
		bge $t3, 128, exitMostrarC2
	
		lw $t6, opArray($t3)
		li $v0, 1
		move $a0, $t6  # se almacena el bit en $a0 para ser mostrado
                       		# por pantalla.
        	syscall
        
        	addi $t3, $t3, 4
        	j mostrarC2
	exitMostrarC2:
	j fin
	########################## Fin conversion C1 y C2 numeros positivos ########################
	
negativo:
	# para los complementos a 1 y 2 se utilizara un solo array, ya que para realizar el complemento a 2
        # es necesario realizar el complemento a 1 y luego sumar un 1 a dicha conversion. Por lo tanto, el array1
        # sera ocupado para realizar el complemento a 1, se mostrara por pantalla el resultado y luego, utilizando 
        # el mismo array, se realizara la conversion a complemento a 2
	
	sub $t0, $zero, $t0 # Se hace numero = 0 - numero para obtener el valor abosluto del numero
	
	li $t1, 2 # se guarda el valor 2 en $t1 para luego servir 
                  # como denominador en las divisiones
	addi $t3, $zero, 124 # Se inicia desde la ultima posicion del array para llenar desde adelante hacia atras

	binarioComplement: 
		beqz $t0, exitBinarioComplement
        	divu $t0, $t1 # Se divide $t4 por $t1, la division entera es
		      # almacenada en LO mientras que el resto es almacenado en HI,
		      # esto implica: LO = $t4 / 2, HI = $t4 % 2
        	mfhi $t2 # esta funcion permite acceder a la variable HI que fue obtenida
        	 	 # por la funcion divu, este valor es almacenado en $t2
        	 
        	mflo $t0 # esta funcion permite acceder a la variable LO que fue obtenida
                 	 # por la funcion divu, este valor es almacenado en $t0
        	
        	sw $t2, array1($t3)
        	
       		addi $t3, $t3, -4 # Se actualzia el contador
        
	        j binarioComplement
	exitBinarioComplement:
	
	addi $t3, $zero, 0
	############################### Complemento a 1 numero negativo #####################################
	complementToOne: 
		beq $t3, 128, exitComplementToOne
		lw $t1, array1($t3)
		beqz $t1, binaryToOne  # si el bit es 0 se cambia a 1
		j binaryToZero # si el bit es 1 se cambia a 0
	continue: 
		addi $t3, $t3, 4
		j complementToOne
	exitComplementToOne:
	li $v0, 4
	la $a0, rComplemento1
	syscall 
	addi $t3, $zero, 0 # se inicia el contador desde 0 para mostrar el array desde el primer elemento
	
	showC1:
		beq  $t3, 128, exitShow
	
		lw $t6, array1($t3)
		li $v0, 1
		move $a0, $t6  # se almacena el bit en $a0 para ser mostrado
                       		# por pantalla.
        	syscall
        
        	addi $t3, $t3, 4
        	j showC1
	exitShow: 
	################################### Fin complemento a 1 #############################################
	
	############################### Complemento a 2 numero negativo #####################################
	addi $t3, $zero, 124 # Se inicia desde la ultima posicion del array para llenar desde adelante hacia atras
	
	li $t1, 2 # se guarda el valor 2 en $t1 para luego servir 
                  # como denominador en las divisiones
	addi $t0, $zero, 1
	unoBinario: 
		beqz $t0, exitUnoBinario
        	divu $t0, $t1 # Se divide $t4 por $t1, la division entera es
		      # almacenada en LO mientras que el resto es almacenado en HI,
		      # esto implica: LO = $t4 / 2, HI = $t4 % 2
        	mfhi $t2 # esta funcion permite acceder a la variable HI que fue obtenida
        	 	 # por la funcion divu, este valor es almacenado en $t2
        	 
        	mflo $t0 # esta funcion permite acceder a la variable LO que fue obtenida
                 	 # por la funcion divu, este valor es almacenado en $t4
        
        	sw $t2, array2($t3)
        	
       		addi $t3, $t3, -4 # Se actualzia el contador
        
	        j unoBinario
	exitUnoBinario:
	li $v0, 4
	la $a0, saltoLinea
	addi $t3, $zero, 124
	addi $t2, $zero, 0
	j sumaBinaria
	################################### Fin complemento a 2 #############################################
	j fin
binaryToZero:
	sw $zero, array1($t3)
	j continue
binaryToOne:
	addi $t6, $zero, 1
	sw $t6, array1($t3) 
	j continue
######################################### Fin opcion 1 ####################################################
	
#######################  Opcion 2: Suma binaria de dos numeros decimales ###############################
suma:

	# Se pide el primer numero entero positivo
	li $v0, 4
	la $a0, pedirPrimerDecimal
	syscall
	li $v0, 5
	syscall

	# Se almacena el primer numero decimal en el registro temporal $t4
	move $t4, $v0
	
	# Se pide el segundo numero entero positivo
	li $v0, 4
	la $a0, pedirSegundoDecimal
	syscall
	li $v0, 5
	syscall
	
	# Se almacena el segundo numero decimal en el registro temporal $t5
	move $t5,$v0

############################## Numeros a binarios ####################################
li $t1, 2 # se guarda el valor 2 en $t1 para luego servir 
          # como denominador en las divisiones
addi $t3, $zero, 124 # Se inicia desde la ultima posicion del array para llenar desde adelante hacia atras

primerNumeroBinario: 
	beqz $t4, exitPrimerNumeroBinario
        divu $t4, $t1 # Se divide $t4 por $t1, la division entera es
		      # almacenada en LO mientras que el resto es almacenado en HI,
		      # esto implica: LO = $t4 / 2, HI = $t4 % 2
        mfhi $t2 # esta funcion permite acceder a la variable HI que fue obtenida
        	 # por la funcion divu, este valor es almacenado en $t2
        	 
        mflo $t4 # esta funcion permite acceder a la variable LO que fue obtenida
                 # por la funcion divu, este valor es almacenado en $t4
        
        sw $t2, array1($t3) # Se agrega el bit correspondiente calculado
        addi $t3, $t3, -4 # Se actualzia el contador
        
        j primerNumeroBinario
exitPrimerNumeroBinario:

addi $t3, $zero, 124 # se resetea el indicador de posicion

segundoNumeroBinario: 
	beqz $t5, exitSegundoNumeroBinario
	
        divu $t5, $t1 # Se divide $t4 por $t1, la division entera es
		      # almacenada en LO mientras que el resto es almacenado en HI,
		      # esto implica: LO = $t4 / 2, HI = $t4 % 2
        mfhi $t2 # esta funcion permite acceder a la variable HI que fue obtenida
        	 # por la funcion divu, este valor es almacenado en $t2
        	 
        mflo $t5 # esta funcion permite acceder a la variable LO que fue obtenida
                 # por la funcion divu, este valor es almacenado en $t4
        
        sw $t2, array2($t3) # Se agrega el bit correspondiente calculado
        addi $t3, $t3, -4 # Se actualzia el contador
        
        j segundoNumeroBinario
exitSegundoNumeroBinario:
################################## Fin de la conversion ###############################
addi $t3, $zero, 124 # se acualiza el contador para comenzar a iterar desde la ultima posicion
addi $t5, $zero, 0
addi $t2, $zero, 1 # Identificador para saltar la linea (beq $t6, $zero, exitMostrarC1)
sumaBinaria:
	beqz $t3, exitSumaBinaria
	
	lw $t0, array1($t3) # Se almacena en $t0 el bit del primer numero
	lw $t1, array2($t3) # Se almacena en $t1 el bit del segundo numero
	add $t4, $t0, $t1 # Se suman los bits
	
	beq $t0, $zero, zero
	j one
continuarSuma:
	addi $t3, $t3, -4
	j sumaBinaria
	
exitSumaBinaria:

beqz  $t2, exitMostrarC2Positive
####### Se muestra la suma binaria obtenida ##############
addi $t3, $zero, 0
li $v0, 4
la $a0, rSuma
syscall
mostrarSuma:
	bge $t3, 128, exitSuma
	
	lw $t6, opArray($t3)
	li $v0, 1
	move $a0, $t6  # se almacena el bit en $a0 para ser mostrado
                       # por pantalla.
        syscall
        
        addi $t3, $t3, 4
        j mostrarSuma
exitSuma: 
	li $v0, 4
	la $a0, saltoLinea   
	syscall
	addi $t3, $zero, 0 # se resetea el indicador de posicion

################### Fin del ciclo para mostrar la suma ######################
j fin # finaliza el programa
######################################### Fin opcion 2 ####################################################	
	
#######################  Opcion 3: Resta binaria de dos numeros decimales ###############################
#######################  Opcion 3: Resta binaria de dos numeros decimales ###############################

resta:

	# Se pide el primer numero entero positivo
	li $v0, 4
	la $a0, pedirPrimerDecimal
	syscall
	li $v0, 5
	syscall

	# Se almacena el primer numero decimal en el registro temporal $t4
	move $t4, $v0
	
	# Se pide el segundo numero entero positivo
	li $v0, 4
	la $a0, pedirSegundoDecimal
	syscall
	li $v0, 5
	syscall
	
	# Se almacena el segundo numero decimal en el registro temporal $t5
	move $t5,$v0

############################## Numeros a binarios ####################################
li $t1, 2 # se guarda el valor 2 en $t1 para luego servir 
          # como denominador en las divisiones
addi $t3, $zero, 124 # Se inicia desde la ultima posicion del array para llenar desde adelante hacia atras

primerNumeroBinarioDeResta: 
	beqz $t4, exitPrimerNumeroBinarioDeResta
        divu $t4, $t1 # Se divide $t4 por $t1, la division entera es
		      # almacenada en LO mientras que el resto es almacenado en HI,
		      # esto implica: LO = $t4 / 2, HI = $t4 % 2
        mfhi $t2 # esta funcion permite acceder a la variable HI que fue obtenida
        	 # por la funcion divu, este valor es almacenado en $t2
        	 
        mflo $t4 # esta funcion permite acceder a la variable LO que fue obtenida
                 # por la funcion divu, este valor es almacenado en $t4
        
        sw $t2, array1($t3) # Se agrega el bit correspondiente calculado
        addi $t3, $t3, -4 # Se actualzia el contador
        
        j primerNumeroBinarioDeResta
exitPrimerNumeroBinarioDeResta:

addi $t3, $zero, 124 # se resetea el indicador de posicion

segundoNumeroBinarioDeResta: 
	beqz $t5, exitSegundoNumeroBinarioDeResta
	
        divu $t5, $t1 # Se divide $t4 por $t1, la division entera es
		      # almacenada en LO mientras que el resto es almacenado en HI,
		      # esto implica: LO = $t4 / 2, HI = $t4 % 2
        mfhi $t2 # esta funcion permite acceder a la variable HI que fue obtenida
        	 # por la funcion divu, este valor es almacenado en $t2
        	 
        mflo $t5 # esta funcion permite acceder a la variable LO que fue obtenida
                 # por la funcion divu, este valor es almacenado en $t4
        
        sw $t2, array2($t3) # Se agrega el bit correspondiente calculado
        addi $t3, $t3, -4 # Se actualzia el contador
        
        j segundoNumeroBinarioDeResta
exitSegundoNumeroBinarioDeResta:
################################## Fin de la conversion ###############################
addi $t3, $zero, 124 # se acualiza el contador para comenzar a iterar desde la ultima posicion
addi $t5, $zero, 0 #acumulador

restaBinaria:
	beqz $t3, exitRestaBinaria
	
	lw $t0, array1($t3) # Se almacena en $t0 el bit del primer numero
	lw $t1, array2($t3) # Se almacena en $t1 el bit del segundo numero
	sub $t4, $t0, $t1 # Se restan los bits
	sub $t4,$t4,$t5 #Restamos el acumulador igual 
	
	beq $t4, $zero, zeroResta
	beq $t4, 1, zeroResta1
	beq $t4, -1, zeroResta2
	beq $t4, -2, zeroResta3
	
continuarResta:
	addi $t3, $t3, -4
	j restaBinaria
	
exitRestaBinaria:

####### Se muestra la resta binaria obtenida ##############
addi $t3, $zero, 0
li $v0, 4
la $a0, rResta
syscall
mostrarResta:
	#beq $t4,0,reverso
	bge $t3, 128, exitResta
	
	lw $t6, opArray($t3)
	li $v0, 1
	move $a0, $t6  # se almacena el bit en $a0 para ser mostrado
                       # por pantalla.
        syscall
        
        addi $t3, $t3, 4
        j mostrarResta
        
exitResta: 
	li $v0, 4
	la $a0, saltoLinea   
	syscall
	addi $t3, $zero, 0 # se resetea el indicador de posicion
	
################### Fin del ciclo para mostrar la suma ######################
j fin # finaliza el programa
######################################### Fin opcion 3 ####################################################	
	
fin:

	# Se termina el codigo
	li $v0, 10
	syscall
	
	########### Funciones de resta ################

zeroResta:
	sw $t4, opArray($t3)
	addi $t5,$zero,0
	j continuarResta
	
zeroResta1:
	sw $t4, opArray($t3)
	addi $t5,$zero,0
	j continuarResta

zeroResta2:
	addi $t4, $t4, 2
	beq $t5,0,cambio
	
	sw $t4, opArray($t3)
	j continuarResta
	
zeroResta3:
	addi $t4, $t4, 2
	beq $t5,0,cambio
	
	sw $t4, opArray($t3)
	j continuarResta

cambio:
	addi $t5,$zero,1
	sw $t4, opArray($t3)
	j continuarResta
	
	################ Fcuniones de suma ########
zero:
	beq $t0, $t1, zeroWithZero
	j zeroWithOne
zeroWithZero: # Si la suma es 0 + 0 se coloca dicha suma + el acumulador
	add $t4, $t4, $t5
	addi $t5, $zero, 0 # se resetea el acarreador a 0
	
	sw $t4, opArray($t3)
	j continuarSuma
zeroWithOne: # Si la suma es 0 + 1 se coloca dicha suma + el acumulador
	beq $t4, $t5, actualizarAcarreoToZero # Si la suma anterior mas el acumulador es 1 + 1, se realiza un jump hacia oneWithOne
		
	addi $t5, $zero, 0 # se resetear el acarreador ya que se realiza una suma 1 + 0 + 0 o 0 + 1 + 0 ($t0 + $t1 + acarreo)
	sw $t4, opArray($t3)
	j continuarSuma
one:
	beq $t0, $t1, oneWithOne
	j zeroWithOne # es lo mismo 1 + 0 que 0 + 1
oneWithOne:
	addi $t7, $zero, 3 # se almacena el valor 3 en $t7 para verificar si la suma es 1 + 1 + 1 (suma con acarreo = 1)
	add $t4, $t4, $t5
	beq $t4, $t7, actualizarAcarreoToOne
	
	sw $zero, opArray($t3) # se coloca un 0 en caso de que sea 1 + 1 + 0 ($t0 + $t1 + acarreo)
	addi $t5, $zero, 1
	j continuarSuma
	
actualizarAcarreoToZero:
	addi $t5, $zero, 1
	
	sw $zero, opArray($t3) # se coloca un 0 en caso de que sea 1 + 0 + 1 o 0 + 1 + 1 ($t0 + $t1 + acarreo)
	j continuarSuma
	
actualizarAcarreoToOne:
	addi $t5, $zero, 1
	
	sw $t5, opArray($t3) # se coloca un 1 en caso de que sea 1 + 1 + 1 ($t0 + $t1 + acarreo)
	j continuarSuma
