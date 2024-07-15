ORG 100h

SECTION .data
;Guardamos os diferentes mensajes que deseamos mostrar
encabezado db 'Parcial diferido de arquitectura$' ;Debe de indicarse con $ el fin de la cadena
opc1 db 'Para mostrar el triangulo presione 1$'
opc2 db 'Para mnostrar la figura presione 2$'
opc3 db 'Para salir presione 3$'
nombre db 'Kevin Josue Duran Rugamas - 00088020$'

resp1 db 'Ingresaste la opcion del triangulo$'
resp2 db 'Ingresaste la opcion de la figura$'

aux1 db 'Regresar a Menu Principal'
aux2 db 'Salir'

msgfin db 'Fin del programa$'


SECTION .text
setup:
    MOV SI, 90d ; Columna inicial
    MOV DI, 70d ; Fila inicial

    MOV BP, 70d ; contador PARA AUMENTAR LA FILA INICIAL

main:
    CALL IniciarModoTexto

    MOV BH, 0d ; Establece la página 0
    CALL CentrarCursor

    CALL Menu
    
    CALL EscogerOpcion

    CALL EsperarTecla

    MOV AH, 05h
    MOV AL, 04H ; Cambia a la página 2
    INT 10h

    MOV BH, 04d ; Establece la página activa a 2

    CALL CentrarCursor

    CALL MenuAuxiliar ;Mostramos el texto si realmente desea finalizar el programa

    CALL main

IniciarModoTexto:
    MOV AH, 0h
    MOV AL, 03h ; Establece modo texto 80x25
    int 10h ; Llama a la interrupción del BIOS para cambiar el modo texto
    RET

CentrarCursor:
    MOV AH, 02h
    MOV DH, 5 ; Fila central
    MOV DL, 15 ; Columna central
    int 10h ; Llama a la interrupción del BIOS para posicionar el cursor
    RET

CambiarPagina:
    MOV AH, 05h
    MOV AL, 01H ; Cambia a la página 1
    INT 10h
    RET

Menu:
    MOV AH, 09h
    MOV DX, encabezado
    INT 21h

    MOV AH, 02h
    MOV DH, 7 ; Fila siguiente
    MOV DL, 15 ; Misma Columna
    INT 10h

    MOV AH, 09h
    MOV DX, opc1
    INT 21h

    MOV AH, 02h
    MOV DH, 9 ; Fila siguiente
    MOV DL, 15 ; Misma Columna
    INT 10h

    MOV AH, 09h
    MOV DX, opc2
    INT 21h

    MOV AH, 02h
    MOV DH, 11 ; Fila siguiente
    MOV DL, 15 ; Misma Columna 
    INT 10h

    MOV AH, 09h
    MOV DX, opc3
    INT 21h

    MOV AH, 02h
    MOV DH, 20 ; Fila siguiente
    MOV DL, 15 ; Misma Columna
    INT 10h

    MOV AH, 09h
    MOV DX, nombre
    INT 21h

    RET

EscogerOpcion:
    
    MOV AH, 00h         ; Establece la función para leer el carácter
    INT 16h

    ;Se guarda el numero en ASCII del presionado en AL
    CMP AL, 49d ;49 es el numero 1 en codigo ASCII
    JE opcion1 ;Si es igual el caracter presionado con 1 entonces se va a la funcion de mostrar el triangulo

    CMP AL, 50d ;50 es el numero 2 en ASCII
    JE opcion2 ;Si es igual el caracter presionado con 2 entonces se va a la funcion de mostrar figura

    CMP AL, 51d ;51 es el numero 3 en ASCII
    JE opcion3 ; Sale del programa

    JMP EscogerOpcion ;Si presiona cualquier otra tecla el programa se mantendra en el menu

    RET

EsperarTecla:
    MOV AH, 00h
    INT 16h

    ;Volvemos a dejar las variables como al inicio
    MOV SI, 90d ; Columna inicial
    MOV DI, 70d ; Fila inicial
    MOV BP, 70d ; contador PARA AUMENTAR LA FILA INICIAL

    RET

opcion1:
    JMP IniciarModoVideo ;Salta a la funcion para cambiar al modo video

    RET

IniciarModoVideo: ;Aqui se establecen las caracteristicas del modo video deseado
    MOV AH, 0h
    MOV AL, 12h      ; Modo gráfico 640x480, 16 colores
    INT 10h
    
    JMP EncenderPixel ;Funcion para crear la figura deseada

    RET


EncenderPixel:
    MOV AH, 0Ch       ; Función del BIOS para poner un píxel
    MOV AL, 0100b     ; Color del píxel (azul)
    MOV BH, 0         ; Página de video 0
    MOV CX, SI        ; Coordenada X
    MOV DX, DI        ; Coordenada Y
    INT 10h           ; Enciende el píxel

    INC DI
    CMP DI, 250d 
    JNE EncenderPixel

    INC SI            ; Incrementa la columna
    INC BP

    CMP BP, 250d
    JE EsperarTecla

    MOV DI, BP

    CMP SI, 300d      ; Compara la columna actual con el límite de 190
    JNE EncenderPixel
    
    RET ; Termina la función cuando el rectángulo está completo

opcion2:
    MOV AH, 05h
    MOV AL, 01H ; Cambia a la página 1
    INT 10h

    MOV AH, 09h
    MOV DX, resp2 ;Aqui debe ir la figura
    INT 21h
    RET

opcion3:
    MOV AH, 05h
    MOV AL, 01H ; Cambia a la página 1
    INT 10h

    MOV AH, 09h
    MOV DX, msgfin ;Mensaje de fin
    INT 21h
    
    INT 20h
    
    RET

MenuAuxiliar:

    MOV AH, 02h
    MOV DH, 7 ; Fila siguiente
    MOV DL, 15 ; Columna siguiente
    INT 10h

    MOV AH, 09h
    MOV DX, aux1
    INT 21h

    MOV AH, 02h
    MOV DH, 9 ; Fila siguiente
    MOV DL, 16 ; Columna siguiente
    INT 10h

    MOV AH, 09h
    MOV DX, aux2
    INT 21h

    MOV AH, 00h         ; Establece la función para leer el carácter
    INT 16h

    ;Se guarda el numero en ASCII de la tecla presionada en AL
    CMP AL, 49d ;49 es el numero 1 en codigo ASCII
    JE main

    CMP AL, 50d ;50 es el numero 2 en ASCII
    JE salir

    RET

salir:
    MOV AH, 05h
    MOV AL, 03H ; Cambia a la página 1
    INT 10h

    MOV AH, 09h
    MOV DX, msgfin
    INT 21h
    
    INT 20h