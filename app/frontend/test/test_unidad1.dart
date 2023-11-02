
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

    Usuario usuario1 = new Usuario("Pepe", "clave123", "pepe@mail.com", "882134812");


    late RespuestaHTTP resultadoLogIn;
    late RespuestaHTTP resultadoPublicacion;

    String token = "";
    int idPublicacion;


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

}

