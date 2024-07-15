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

;Dibuja el triangulo de la opcion 1
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

;Empieza el proceso de la opcion 2 (dibujar un gato)
opcion2:
    JMP IniciarModoFigura

    RET

;Iniciamos el modo video
IniciarModoFigura:
    MOV AH, 0h
    MOV AL, 12h      ; Modo gráfico 640x480, 16 colores
    INT 10h
        
    JMP EncenderPixelFiguraCara
    
    RET

;Dibuja el rectangulo del rostro
EncenderPixelFiguraCara:
    MOV AH, 0Ch       ; Función del BIOS para poner un píxel
    MOV AL, 1001b     ; Color del píxel (azul)
    MOV BH, 0         ; Página de video 0
    MOV CX, SI        ; Coordenada X
    MOV DX, DI        ; Coordenada Y
    INT 10h           ; Enciende el píxel
      
    INC SI            ; Incrementa la columna
    CMP SI, 500d      ; Compara la columna actual con el límite de 190
    JNE EncenderPixelFiguraCara ; Continúa en la misma fila si no se alcanza el límite
      
    ; Al alcanzar el límite de la fila, prepara la siguiente fila
    INC DI            ; Incrementa la fila
    MOV SI, 90d       ; Reinicia la columna al inicio para la nueva fila
      
    CMP DI, 300d      ; Compara la fila actual con el límite de 120
    JNE EncenderPixelFiguraCara ; Si no se alcanza el límite, continúa dibujando la fila
    
    ;Llamada para oreja 1
    MOV SI, 110d ; Columna inicial
    MOV DI, 50d ; Fila inicial

    MOV BP, 50d ; contador PARA AUMENTAR LA FILA INICIAL

    JMP EncenderPixelFiguraOreja

    RET               ; Termina la función cuando el rectángulo está completo

;Dibuja la mitad de la primera oreja
EncenderPixelFiguraOreja:
    MOV AH, 0Ch       ; Función del BIOS para poner un píxel
    MOV AL, 1100b     ; Color del píxel (azul)
    MOV BH, 0         ; Página de video 0
    MOV CX, SI        ; Coordenada X
    MOV DX, DI        ; Coordenada Y
    INT 10h           ; Enciende el píxel

    INC DI
    CMP DI, 70d 
    JNE EncenderPixelFiguraOreja

    INC SI            ; Incrementa la columna
    INC BP

    CMP BP, 70d
    JE ConfigFiguraOtraParteOreja1

    MOV DI, BP

    CMP SI, 130d      ; Compara la columna actual con el límite de 190
    JNE EncenderPixelFiguraOreja

    RET

ConfigFiguraOtraParteOreja1:
    ;Llamada para oreja 2
    MOV SI, 110d ; Columna inicial
    MOV DI, 50d ; Fila inicial

    MOV BP, 50d ; contador PARA AUMENTAR LA FILA INICIAL

    JMP EncenderPixelFiguraOtraParteOreja1

    RET

;Dibuja la otra mitad de la primera oreja
EncenderPixelFiguraOtraParteOreja1:
    MOV AH, 0Ch       ; Función del BIOS para poner un píxel
    MOV AL, 1100b     ; Color del píxel (azul)
    MOV BH, 0         ; Página de video 0
    MOV CX, SI        ; Coordenada X
    MOV DX, DI        ; Coordenada Y
    INT 10h           ; Enciende el píxel

    INC DI
    CMP DI, 70d 
    JNE EncenderPixelFiguraOtraParteOreja1

    DEC SI            ; Incrementa la columna
    INC BP

    CMP BP, 70d
    JE ConfigFiguraOtraOreja

    MOV DI, BP

    CMP SI, 90d      ; Compara la columna actual con el límite de 190
    JNE EncenderPixelFiguraOtraParteOreja1

    RET

