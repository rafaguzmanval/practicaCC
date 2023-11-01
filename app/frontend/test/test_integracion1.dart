// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

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




class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

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

    /*IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    setUpAll(() async{

    });

    tearDownAll(() async {
    });*/

    TestWidgetsFlutterBinding.ensureInitialized();
    HttpOverrides.global = new MyHttpOverrides();

    Usuario usuario1 = new Usuario("Pepe", "clave123", "pepe@mail.com", "882134812");


    late RespuestaHTTP resultadoLogIn;
    late RespuestaHTTP resultadoPublicacion;

    String token = "";
    int idPublicacion;


    group("Test de integración 1, sin interfaz de usuario", () {



      group("Registro", () {

        test("Registro con datos correctos", () async {
          Registro registro = new Registro(title: "registro");

          RespuestaHTTP respuestaHttp = await registro.registrar(
              null, usuario1.nombre, usuario1.clave, usuario1.correo,
              usuario1.telefono);

          // el status de la respuesta es 200
          expect(respuestaHttp.status, 200);
          print(respuestaHttp.toString());
        });

        test(
            "No se puede volver a registrar con los mismos datos", () async {
          Registro registro = new Registro(title: "registro");

          RespuestaHTTP respuestaHttp = await registro.registrar(
              null, usuario1.nombre, usuario1.clave, usuario1.correo,
              usuario1.telefono);

          // el status de la respuesta es 400 ya que es un error del cliente
          expect(respuestaHttp.status, 400);
          print(respuestaHttp.toString());
        });

        test("¿Se puede buscar al nuevo usuario registrado?", () async {
          List resultado = await busqueda(
              patron: usuario1.nombre, modo: modoBusqueda.perfiles);
          // el status de la respuesta es 400 ya que es un error del cliente

          // el segundo elemendo es un json que puede ser iterado como una lista en dart
          List nombres = (resultado[1] as List)
              .map((e) => e['nombre'])
              .toList();
          expect(nombres.contains(usuario1.nombre), true);
          print(nombres);
        });
       });

      group("Inicio de sesión", () {

        test("Se inicia sesión", () async {
          Login login = Login(title: "login");

          resultadoLogIn = await login.login(
              context: null, correo: usuario1.correo, clave: usuario1.clave);

          token = resultadoLogIn.body;

          expect(resultadoLogIn.status, 200);
          print(resultadoLogIn.toString());
        });


        test(
            "No se inicia sesión si se introduce una contraseña incorrecta", () async {
          Login login = Login(title: "login");

          resultadoLogIn = await login.login(context: null,
              correo: usuario1.correo,
              clave: usuario1.clave + "a");

          expect(resultadoLogIn.status, 400);
          print(resultadoLogIn.toString());
        });

      });

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


      group("Eliminación del usuario", ()
      {
        test(
            "No se puede eliminar un usuario si no hay autenticidad", () async {
          RespuestaHTTP res = await eliminarCuenta(context: null,
              usuario: usuario1.nombre,
              clave: usuario1.clave,
              token: "tokenfalsoinexistente");
          expect(res.status, 401);
          print(res.toString());
        });

        test("Se elimina el usuario con autenticidad", () async {
          RespuestaHTTP res = await eliminarCuenta(
              context: null, usuario: usuario1.nombre,
              clave: usuario1.clave, token: token);
          expect(res.status, 200);
          print(res.toString());
        });


        test("Se comprueba que el usuario NO se puede buscar", () async {
          List resultado = await busqueda(
              patron: usuario1.nombre, modo: modoBusqueda.perfiles);
          // el status de la respuesta es 400 ya que es un error del cliente

          // el segundo elemendo es un json que puede ser iterado como una lista en dart
          List nombres = (resultado[1] as List)
              .map((e) => e['nombre'])
              .toList();

          expect(nombres.contains(usuario1.nombre), false);
          print("lista de usuarios devuelta: " + nombres.toString());
        });

        test("Se verifica que el producto se ha borrado al haberse borrado el usuario", () async {
          List resultado = await busqueda(patron: "productop",
              modo: modoBusqueda.productos,
              categoria: "Otros");
          // el status de la respuesta es 400 ya que es un error del cliente

          // el segundo elemendo es un json que puede ser iterado como una lista en dart
          List productos = (resultado[1] as List)
              .map((e) => e['descripcion'])
              .toList();

          expect(productos.contains("productop"), false);
          print("lista de productos devuelta: " + productos.toString());
        });
      });

      
    });



}
