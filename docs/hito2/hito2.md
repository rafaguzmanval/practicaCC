# Hito 2: Tests

Se han realizado tres test de unidad.

En el primero se registra al usuario

En el segundo se prueba a colgar una publicación en la aplicación y un producto 

En el tercero se elimina al usuario

## Makefile para ejecutar los tests

Por favor, asegurarse de que el makefile se ejecuta desde el directorio donde se encuentra

Este makefile se encuentra dentro de la carpeta [test](../../test/Makefile)

```makefile

test: INITServer tests KILLserver

INITServer:
	cd ../app/backend &&  nohup node app.js &
	 
tests: 
	cd ../app/frontend && flutter test test/test_unidad1.dart > test_result.txt  && flutter test test/test_unidad2.dart >> test_result.txt && flutter test test/test_unidad3.dart >> test_result.txt

KILLserver:
	pkill node

```

## Creacion de cc.yaml

Se encuentra en el directorio raiz del repositorio, [cc.yaml](/cc.yaml)

```yaml

lenguaje: javascript dart
fichero_tareas: test/Makefile
test: app/frontend/test/test_unidad1.dart app/frontend/test/test_unidad2.dart app/frontend/test/test_unidad3.dart

entidad:
  app/frontend/lib/camara2.dart
  app/frontend/lib/chat.dart
  app/frontend/lib/conocer.dart
  app/frontend/lib/salavirtual.dart
  app/frontend/lib/home.dart

```

## Resultados de los test

![Resultados test](../imgs/test%20pasados.png)


