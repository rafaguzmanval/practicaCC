# Hito 1 

## Historias de Usuario

### [HU1: Como usuario base de la aplicación, quiero poder subir imágenes de mi móvil a la plataforma para compartirlas con mis amigos y también tener la posibilidad de clasificar esa publicación como un producto con un precio para venderlo historia de usuario](https://github.com/rafaguzmanval/practicaCC/issues/1)

### [HU2: Como usuario base quiero poder chatear con otros usuarios y poder hacerles transferencias de dinero si quiero comprarles un producto que tengan a la venta historia de usuario](https://github.com/rafaguzmanval/practicaCC/issues/2)

### [HU3: Como usuario base quiero que se me facilite la manera de conocer a nuevos usuarios de la aplicación tanto para amistad como para una cita historia de usuario](https://github.com/rafaguzmanval/practicaCC/issues/3)

### [HU4: Como usuario base de la aplicación quiero poder entrar en un entorno en 3D donde pueda interactuar con otros usuarios y poder jugar a algo o hacer algo divertido historia de usuario](https://github.com/rafaguzmanval/practicaCC/issues/4)

### [HU5: Como moderador quiero tener una lista de todas las publicaciones que han sido denunciadas para poder decidir cuál borrar en caso de no respetar las normas de la comunidad historia de usuario](https://github.com/rafaguzmanval/practicaCC/issues/5)


## Milestones

### [Crear un inicio de sesión seguro](https://github.com/rafaguzmanval/practicaCC/milestone/1)

### [Capturar fotos y subirlas a la plataforma](https://github.com/rafaguzmanval/practicaCC/milestone/2)

### [Sistema de chat](https://github.com/rafaguzmanval/practicaCC/milestone/3)

### [Sala virtual 3D](https://github.com/rafaguzmanval/practicaCC/milestone/4)

### [Cartera online](https://github.com/rafaguzmanval/practicaCC/milestone/5)

### [Sistema de emparejamiento de usuarios](https://github.com/rafaguzmanval/practicaCC/milestone/6)


## Creación de las clases y estructuras de datos iniciales

El servicio de Node.js establecerá una serie de rutas que implementarán un servicio API REST para que todas las peticiones del usuario se operen.
Desde el front-end se desarrollará una clase para la vista de lo que será cada historia de usuario. 

Aunque existen muchas más clases definidas en este proyecto, voy a enumerar las que resuelven principalmente el problema, a pesar de que existen otras clases que sirven de apoyo.

En camara2.dart se resuelve la HU1

chat.dart resuelve HU2

conocer.dart resuelve HU3

salavirtual.dart resuelve HU4

home.dart resuelve HU5 cuándo el usuario que ha iniciado sesión tiene privilegios de moderador

[cc.yaml](/cc.yaml)
```
entidad:
  app/frontend/lib/camara2.dart
  app/frontend/lib/chat.dart
  app/frontend/lib/conocer.dart
  app/frontend/lib/salavirtual.dart
  app/frontend/lib/home.dart
```

    
[Haz click para acceder donde se define la API](/app/backend/app.js)

[Haz click para acceder a todas las clases definidas en el front-end](/app/frontend/lib)