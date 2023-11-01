import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:camera/camera.dart';
import 'package:instafoto/perfil.dart';
import 'package:instafoto/publicacion.dart';

import 'Sesion.dart';
import 'camara.dart';
import 'directo.dart';
import 'main.dart';

class Buscador extends StatefulWidget {
  const Buscador({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<Buscador> createState() => _BuscadorState();
}

class _BuscadorState extends State<Buscador> {

 // var imagenes = [];
  //var data = "Sin mensajes";
  TextEditingController controlador = TextEditingController();
  var resultado = [];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context){

    return
      Scaffold(
        body:

        Column(children: [
          TextField(controller: controlador,onChanged: (n) async {

            if(n.isNotEmpty)
              {
                print("enviando: " + n);
                var response = await http.get(
                  Uri.parse("${Sesion.servidor}/API/buscar/${n}"),
                );

                var res = jsonDecode(response.body);
                resultado.clear();

                for(int i = 0; i< res.length; i++)
                {
                  resultado.add(res[i]['nombre']);
                }

                setState(() {

                });
              }


          },),


          for(int i = 0; i < resultado.length; i++)...[

            ElevatedButton(onPressed: (){

              Navigator.push(context, MaterialPageRoute(builder: (context) => Perfil(usuario: resultado[i])));
            }, child:
                Text(resultado[i])
            )


          ]



        ],)




            /*NestedScrollView(
                body: Container(
                  child: Column(
                    children: [
                      for(int i = 0; i < 10; i++)...[

                      ]
                    ],
                  ),



                )*/



            );
  }



}




