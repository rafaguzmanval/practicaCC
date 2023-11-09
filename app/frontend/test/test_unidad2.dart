import 'dart:convert';
import 'dart:io';
import 'package:instafoto/Sesion.dart';
import 'package:instafoto/home.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:instafoto/ajustes.dart';
import 'package:instafoto/login.dart';

import 'package:instafoto/main.dart';
import 'package:instafoto/nuevaPublicacion.dart';
import 'package:instafoto/publicacion.dart';
import 'package:instafoto/registro.dart';
import 'package:instafoto/usuario.dart';
import 'package:http/http.dart' as http;
import 'package:instafoto/respuestaHTTP.dart';
import 'package:integration_test/integration_test.dart';


Future<File> obtenerImagenPrueba() async{
  /// Se descarga una imagen de prueba para subirla al servidor
  final response = await http.get(
      Uri.parse('https://upload.wikimedia.org/' +
          'wikipedia/commons/thumb/d/d7/ETSIIT_Universidad_de_Granada.jpg/640px-ETSIIT_Universidad_de_Granada.jpg'));
  String path = "archivoprueba.jpg";
  File file = await File(path).writeAsBytes(response.bodyBytes);

  return file;

}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = new MyHttpOverrides();

  late RespuestaHTTP resultadoLogIn;
  late RespuestaHTTP resultadoPublicacion;

  Usuario usuario1 =
      new Usuario("Pepe", "clave123", "pepe@mail.com", "882134812");

  String token = "";

  group("Inicio de sesión", () {
    test("Se inicia sesión", () async {
      Login login = Login(title: "login");

      resultadoLogIn = await login.login(
          context: null, correo: usuario1.correo, clave: usuario1.clave);

      token = resultadoLogIn.body;

      expect(resultadoLogIn.status, 200);
      print(resultadoLogIn.toString());
    });
  });

  group("Test HU1", () {


        group("Publicación y borrado", () {

        test("Se publica una foto", () async {

          File archivoPrueba = await obtenerImagenPrueba();

          /// se lleva a cabo la prueba

          NuevaPublicacion nuevaPublicacion = NuevaPublicacion(archivo: archivoPrueba);

          resultadoPublicacion =
          await nuevaPublicacion.subirArchivo(context: null,
              auth: token,
              usuario: usuario1.nombre,
              descripcion: "fotodeprueba",
              tipo: tipoPublicacion.imagen);

          print(resultadoPublicacion.toString());
          expect(resultadoPublicacion.status, 200);


        });

        
        test("No se borra la foto con token erróneo", () async {
          var id = jsonDecode(resultadoPublicacion.body)['id'];

          Publicacion publicacion = Publicacion(
              usuario: usuario1.nombre, id: id);

          RespuestaHTTP res = await publicacion.borrar(id: id,auth: "tokenfalso");

          print(res.toString());
          expect(res.status, 401);

        });

        test("Se borra la foto", () async {
          var id = jsonDecode(resultadoPublicacion.body)['id'];

          Publicacion publicacion = Publicacion(
              usuario: usuario1.nombre, id: id);

          RespuestaHTTP res = await publicacion.borrar(id: id,auth: token);

          print(res.toString());
          expect(res.status, 200);

        });
              
      });


      group("Producto", () {
        test("Se publica un producto", () async {

          /// Se descarga una imagen de prueba para subirla al servidor

          final response = await http.get(
              Uri.parse('https://upload.wikimedia.org/' +
                  'wikipedia/commons/thumb/d/d7/ETSIIT_Universidad_de_Granada.jpg/640px-ETSIIT_Universidad_de_Granada.jpg'));

          String path = "archivoprueba.jpg";
          File file = await File(path).writeAsBytes(response.bodyBytes);

          NuevaPublicacion nuevaPublicacion = NuevaPublicacion(archivo: file);
          resultadoPublicacion =
          await nuevaPublicacion.subirArchivo(context: null,
              auth: token,
              usuario: usuario1.nombre,
              descripcion: "productop",
              tipo: tipoPublicacion.producto
              ,
              precio: "1000",
              descripcionProducto: "nuevo producto",
              categoria: "Otros");

          print(resultadoPublicacion.toString());
          expect(resultadoPublicacion.status, 200);

        });

        test("Se busca el producto", () async {
          List resultado = await busqueda(patron: "productop",
              modo: modoBusqueda.productos,
              categoria: "Otros");
          // el status de la respuesta es 400 ya que es un error del cliente

          // el segundo elemendo es un json que puede ser iterado como una lista en dart
          List productos = (resultado[1] as List)
              .map((e) => e['descripcion'])
              .toList();

          expect(productos.contains("productop"), true);
          print("lista de productos devuelta: " + productos.toString());
        });
      });


    test("Eliminando al usuario", () async {

      // Se inicia sesion para obtener el token necesario para poder eliminar la cuenta
      resultadoLogIn = await Login(title: "login",).login(
      context: null, correo: usuario1.correo, clave: usuario1.clave);

      token = resultadoLogIn.body;


      RespuestaHTTP res = await eliminarCuenta(
          context: null,
          usuario: usuario1.nombre,
          clave: usuario1.clave,
          token: token);

      //debe de dar un resultado correcto
      expect(res.status, 200);

    });

    test("¿Se puede buscar al nuevo usuario registrado?", () async {
      List resultado =
          await busqueda(patron: usuario1.nombre, modo: modoBusqueda.perfiles);
      // el status de la respuesta es 400 ya que es un error del cliente

      // el segundo elemendo es un json que puede ser iterado como una lista en dart
      List nombres = (resultado[1] as List).map((e) => e['nombre']).toList();
      expect(nombres.contains(usuario1.nombre), false);
    });


  });
}
