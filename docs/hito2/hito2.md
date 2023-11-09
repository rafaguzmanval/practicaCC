# Hito 2: Tests

Se han realizado tres test de unidad.

En el primero se registra al usuario

En el segundo se prueba a colgar una publicación en la aplicación y un producto 

En el tercero se elimina al usuario

## Makefile para ejecutar los tests

Por favor, asegurarse de que el makefile se ejecuta desde el directorio donde se encuentra

```makefile

test: INITServer tests KILLserver

INITServer:
	cd ../app/backend &&  nohup node app.js &
	 
tests: 
	cd ../app/frontend && flutter test test/test_unidad1.dart > test_result.txt  && flutter test test/test_unidad2.dart >> test_result.txt && flutter test test/test_unidad3.dart >> test_result.txt

KILLserver:
	pkill node

```


## Resultados de los test

![Resultados test](../imgs/test%20pasados.png)


