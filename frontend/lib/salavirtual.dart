


import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:instafoto/main.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'Sesion.dart';
import 'package:universal_html/html.dart' as html;


class salaVirtual extends StatefulWidget {
  const salaVirtual({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<salaVirtual> createState() => _salaVirtualState();
}

class _salaVirtualState extends State<salaVirtual> {


  late WebViewController controller;

  var cargado = null;

  @override
  void initState() {

    // TODO: implement initState
    if(!kIsWeb)
      {
        Sesion.paginaActual = this;
        Sesion.nombrePagina = "salavirtual";
        controller = WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setBackgroundColor(const Color(0x00000000))
          ..setNavigationDelegate(
            NavigationDelegate(
              onProgress: (int progress) {
                // Update loading bar.
              },
              onPageStarted: (String url) {},
              onPageFinished: (String url) {},
              onWebResourceError: (WebResourceError error) {},
              onNavigationRequest: (NavigationRequest request) {
                return NavigationDecision.navigate;
              },
            ),
          )
          ..loadRequest(Uri.parse('${Sesion.servidorHttp}/salavirtual')).then((value)  async {


            if(mounted)
              {
                do
                {
                  cargado = await controller.runJavaScriptReturningResult("cargado==true;").catchError((e){print(e);});
                  print(cargado);
                }
                while(cargado != true);

                print("escena cargada");

                setState(() {

                });

                controller.runJavaScript("local='${Sesion.socket.id}';").catchError((e){print(e);});

                var color = await controller.runJavaScriptReturningResult("escena.instanciarModelo('${Sesion.socket.id}',[0,0,0],null);").catchError((e){print(e);});


                print("color maravilloso" + color.toString());

                Sesion.socket.emit('nuevoJugador',color);
              }


          });

      }
    else
      {
        html.window.open('${Sesion.servidor}/salavirtual',"_self");
      }

    super.initState();
  }


  @override
  void dispose() {
    // TODO: implement dispose


    Sesion.socket.emit("dejarSala");



    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  cargarSala(jugadores)
  {
    print(jugadores);
    var arrayJugadores = "[";
    (jugadores as List).forEach((jugador){
      arrayJugadores += '["${jugador[0]}",[0,0,0],${jugador[2]}],';
    });

    arrayJugadores = arrayJugadores.substring(0,arrayJugadores.length-1) + "]";

    print(arrayJugadores);

    controller.runJavaScript("escena.instanciarJugadores(${arrayJugadores});").catchError((e){print(e);});
  }

  dejarSala(id)
  {
    controller.runJavaScript("escena.eliminarModelo('${id}');").catchError((e){print(e);});
  }

  instanciarNuevoJugador(nombre,color) async
  {

    controller.runJavaScript("escena.instanciarModelo('${nombre}',[0,0,0],${color});").catchError((e){print(e);});
  }

  moverJugador(id,posicion,propiedades)
  {
   // print(propiedades);
    //print(propiedades);
    controller.runJavaScript("escena.cambiarPropiedadesJugador('${id}',${propiedades['andar']},${propiedades['girarIzquierda']},${propiedades['girarDerecha']},${propiedades['saludar']});").catchError((e){print(e);});
  }


  @override
  Widget build(BuildContext context) {


    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    // TODO: implement build
    return Scaffold(

      body:
          Stack(children: [


            if(cargado == true)...[

              SizedBox(child: WebViewWidget(controller: controller,),width: MediaQuery.of(context).size.width,height:MediaQuery.of(context).size.height),

              Align(child:             GestureDetector(


                  onTapDown: (_){

                    Sesion.socket.emit("movimiento",[[0,0,0],'andar']);

                  },
                  onTapUp: (_){

                    Sesion.socket.emit("movimiento",[[0,0,0],'']);
                  },
                  child: Container(child:Icon(Icons.arrow_upward),
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(color: paleta.shade400),

                  )),alignment: Alignment.bottomRight,),


              Align(child:             GestureDetector(


                  onTapDown: (_){

                    Sesion.socket.emit("movimiento",[[0,0,0],'saludar']);

                  },
                  onTapUp: (_){

                  },
                  child: Container(child:Icon(Icons.back_hand_rounded),
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(color: paleta.shade400),

                  )),alignment: Alignment.centerRight,),



              Align(child:
              Row(children: [
                GestureDetector(


                    onTapDown: (_){

                      Sesion.socket.emit("movimiento",[[0,0,0],'girarIzquierda']);

                    },
                    onTapUp: (_){

                      Sesion.socket.emit("movimiento",[[0,0,0],'']);
                    },
                    child: Container(child:Icon(Icons.arrow_back),
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(color: paleta.shade400),

                    )),

                GestureDetector(

                    onTapDown: (_){

                      Sesion.socket.emit("movimiento",[[0,0,0],'girarDerecha']);

                    },
                    onTapUp: (_){

                      Sesion.socket.emit("movimiento",[[0,0,0],'']);
                    },
                    child: Container(child:Icon(Icons.arrow_forward),
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(color: paleta.shade400),

                    ))

              ],)
                ,alignment: Alignment.bottomLeft,)

            ]else...[
              Center(child: new CircularProgressIndicator(),)

    ]






          ],));

  }
}
