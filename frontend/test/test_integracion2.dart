// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:instafoto/Sesion.dart';
import 'package:instafoto/ajustes.dart';
import 'package:instafoto/login.dart';

import 'package:instafoto/main.dart';
import 'package:instafoto/nuevaPublicacion.dart';
import 'package:instafoto/registro.dart';
import 'package:instafoto/usuario.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:integration_test/integration_test.dart';
import 'package:path_provider/path_provider.dart';

import 'package:instafoto/main.dart' as app;



//class MockNavigatorObserver extends Mock implements NavigatorObserver {}


void main() {

    // Build our app and trigger a frame.
    //await tester.pumpWidget(MyApp());
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();


    setUpAll(() {
      HttpOverrides.global = new MyHttpOverrides();

    });

    Usuario usuario1 = new Usuario("Pepe", "clave123", "pepe@mail.com", "882134812");
    Usuario usuario2 = new Usuario("Ana", "clave124", "ana@mail.com", "092134816");

  String mensaje = "hola " + usuario2.nombre;



  testWidgets("Test de integracion 2", (tester) async {

          app.main(); /// Se inicia la aplicación
          Sesion.test = true; /// se activa el modo test para que los mensajes de Socket.io sean sin TLS
          ///
          /// SE REGISTRAN A AMBOS USUARIOS
          await tester.pumpAndSettle();
          await _registro(tester,usuario1);
          await _registro(tester, usuario2);

          /// Usuario 1 inicia sesión y envia un mensaje a usuario 2
          await _iniciarSesion(tester,usuario1); /// se prueba que se inicia la sesión
          await _enviarMensajeAUsuario(tester, usuario1, usuario2, mensaje ); /// Se prueba que el mensaje se envia

          await _cerrarSesion(tester);

          ///El usuario 2 inicia sesión y comprueba que le ha llegado el mensaje
          await _iniciarSesion(tester, usuario2);
          await _comprobarMensaje(tester, mensaje);
          await _cerrarSesion(tester);

        });


  testWidgets("Se eliminan las cuentas", (tester) async {

    app.main();
    Sesion.test = true;


    await _eliminarUsuario(tester, usuario1);
    await _eliminarUsuario(tester, usuario2);

  });



}

Future<void> _iniciarSesion(WidgetTester tester, Usuario usuario) async {

  await _espera(tester);

  Finder botonLogin = find.byKey(Key("Entrar"));

  expect(botonLogin,findsOneWidget);

  await tester.enterText(find.byKey(Key("correo")), usuario.correo);
  await tester.enterText(find.byKey(Key("clave")), usuario.clave);

  await tester.tap(botonLogin);

  await _espera(tester);

}

Future<void> _registro(WidgetTester tester, Usuario usuario) async{

  Finder botonRegistro = find.byKey(Key("Registro"));

  expect(botonRegistro,findsOneWidget);

  await tester.dragUntilVisible(
    botonRegistro,
    find.byType(SingleChildScrollView),
    const Offset(0, 50),
  );

  await tester.tap(botonRegistro);

  await tester.pumpAndSettle();

  //se comprueba que estamos en la pagina de registro
  expect(find.text("Registrarse"), findsOneWidget);

  await tester.enterText(find.byKey(Key("nombre")), usuario.nombre);
  await tester.enterText(find.byKey(Key("correo")), usuario.correo);
  await tester.enterText(find.byKey(Key("clave")), usuario.clave);
  await tester.enterText(find.byKey(Key("telefono")), usuario.telefono);

  await tester.tap(find.byType(ElevatedButton));

  await tester.pumpAndSettle();
  await tester.pump(Duration(seconds: 3));
  await tester.pumpAndSettle();

  expect(botonRegistro,findsOneWidget);

}

Future<void> _enviarMensajeAUsuario(WidgetTester tester, Usuario usuario, Usuario usuario2, String mensaje) async
{

  await _espera(tester);

  expect(find.byTooltip("chats"), findsOneWidget);

  await tester.tap(find.byTooltip("chats"));

  await _espera(tester);

  expect(find.byKey(Key("Buscador")), findsOneWidget);

  await tester.enterText(find.byKey(Key("Buscador")), usuario2.nombre);

  await _espera(tester);

  expect(find.byKey(Key("chat" + usuario2.nombre)), findsOneWidget);

  await tester.tap(find.byKey(Key("chat" + usuario2.nombre)));

  await _espera(tester);

  print("se envia el mensaje");

  expect(find.byKey(Key("Input")), findsOneWidget);
  expect(find.byKey(Key("BotonEnviaMensaje")), findsOneWidget);

  await tester.enterText(find.byKey(Key("Input")), mensaje);

  await tester.tap(find.byKey(Key("BotonEnviaMensaje")));

  await _espera(tester);
  await _espera(tester);

  expect( find.text(mensaje), findsAtLeastNWidgets(1));

  expect( find.byKey(Key("back")), findsOneWidget);

  await tester.tap(find.byKey(Key("back")));

  await _espera(tester);

}


Future<void> _comprobarMensaje(WidgetTester tester, String mensaje) async
{
  expect(find.byTooltip("chats"), findsOneWidget);

  await tester.tap(find.byTooltip("chats"));

  await _espera(tester);

  expect( find.text(mensaje), findsOneWidget);

}


Future<void> _eliminarUsuario(WidgetTester tester, Usuario usuario) async {
  await _iniciarSesion(tester, usuario);

  expect(find.byTooltip("ajustes"), findsOneWidget);

  await tester.tap(find.byTooltip("ajustes"));

  await _espera(tester);

  expect(find.byKey( Key("eliminarCuenta")), findsOneWidget);


  await tester.tap(find.byKey( Key("eliminarCuenta")));

  await tester.pumpAndSettle();

  expect(find.byKey( Key("inputClave")), findsOneWidget);
  expect(find.byKey( Key("confirmarEliminacion")), findsOneWidget);

  await tester.enterText(find.byKey( Key("inputClave") ), usuario.clave);

  await tester.tap(find.byKey( Key("confirmarEliminacion")));

  await _espera(tester);

  expect(find.byKey(Key("Entrar")),findsOneWidget);
}


Future<void> _cerrarSesion(WidgetTester tester) async {

  expect(find.byTooltip("ajustes"), findsOneWidget);

  await tester.tap(find.byTooltip("ajustes"));

  await _espera(tester);

  expect(find.byKey( Key("cerrarSesion")), findsOneWidget);


  await tester.tap(find.byKey( Key("cerrarSesion")));

  await _espera(tester);

  expect(find.byKey(Key("Entrar")),findsOneWidget);
}

Future<void> _espera (WidgetTester tester) async
{
  await tester.pumpAndSettle();
  await tester.pump(Duration(seconds: 3));
  await tester.pumpAndSettle();
}
