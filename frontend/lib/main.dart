import 'dart:async';
import 'dart:convert';


import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instafoto/publicacion.dart';
import 'package:universal_html/html.dart';


import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'dart:io';
import 'package:instafoto/home.dart';
import 'package:url_strategy/url_strategy.dart';

import 'Sesion.dart';
import 'login.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:go_router_flow/go_router_flow.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'perfil.dart';

import 'package:http/http.dart' as http;


//var servidor = "https://192.168.0.28:4000";//"https://192.168.8.101:4000";//"https://192.168.0.28:4000";
//var correoSesion = "photopop";
List<CameraDescription> camaras = <CameraDescription>[];


//clase necesaria para evitar el fallo al tener un servidor https auto-certificado
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}



Map<int,Color> swatch = {
  50 :  const Color.fromRGBO(1, 167, 235, 0.92),
  100 : const Color.fromRGBO(1, 167, 235, 0.80),
  200 :  const Color.fromRGBO(1, 167, 235, 0.75),
  300 :  const Color.fromRGBO(1, 167, 235, 0.70),
  400 :  const Color.fromRGBO(1, 167, 235, 0.65),
  500 :  const Color.fromRGBO(1, 167, 235, 0.60),
  600: const Color.fromRGBO(1, 167, 235, 0.55),
  700: const Color.fromRGBO(1, 167, 235, 0.50),
  800: const Color.fromRGBO(1, 167, 235, 0.45),
  900: const Color.fromRGBO(1, 167, 235, 0.40),

};

Map<int,Color> swatchRoja = {
  50 :  const Color.fromRGBO(235, 23, 65, 0.92),
  100 : const Color.fromRGBO(235, 23, 65, 0.80),
  200 :  const Color.fromRGBO(235, 23, 65, 0.75),
  300 :  const Color.fromRGBO(235, 23, 65, 0.70),
  400 :  const Color.fromRGBO(235, 23, 65, 0.65),
  500 :  const Color.fromRGBO(235, 23, 65, 0.60),
  600: const Color.fromRGBO(235, 23, 65, 0.55),
  700: const Color.fromRGBO(235, 23, 65, 0.50),
  800: const Color.fromRGBO(235, 23, 65, 0.45),
  900: const Color.fromRGBO(235, 23, 65, 0.40),

};

Map<int,Color> swatchAmarilla = {
  50 :  const Color.fromRGBO(235, 222, 0, 0.92),
  100 : const Color.fromRGBO(235, 222, 0, 0.80),
  200 :  const Color.fromRGBO(235, 222, 0, 0.75),
  300 :  const Color.fromRGBO(235, 222, 0, 0.70),
  400 :  const Color.fromRGBO(235, 222, 0, 0.65),
  500 :  const Color.fromRGBO(235, 222, 0, 0.60),
  600: const Color.fromRGBO(235, 222, 0, 0.55),
  700: const Color.fromRGBO(235, 222, 0, 0.50),
  800: const Color.fromRGBO(235, 222, 0, 0.45),
  900: const Color.fromRGBO(235, 222, 0, 0.40),

};

MaterialColor paleta = MaterialColor(Color.fromRGBO(1, 167, 235, 0.72).value, swatch);
MaterialColor paletaAmarilla = MaterialColor(Color.fromRGBO(235, 222, 0, 0.92).value, swatchAmarilla);
MaterialColor paletaRoja = MaterialColor(Color.fromRGBO(235, 23, 65, 0.92).value, swatchRoja);

