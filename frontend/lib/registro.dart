


import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:instafoto/respuestaHTTP.dart';
import 'package:instafoto/utilidades.dart';

import 'Sesion.dart';
import 'main.dart';

class Registro extends StatefulWidget {
  const Registro({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<Registro> createState() => _RegistroState();

  Future<RespuestaHTTP> registrar(BuildContext? context, String nombre, String clave, String correo, String telefono) async
  {

    if(nombre.isNotEmpty && clave.isNotEmpty && correo.isNotEmpty && telefono.isNotEmpty)
    {
      var body = {"nombre" : nombre, 'clave' : clave, 'correo' : correo , 'telefono' : telefono};

      var response = await http.post(
        Uri.parse("${Sesion.servidor}/API/registro"),
        body: body,
      );

      if(response.statusCode != 200)
      {
        if(context != null)
        snackbarError(context, response.body);


      }
      else
      {
        if(context != null)
          {
            if(Navigator.canPop(context))
              Navigator.pop(context);
          }
      }

      return RespuestaHTTP(response.statusCode, response.body);

    }
    else
    {
      if(context != null)
      snackbarError(context, "Debes introducir todos los datos correctamente");


      // con -1 nos referimos a que el front-end impide enviar la petición que es errónea
      return RespuestaHTTP(-1, "Debes introducir todos los datos correctamente");

    }



  }

}

class _RegistroState extends State<Registro> {

  TextEditingController Inputnombre = new TextEditingController();
  TextEditingController Inputclave = new TextEditingController();
  TextEditingController Inputcorreo = new TextEditingController();
  TextEditingController Inputtelefono = new TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    try {

    } on Exception catch (e, s) {
      print(s);
    }
  }

  @override
  void dispose() {
    Inputnombre.dispose();
    Inputclave.dispose();
    Inputcorreo.dispose();
    Inputtelefono.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(child: Scaffold(

      appBar: AppBar(backgroundColor: paleta.shade600,),
        body:



            Container(
              decoration: BoxDecoration(gradient: LinearGradient(colors: [paletaAmarilla.shade50,paletaRoja.shade900],begin: Alignment.topLeft, end: Alignment.bottomRight,)),
              child:
              Center(child: Container(
                  decoration: BoxDecoration(color: Colors.white30,shape: BoxShape.circle),
                  constraints: BoxConstraints(minWidth: 500),
                  child:
                      Container(
                        width: MediaQuery.of(context).size.width /7,
                        child:
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children:[

                              Container(
                                key: Key("nombre"),
                                constraints: BoxConstraints(minWidth: 150),
                                  width: MediaQuery.of(context).size.width /10,
                                  child:TextFormField(controller: Inputnombre,
                                decoration: const InputDecoration(
                                    icon:  Icon(Icons.person),
                                    hintText: 'Nombre'
                                ),
                              ),),

                            Container(
                              constraints: BoxConstraints(minWidth: 150),
                                width: MediaQuery.of(context).size.width /10,
                                child:
                              TextFormField(
                                key: Key("clave"),
                                controller: Inputclave,
                                obscureText: true,
                                decoration: const InputDecoration(
                                    icon:  Icon(Icons.password),

                                    hintText: 'Clave'
                                ),
                              ),
                            ),

                            Container(
                              constraints: BoxConstraints(minWidth: 150),
                                width: MediaQuery.of(context).size.width /10,
                                child:
                              TextFormField(
                                key: Key("correo"),
                                controller: Inputcorreo,
                                decoration: const InputDecoration(
                                    icon:  Icon(Icons.mail),
                                    hintText: 'Correo electrónico'
                                ),
                              ),
                            ),

                            Container(
                              key: Key("telefono"),
                              constraints: BoxConstraints(minWidth: 150),
                                width: MediaQuery.of(context).size.width /10,
                                child:
                              TextFormField(controller: Inputtelefono,
                                decoration: const InputDecoration(
                                    icon:  Icon(Icons.phone),
                                    hintText: 'Teléfono'
                                ),
                              ),
                            ),

                              /*if(kIsWeb)...[
                                Container(
                                  child: WebViewX(width: 400,height: 200, onWebViewCreated: (controller) {
                                    webviewController = controller;
                                    
                                    webviewController.loadContent(
                                        '<html> '
                                        '<head>'
                                        '<title>reCAPTCHA demo: Simple page</title> '
                                        '<script src="https://www.google.com/recaptcha/api.js" async defer></script>'
                                        '</head>'
                                        '<body>'
                                        '<form action="?" method="POST">'
                                        '<div class="g-recaptcha" data-sitekey="6LeCnT0mAAAAALLKqB6AVZP-PbEnbGluAksgwEB4"></div> '
                                        '<br/> '
                                        '<input type="submit" value="Submit">'
                                        '</form>'
                                        '</body>'
                                        '</html>',sourceType: SourceType.html);

                                    setState(() {

                                    });
                                  
                                  },)
                                ),
                              ],*/



                              SizedBox(height: 20.0,),
                              ElevatedButton(onPressed: (){
                               // webviewController.evalRawJavascript("alert('hola muy buenass')");
                                //controller.runJavaScript("alert('hola muy buenass')");
                                  widget.registrar(context,Inputnombre.value.text,
                                  Inputclave.value.text, Inputcorreo.value.text, Inputtelefono.value.text);

                                },
                                  child: Text("Registrarse"))
                            ]
                        ) ,
                      )


              ),))


    ));
  }



}


