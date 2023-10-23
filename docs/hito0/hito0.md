# Hito 0

Teniendo instalado previamente git en mi equipo, voy a realizar los pasos que necesito para cumplir con el hito

## Creación de par de claves

Para generar el par de claves he seguido el [tutorial de Github](https://docs.github.com/es/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent) 

En primer lugar ejecuto el siguiente comando en la terminal \
![generacion de la clave](/docs/imgs/generandoclave.png) 

Una vez que tenemos generada la clave podemos añadirla a GitHub: 

![nueva SSH](/docs/imgs/nuevaSSH.png)


Por último podemos hacer una prueba SSH para comprobar que todo funciona bien

![pruebaSSH](/docs/imgs/pruebassh.png)


## Configuración del nombre y correo

Para que el nombre y correo aparezcan en los commits he introducido los siguientes comandos en la terminal. 

![configuracion nombre y correo](/docs/imgs/gitconfigs.png)

## Edición del perfil
He completado la información que me hacia falta: \
![edicion perfil](/docs/imgs/perfil.png)

## Factor de doble autenticación
Para activar el factor de doble autenticación solo hay que ir a *Settings* y a *Passwords* en la barra lateral izquierda. \
Una vez ahí se puede hacer la configuración y aparecerá un código QR que deberá ser leído con una aplicación de autenticación de 2FA\
![factor configuracion](/docs/imgs/twofactor.png)



