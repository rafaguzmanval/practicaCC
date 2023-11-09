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

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = new MyHttpOverrides();

  late RespuestaHTTP resultadoLogIn;
  late RespuestaHTTP resultadoPublicacion;

  Usuario usuario1 =
      new Usuario("Pepe", "clave123", "pepe@mail.com", "882134812");

  String token = "";

  group("Eliminacion de un usuario", () {
    test("Eliminando al usuario", () async {
      // Se inicia sesion para obtener el token necesario para poder eliminar la cuenta
      resultadoLogIn = await Login(
        title: "login",
      ).login(context: null, correo: usuario1.correo, clave: usuario1.clave);

      token = resultadoLogIn.body;

      RespuestaHTTP res = await eliminarCuenta(
          context: null,
          usuario: usuario1.nombre,
          clave: usuario1.clave,
          token: resultadoLogIn.body);

      //debe de dar un resultado correcto
      print("Status: " + res.status.toString());
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
