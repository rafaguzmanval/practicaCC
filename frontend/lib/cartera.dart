import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'Sesion.dart';
import 'utilidades.dart';
import 'package:http/http.dart' as http;

import 'main.dart';



class Cartera extends StatefulWidget {
  const Cartera({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<Cartera> createState() => _CarteraState();
}

class _CarteraState extends State<Cartera>{

  var saldo = "-1";
  TextEditingController controladorCodigos = TextEditingController();
  
  late VideoPlayerController controladorVideo = VideoPlayerController.network("https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4");

  @override
  void initState() {
    _consultarSaldo();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

      return Scaffold(
        appBar: AppBar(title: Text("Cartera"),

          flexibleSpace: Container(decoration: BoxDecoration(
            gradient: LinearGradient(colors: [paletaAmarilla.shade50,paletaRoja.shade900],begin: Alignment.topLeft, end: Alignment.bottomRight,),
          ),),

        ),


        body:

        Center(
          child: Column(


            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              if(saldo == "-1")...
              [
                Center(child: new CircularProgressIndicator(),)
              ]
              else...[
                Spacer(flex: 1,),
                Text("Saldo: ${saldo}€",style: TextStyle(fontSize: 30),),
                Spacer(flex: 2,),
                Text("Canjea un código:",style: TextStyle(fontSize: 20),),

                SizedBox(
                  //margin: kIsWeb?EdgeInsets.only(left: MediaQuery.of(context).size.width * 1/4,right:MediaQuery.of(context).size.width * 1/4):EdgeInsets.zero,
                  width: MediaQuery.of(context).size.width * 3/4,
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(child: TextField(controller: controladorCodigos,))

                      ,


                      IconButton(onPressed: () async{
                        var body = {"codigo" : controladorCodigos.text, "usuario": Sesion.usuario};
                        var response = await http.post(Uri.parse('${Sesion.servidor}/API/activarCodigo'),body: body);

                        if(response.statusCode == 501)
                        {
                          controladorCodigos.text = "";
                          snackbarError(context, response.body);
                        }
                        else
                        {
                          controladorCodigos.text = "";
                          setState(() {
                            _consultarSaldo();
                          });
                        }




                      }, icon: Icon(Icons.check)),

                    ],
                  ),

                ),
                Spacer(flex: 2,)

              ]


            ],

          ),
        ));
  }

  _consultarSaldo() async
  {
    var body = { "usuario": Sesion.usuario};
    var response = await http.post(Uri.parse('${Sesion.servidor}/API/consultarCartera'),body: body);
    saldo = jsonDecode(response.body)['saldo'].toString();
    setState(() {

    });

    print(saldo);
  }

}
