# Hito 6: Composición de servicios.


En este hito se va a desplegar la composición de servicios de la red social Photopop.
Esta aplicación consta de un servicio de Node.js y su base de datos Mysql. Usaré las dos imagenes oficiales
para componerlas y prescindir de una vez por todas de desplegar los servicios directamente en la máquina local.

Tengo el siguiente Docker-compose.yaml

```
services:  
  db:
    image: mysql
    container_name: mysql-db
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: example

  node-backend:
    image: node:20
    user: "node"
    working_dir: /mnt
    environment:
      - NODE_ENV=production
    volumes:
      - ./app/backend:/mnt
    ports:
      - "4000:4000"
    command: "npm start"
    restart: on-failure
    depends_on:
        db:
          condition: service_started
          restart: true


```

En este docker-compose.yaml he definido los dos contenedores que necesito. He puesto en primer lugar el de base de datos, ya que se necesita que esté iniciado antes que el de Node. Esto es porque Node cuándo se inicia pide acceso a la base de datos. 

Para que la base de datos se inicie previamente he puesto el atributo "depends_on" al contenedor de node para que se espere a la condición "service_started"
Y que también se reinicie cuándo tenga algún error.

El contenedor de node tiene el volumen con todo el código que necesita para ejecutarse. He usado la versión 20 ya que la 21 advierte de que partes de mi código han quedado obsoletas.


El resultado es que puedo conectarme al servidor:

![redSocial](/docs/imgs/redSocial.png)





Y los test han podido pasar tan bien como antes:

![tests](/docs/imgs/test%20pasados.png)