ConfigFiguraOtraOreja:
    ;Llamada para oreja 2
    MOV SI, 480d ; Columna inicial
    MOV DI, 50d ; Fila inicial

    MOV BP, 50d ; contador PARA AUMENTAR LA FILA INICIAL

    JMP EncenderPixelFiguraOtraOreja

    RET

;Dibuja la mitad de la segunda oreja
EncenderPixelFiguraOtraOreja:
    MOV AH, 0Ch       ; Función del BIOS para poner un píxel
    MOV AL, 1100b     ; Color del píxel (azul)
    MOV BH, 0         ; Página de video 0
    MOV CX, SI        ; Coordenada X
    MOV DX, DI        ; Coordenada Y
    INT 10h           ; Enciende el píxel

    INC DI
    CMP DI, 70d 
    JNE EncenderPixelFiguraOtraOreja

    INC SI            ; Incrementa la columna
    INC BP

    CMP BP, 70d
    JE ConfigFiguraOtraParteOreja2

    MOV DI, BP

    CMP SI, 500d      ; Compara la columna actual con el límite de 190
    JNE EncenderPixelFiguraOtraOreja

    RET

ConfigFiguraOtraParteOreja2:
    ;Llamada para oreja 2
    MOV SI, 480d ; Columna inicial
    MOV DI, 50d ; Fila inicial

    MOV BP, 50d ; contador PARA AUMENTAR LA FILA INICIAL

    JMP EncenderPixelFiguraOtraParteOreja2

    RET

;Dibuja la otra mitad de la segunda oreja
EncenderPixelFiguraOtraParteOreja2:
    MOV AH, 0Ch       ; Función del BIOS para poner un píxel
    MOV AL, 1100b     ; Color del píxel (azul)
    MOV BH, 0         ; Página de video 0
    MOV CX, SI        ; Coordenada X
    MOV DX, DI        ; Coordenada Y
    INT 10h           ; Enciende el píxel

    INC DI ;Incrementamos 1 a la final
    CMP DI, 70d ;Comparamos si no ha llegado al limite que deseamos
    JNE EncenderPixelFiguraOtraParteOreja2

    DEC SI            ; Incrementa la columna
    INC BP              ;Me ayudo de un contador para llevar el control de hasta donde llegar

    CMP BP, 70d   ;Comparamos si la variable auxiliar no ha llegado al limite que deseamos
    JE ConfigFiguraNariz

    MOV DI, BP

    CMP SI, 460d      ; Compara la columna actual con el límite de 190
    JNE EncenderPixelFiguraOtraParteOreja2

    RET

ConfigFiguraNariz:
    ;Llamada para nariz
    MOV SI, 300d ; Columna inicial
    MOV DI, 150d ; Fila inicial
    
    MOV BP, 150d ; contador PARA AUMENTAR LA FILA INICIAL
    
    JMP EncenderPixelFiguraNariz
    
    RET

;Dibuja la mitad de la nariz
EncenderPixelFiguraNariz:
    MOV AH, 0Ch       ; Función del BIOS para poner un píxel
    MOV AL, 0010b     ; Color del píxel (azul)
    MOV BH, 0         ; Página de video 0
    MOV CX, SI        ; Coordenada X
    MOV DX, DI        ; Coordenada Y
    INT 10h           ; Enciende el píxel
    
    INC DI
    CMP DI, 200d 
    JNE EncenderPixelFiguraNariz
    
    INC SI            ; Incrementa la columna
    INC BP
    
    CMP BP, 200d
    JE ConfigFiguraOtraNariz
    
    MOV DI, BP
    
    CMP SI, 400d      ; Compara la columna actual con el límite de 190
    JNE EncenderPixelFiguraNariz
    
    RET

;Reestablece las variables para no chocar con otros valores antes de dibujar
ConfigFiguraOtraNariz:
    ;Llamada para oreja 2
    MOV SI, 300d ; Columna inicial
    MOV DI, 150d ; Fila inicial

    MOV BP, 150d ; contador PARA AUMENTAR LA FILA INICIAL

    JMP EncenderPixelFiguraOtraNariz

    RET

