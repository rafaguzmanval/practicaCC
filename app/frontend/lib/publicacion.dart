import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router_flow/go_router_flow.dart';
import 'package:http/http.dart' as http;
import 'package:camera/camera.dart';
import 'package:instafoto/nuevaPublicacion.dart';
import 'package:instafoto/perfil.dart';
import 'package:instafoto/reproductorVideo.dart';
import 'package:instafoto/respuestaHTTP.dart';

import 'Sesion.dart';
import 'camara.dart';
import 'chat.dart';
import 'directo.dart';
import 'main.dart';

class Publicacion extends StatefulWidget {
   Publicacion({super.key,required this.usuario, required this.id, this.descripcion,this.tipo,this.archivo});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String usuario;
  final int id;
  String? descripcion;
  tipoPublicacion? tipo;
  File? archivo;


  @override
  State<Publicacion> createState() => _PublicacionState();

  Future<RespuestaHTTP> borrar({required int id,required String auth}) async
  {

    var body = {"id" : id.toString()};

    var response = await http.post(
      Uri.parse("${Sesion.servidor}/API/borrar"),
      body: body,
      headers:  {"auth" : auth}
    );

    return RespuestaHTTP(response.statusCode, response.body);
  }
}

class Producto extends Publicacion{

  double precio;
  String descripcionProducto;
  String categoria;

  Producto({
    super.key,
    required id,
    required usuario,
    required descripcion,
    required tipo,
    required archivo,
    required this.precio,
    required this.descripcionProducto,
    required this.categoria,
  }) : super(id: id,usuario: usuario, descripcion: descripcion,tipo: tipo,archivo: archivo);

}

class _PublicacionState extends State<Publicacion> {

  int likes = 0;
  var precio = 0;
  var tipo = "null";
  var descripcion = null;
  bool likePropio = false;
  var procesandoOperacion = false;
  TextEditingController controlador = new TextEditingController();

  var comentarios = [];


