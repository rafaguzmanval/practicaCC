import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:camera/camera.dart';
import 'package:instafoto/directo.dart';

import 'Sesion.dart';
import 'main.dart';

class Llamada extends StatefulWidget {
  const Llamada({super.key, required this.emisor, required this.oferta});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  final String emisor;
  final String oferta;

  @override
  State<Llamada> createState() => _LlamadaState();
}

class _LlamadaState extends State<Llamada> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //_subirImagen();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child:

          Center(
            child:
          Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [

              CircleAvatar(backgroundImage:NetworkImage('${Sesion.servidor}/API/pedirFotoperfil/${widget.emisor}') , radius: 100,),
              Text(widget.emisor + ' te llama', style: TextStyle(fontSize: 25),),

              Align(alignment: Alignment.bottomCenter,child:

              Container(
                margin: EdgeInsets.only(left: MediaQuery.of(context).size.width/4,right: MediaQuery.of(context).size.width/4),
                child:
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(alignment: Alignment.centerLeft,child:
                  IconButton(icon: Icon(Icons.call_end, color: Colors.red,), onPressed: (){

                    Sesion.socket.emit("cancelarLlamada",[widget.emisor,Sesion.usuario]);
                    Navigator.pop(context);
                  },)

                    ,),
                  Align(alignment: Alignment.centerRight,child:
                  IconButton(icon: Icon(Icons.call, color: Colors.green,), onPressed: ()async{

                    {
                      await Navigator.push(context, MaterialPageRoute(builder: (context) => Directo(receptor: widget.emisor,tipo: 'receptor',oferta: widget.oferta,)));
                      Navigator.pop(context);
                    }


                  },)
                    ,)
                ],
              ),)
),


            ],),
            )





        )




    );
  }
}