;Dibuja la otra mitad de la nariz
EncenderPixelFiguraOtraNariz:
    MOV AH, 0Ch       ; Función del BIOS para poner un píxel
    MOV AL, 0010b     ; Color del píxel (azul)
    MOV BH, 0         ; Página de video 0
    MOV CX, SI        ; Coordenada X
    MOV DX, DI        ; Coordenada Y
    INT 10h           ; Enciende el píxel

    INC DI
    CMP DI, 200d 
    JNE EncenderPixelFiguraOtraNariz

    DEC SI            ; Incrementa la columna
    INC BP

    CMP BP, 200d
    JE ConfigFiguraBigotesUno ;Inicia el proceso para dibujar el primer bigote

    MOV DI, BP

    CMP SI, 200d      ; Compara la columna actual con el límite de 190
    JNE EncenderPixelFiguraOtraNariz

    RET

;Reestablece las variables para no chocar con otros valores antes de dibujar
ConfigFiguraBigotesUno:
    ;Llamada para nariz
    MOV SI, 30d ; Columna inicial
    MOV DI, 150d ; Fila inicial
    
    ;MOV BP, 150d ; contador PARA AUMENTAR LA FILA INICIAL
    
    JMP EncenderPixelFiguraBigote
    
    RET

;Dibuja el primer bigote (La primera linea)
EncenderPixelFiguraBigote:
    MOV AH, 0Ch       ; Función del BIOS para poner un píxel
    MOV AL, 1010b     ; Color del píxel (azul)
    MOV BH, 0         ; Página de video 0
    MOV CX, SI        ; Coordenada X
    MOV DX, DI        ; Coordenada Y
    INT 10h

    INC SI  ;Incrementa en 1 la columna para encender el siguiente pixel del bigote
    CMP SI, 130d  ;Compara si llego al limite establecido para acabar el bigote
    JNE EncenderPixelFiguraBigote
    JE ConfigFiguraBigotesDos ;Inicia el proceso para dibujar el segundo bigote

    RET

;Reestablece las variables para no chocar con otros valores antes de dibujar
ConfigFiguraBigotesDos:
    ;Llamada para nariz
    MOV SI, 30d ; Columna inicial
    MOV DI, 175d ; Fila inicial
        
    ;MOV BP, 150d ; contador PARA AUMENTAR LA FILA INICIAL
        
    JMP EncenderPixelFiguraBigoteDos
        
    RET

;Dibuja el segundo bigote (La segunda linea)   
EncenderPixelFiguraBigoteDos:
    MOV AH, 0Ch       ; Función del BIOS para poner un píxel
    MOV AL, 1010b     ; Color del píxel (azul)
    MOV BH, 0         ; Página de video 0
    MOV CX, SI        ; Coordenada X
    MOV DX, DI        ; Coordenada Y
    INT 10h
    
    INC SI  ;Incrementa en 1 la columna para encender el siguiente pixel del bigote
    CMP SI, 130d  ;Compara si llego al limite establecido para acabar el bigote
    JNE EncenderPixelFiguraBigoteDos
    JE ConfigFiguraBigotesTres ;Inicia el proceso para dibujar el tercer bigote
    
    RET

;Reestablece las variables para no chocar con otros valores antes de dibujar
ConfigFiguraBigotesTres:
    ;Llamada para nariz
    MOV SI, 30d ; Columna inicial
    MOV DI, 200d ; Fila inicial
            
    ;MOV BP, 150d ; contador PARA AUMENTAR LA FILA INICIAL
            
    JMP EncenderPixelFiguraBigoteTres ;Llama a la funcion para el bigote tres
            
    RET