  @override
  void initState() {

    Sesion.nombrePagina = 'publicacion';
    Sesion.socket.emit("infoPublicacion",[widget.id,Sesion.usuario]);
    Sesion.paginaActual = this;
    _informacion();
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context){

    return Scaffold(
        appBar: AppBar(
          actions: [

            /// Solo el usuario o un moderador pueden borrar la publicación


              IconButton(onPressed: ()async{

                showModalBottomSheet<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return SizedBox(
                      height: 200,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            const Text('Opciones'),
                            ElevatedButton(
                              child: const Text('Denunciar'),
                              onPressed: () async{
                                var r = await _denunciar(widget.id);
                                Navigator.pop(context);
                              },
                            ),

                            SizedBox(height: 10,),
                            if(Sesion.usuario == widget.usuario || Sesion.permisos > 0)...[
                            ElevatedButton(
                              child: const Text('Borrar'),
                              onPressed: () async{
                                var r = await widget.borrar(id: widget.id, auth: Sesion.auth);

                                Sesion.publicacionBorrada = (r=="OK");
                                Navigator.pop(context);
                                context.pop(true);
                              },
                            ),

                          ]
                          ],
                        ),
                      ),
                    );
                  },
                );
              /*var r = await _borrar(widget.id);
              Navigator.pop(context,r == 'OK');*/
            }, icon: Icon(Icons.settings))

          ],
        ),
        body:

        SingleChildScrollView(
        child:
            Center(child:
            Column(
                children:[
                  SizedBox(height: 5,),
              Container(
                  margin: EdgeInsets.only(left: (MediaQuery.of(context).size.width-500)%10000 /2),
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar(backgroundImage: NetworkImage(
                          "${Sesion.servidor}/API/pedirFotoperfil/${widget.usuario}")),
                      Text(widget.usuario),
                    ],)),

                  SizedBox(height: 5,),

                  if(tipo == "video")...[
                    Container(child: reproductorVideoNetwork("${Sesion.servidor}/API/imagen/${widget.usuario}/${widget.id}"),height: 500,width: 500,)


                  ]else...[

                    InteractiveViewer(child: Image.network("${Sesion.servidor}/API/imagen/${widget.usuario}/${widget.id}",height:500,width: 500, fit: BoxFit.fill,),)
                  ],


                  Padding(padding: EdgeInsets.only(left: 20,right: 20),child:
                  Column(children: [


                      Text( descripcion is String? descripcion : "sin descripcion",style: TextStyle(fontSize: 17),),





                  if(tipo == "imagen" || tipo=="video")...[


                      Container(
                        margin: EdgeInsets.only(left: 10,right: 10),
                        child:
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [

                              Text(likes.toString() + ' favs'),
                              IconButton(icon: Icon(likePropio?Icons.star:Icons.star_border),
                                iconSize: 50,
                                color: Colors.lime[400],
                                onPressed: (){

                                  if(!likePropio && !procesandoOperacion) {
                                    procesandoOperacion = true;
                                    Sesion.socket.emit('gustaFoto', [
                                      widget.id,
                                      Sesion.usuario,
                                      true
                                    ]);
                                  }
                                  else if(likePropio && !procesandoOperacion){
                                    procesandoOperacion = true;
                                    Sesion.socket.emit('gustaFoto', [
                                      widget.id,
                                      Sesion.usuario,
                                      false
                                    ]);

                                  }


                                },)


                            ],),),

                        Container(
                          margin: EdgeInsets.only(left: MediaQuery.of(context).size.width/10,right: MediaQuery.of(context).size.width/10),
                          child:
                          Row(

                            children: [
                            Expanded(child:
                            TextField(controller: controlador,)),
                            IconButton(onPressed: (){

                                _enviarComentario(controlador.text, widget.id);

                                controlador.text = "";



                            }, icon: Icon(Icons.send))
                          ],),


                        ),

                    SizedBox(height: 5,),



                        for(var comentario in comentarios)...[

                        Container(
                        margin: EdgeInsets.only(left: MediaQuery.of(context).size.width/8,right: MediaQuery.of(context).size.width/8),

                         child: Row(
                            children: [
                              CircleAvatar(backgroundImage: NetworkImage('${Sesion.servidor}/API/pedirFotoperfil/${comentario['usuario']}'),),
                              Column(

                                children: [
                                Text(comentario['usuario']),
                                Text(comentario['contenido'])
                              ],)

                            ],
                          ))


                        ]
                      ]
                    else if(tipo == "producto")...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.sell),
                          Text("${precio} €")
                        ],),

                          if(Sesion.usuario != widget.usuario)...[
                            FloatingActionButton(onPressed: () async{

                              var body = {"user1" : Sesion.usuario ,"user2": widget.usuario};
                              var response = await http.post(
                                  Uri.parse("${Sesion.servidor}/API/encontrarChat"),
                                  body: body
                              );

                             // print(response.body);
                              var idChat = -1;
                              if(jsonDecode(response.body).length == 1)
                                {
                                  idChat = jsonDecode(response.body)[0]['idChat'];
                                }

                              await Navigator.push(context, MaterialPageRoute(builder: (context) => Chat(usuario: widget.usuario, idChat: idChat)));
                            },child: Icon(Icons.chat),)
                          ]


                      ]

                    ]





            ),)

      ]
    ),


    )));
  }

  /*
*/

  nuevosLikes(likes,likePropio)
  {

    if(likePropio != this.likePropio)
      {
        procesandoOperacion = false;
      }



    setState(() {
      this.likePropio = likePropio;
    });
    _informacion();
  }

  _informacion() async
  {
    var response = await http.get(Uri.parse("${Sesion.servidor}/API/publicacion/"+widget.id.toString()));

    print(response.body);

    var jsonResponse = jsonDecode(response.body);

    this.descripcion = jsonResponse['descripcion'];

    this.comentarios = jsonResponse['comentarios'];

    this.likes = jsonResponse['likes'];

    this.tipo = jsonResponse['tipo'];

    this.precio = jsonResponse['precio'] is int? jsonResponse['precio'] : 0;

    setState(() {

    });

    print(this.descripcion);
  }


  _enviarComentario(comentario,publicacion) async
  {
    var body = {"publicacion" : publicacion, "contenido":comentario, "usuario" : Sesion.usuario};

    var response = await http.post(
      Uri.parse("${Sesion.servidor}/API/comentar"),
      body: body,
    );

    if(response.statusCode == 200)
      {
          print(response.body);
          _informacion();
      }
    else
      {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.transparent,
              duration: Duration(seconds: 2),
              elevation: 0,
              content: Container(
                padding: const EdgeInsets.all(16),
                height: 90,
                decoration: const BoxDecoration(
                  color: Color(0xFF000000),
                  borderRadius: BorderRadius.all(Radius.circular(29)),

                ),
                child: Text("Error: " + response.body),
              )),
        );
      }

  }

  _denunciar(id) async {
    var body = {"id" : id};

    var response = await http.post(
      Uri.parse("${Sesion.servidor}/API/denunciar"),
      body: body,
    );

    if(response.body != "OK"){
      print("error al denunciar " + response.body );
    }

  }






}