final GoRouter _router = GoRouter(
  routes:  [
              GoRoute(
                path: '/',
                builder: (context,state) {
                  //print(document.cookie!);
                  return const Login(title: 'Photopop');
                },

                redirect: (context,state) async {
                  print("redireccionando al principio");

                  if(Sesion.status != Status.Desconectando && (Sesion.status == Status.Inicio && kIsWeb))
                    {
                      var body = {"sesion" : Sesion.correo, "auth" : Sesion.auth};
                      var response = await http.post(
                        Uri.parse("${Sesion.servidor}/API/token"),
                        body: body,
                      );

                      //print(" respuesta de token en root" + response.body);

                      if(response.body != "WRONG")
                      {

                        var respuesta =  jsonDecode(response.body);
                        print(respuesta);
                        Sesion.correo = respuesta['correo'];
                        Sesion.permisos = respuesta['permisos'];
                        Sesion.usuario = respuesta['nombre'];
                        print("Volviendo a home");
                        return "/home";
                      }

                    }

                  print("Volviendo al principio");

                  return "/";
                },
              ),

              GoRoute(
                path: '/logout',
                redirect: (context,state) {
                  return "/";
                },
              ),
              GoRoute(
                      path: '/home',
                      builder: (context,state){
                        Sesion.streamMensajes = StreamController();

                        return const Home();
                      },
                      redirect: (context,state) async {

                              var body = {"sesion" : Sesion.correo, "auth" : Sesion.auth};
                              var response = await http.post(
                                Uri.parse("${Sesion.servidor}/API/token"),
                                body: body,
                              );

                             // print(" respuesta de token en home" + response.body);

                              if(response.body != "WRONG")
                                {
                                  var respuesta =  jsonDecode(response.body);
                                  Sesion.correo = respuesta['correo'];
                                  Sesion.permisos = respuesta['permisos'];
                                  Sesion.usuario = respuesta['nombre'];
                                  return "/home";
                                }

                        return "/";
                      }
              ),
              GoRoute(path: '/:usuario',
                name: 'perfil',
                builder: (context,state) {
                print("buscando el perfil de " +state.params['usuario']! );
                return Perfil(usuario: state.params['usuario']!);},
              ),
              GoRoute(path: '/:usuario/:id',
                builder: (context,state) {
                  print("buscando el perfil de " +state.params['usuario']! );
                  return Publicacion(usuario: state.params['usuario']!,id: int.parse(state.params['id']!),);},
              ),

  ]

);



Future<bool> startForegroundService() async{
  final androidConfig = FlutterBackgroundAndroidConfig(
    notificationTitle: 'Photopop',
    notificationText: 'Ejecutandose en segundo plano',
    notificationImportance: AndroidNotificationImportance.Default,
    notificationIcon: AndroidResource(
      name: 'background_icon',
      defType: 'drawable'),
    );

  await FlutterBackground.initialize(androidConfig: androidConfig);
  return FlutterBackground.enableBackgroundExecution();
}


void main() async{

  if(WebRTC.platformIsAndroid)
  {


    try{
      WidgetsFlutterBinding.ensureInitialized();
      camaras = await availableCameras();
    } catch (e)
    {
      print(e);
    }
    startForegroundService();
    HttpOverrides.global = new MyHttpOverrides();

    AwesomeNotifications().initialize(null, [
      NotificationChannel(channelKey: 'basic_chanel', channelName: 'Nueva noti', channelDescription: 'NotiNueva',playSound: true, defaultRingtoneType: DefaultRingtoneType.Notification)

    ],
    channelGroups: [
      NotificationChannelGroup(channelGroupKey: 'basic_chanel_group', channelGroupName: 'Basic group')

    ],debug: true);

  }

  setPathUrlStrategy();


  runApp( MyApp());
}

class MyApp extends StatefulWidget {

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static const String name = 'Photopop';


  @override
  _MyAppState createState() => _MyAppState();

}


class _MyAppState extends State<MyApp> {

  @override
  void initState(){

   // AwesomeNotifications().setListeners(onActionReceivedMethod: NotificationController.onAc)
}

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp.router(
      title: 'Photopop',
      theme: ThemeData(
          fontFamily: 'Alegreya',
          primarySwatch: paleta
      ),

      routerConfig: _router,

    );
  }


}