;Dibuja el tercer bigote (La tercer linea)
EncenderPixelFiguraBigoteTres:
    MOV AH, 0Ch       ; Función del BIOS para poner un píxel
    MOV AL, 1010b     ; Color del píxel (azul)
    MOV BH, 0         ; Página de video 0
    MOV CX, SI        ; Coordenada X
    MOV DX, DI        ; Coordenada Y
    INT 10h
        
    INC SI  ;Incrementa en 1 la columna para encender el siguiente pixel del bigote
    CMP SI, 130d  ;Compara si llego al limite establecido para acabar el bigote
    JNE EncenderPixelFiguraBigoteTres
    JE ConfigFiguraBigotesCuatro ;Inicia el proceso para dibujar el cuarto bigote
        
    RET

;Reestablece las variables para no chocar con otros valores antes de dibujar
ConfigFiguraBigotesCuatro:
    ;Llamada para nariz
    MOV SI, 450d ; Columna inicial
    MOV DI, 150d ; Fila inicial
                
    ;MOV BP, 150d ; contador PARA AUMENTAR LA FILA INICIAL
                
    JMP EncenderPixelFiguraBigoteCuatro
                
    RET

;Dibuja el cuarto bigote (La cuarta linea)           
EncenderPixelFiguraBigoteCuatro:
    MOV AH, 0Ch       ; Función del BIOS para poner un píxel
    MOV AL, 1010b     ; Color del píxel (azul)
    MOV BH, 0         ; Página de video 0
    MOV CX, SI        ; Coordenada X
    MOV DX, DI        ; Coordenada Y
    INT 10h
            
    INC SI  ;Incrementa en 1 la columna para encender el siguiente pixel del bigote
    CMP SI, 550d  ;Compara si llego al limite establecido para acabar el bigote
    JNE EncenderPixelFiguraBigoteCuatro
    JE ConfigFiguraBigotesCinco ;Inicia el proceso para dibujar el quinto bigote
            
    RET

;Reestablece las variables para no chocar con otros valores antes de dibujar
ConfigFiguraBigotesCinco:
    ;Llamada para nariz
    MOV SI, 450d ; Columna inicial
    MOV DI, 175d ; Fila inicial
                    
    ;MOV BP, 150d ; contador PARA AUMENTAR LA FILA INICIAL
                    
    JMP EncenderPixelFiguraBigoteCinco
                    
    RET

;Dibuja el quinto bigote (La quinta linea)             
EncenderPixelFiguraBigoteCinco:
    MOV AH, 0Ch       ; Función del BIOS para poner un píxel
    MOV AL, 1010b     ; Color del píxel (azul)
    MOV BH, 0         ; Página de video 0
    MOV CX, SI        ; Coordenada X
    MOV DX, DI        ; Coordenada Y
    INT 10h
                
    INC SI  ;Incrementa en 1 la columna para encender el siguiente pixel del bigote
    CMP SI, 550d  ;Compara si llego al limite establecido para acabar el bigote
    JNE EncenderPixelFiguraBigoteCinco
    JE ConfigFiguraBigotesSeis ;Inicia el proceso para dibujar el sexto bigote
                
    RET

;Reestablece las variables para no chocar con otros valores antes de dibujar
ConfigFiguraBigotesSeis:
    ;Llamada para nariz
    MOV SI, 450d ; Columna inicial
    MOV DI, 200d ; Fila inicial
                        
    ;MOV BP, 150d ; contador PARA AUMENTAR LA FILA INICIAL
                        
    JMP EncenderPixelFiguraBigoteSeis
                        
    RET

;Dibuja el sexto bigote (La sexta linea)         
EncenderPixelFiguraBigoteSeis:
    MOV AH, 0Ch       ; Función del BIOS para poner un píxel
    MOV AL, 1010b     ; Color del píxel (azul)
    MOV BH, 0         ; Página de video 0
    MOV CX, SI        ; Coordenada X
    MOV DX, DI        ; Coordenada Y
    INT 10h
                    
    INC SI      ;Incrementa en 1 la columna para encender el siguiente pixel del bigote
    CMP SI, 550d ;Compara si llego al limite establecido para acabar el bigote
    JNE EncenderPixelFiguraBigoteSeis
    JE EsperarTecla ;Termina de dibujar y espera una tecla para regresar al menu
                    
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