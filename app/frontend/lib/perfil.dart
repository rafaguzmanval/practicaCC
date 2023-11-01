
import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router_flow/go_router_flow.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:instafoto/reproductorVideo.dart';

import 'Sesion.dart';
import 'camara2.dart';
import 'main.dart';
import 'nuevaPublicacion.dart';

var respuestaServidor = null;

final ImagePicker picker = ImagePicker();

class Perfil extends StatefulWidget {
  const Perfil({super.key, required this.usuario});

  final String usuario;



  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {

  var imagenes = [];
  var data = "Sin mensajes";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Sesion.paginaActual = this;
    Sesion.nombrePagina = 'perfil';
    print("PERFIL DE " + widget.usuario + "  ${this.toString()}");

  }

  @override
  void dispose() {
    respuestaServidor = null;
    super.dispose();
  }


  @override
  Widget build(BuildContext context){

    return
      Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Perfil"),
          leading: Builder(builder: (context){

            return IconButton(onPressed: (){
              if(context.canPop())
                {
                  //print('puede volver atras');
                  context.pop();
                }
              else
                {
                  //print('puede volver hacia home');
                  context.go('/home');
                }

            }, icon: Icon(Icons.arrow_back_sharp));
          }),
          actions: [
          ]
        ),
        body: perfil(widget.usuario)
    );
  }        

  }

  var datos = null;

Widget perfil(usuario) {
  StreamController controlador = StreamController();
  //TabController controladorTabla = TabController(length: 2, vsync: this);

  var tipo = "imagen";
  Sesion.controlador = controlador;
  respuestaServidor = null;
  bool AsyncEnMarcha = false;
  cargarPerfil(usuario,controlador);
  return
  StreamBuilder(
      stream: controlador.stream,
      builder: (context,snapshot){

        if(respuestaServidor != null && respuestaServidor != "WRONG"){
          AsyncEnMarcha = false;
          var elegidos = (respuestaServidor['publicaciones'] as List).where((element) => element['tipo'] == tipo).toList();
    return

      Stack(
        children: [

          Align(
            alignment: Alignment.topCenter,
            child:
      SingleChildScrollView(
        child:
            Container(
              constraints: kIsWeb?BoxConstraints(minWidth: 300):null,
              margin: EdgeInsets.only(top: 20.0,bottom: 20.0),
              width: kIsWeb || MediaQuery.of(context).size.width > 1000?MediaQuery.of(context).size.width * 2 / 5:MediaQuery.of(context).size.width,
              child:
            Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
              children:[

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [

                    Column(children: [

                      CircleAvatar( backgroundImage: NetworkImage("${Sesion.servidor}/API/pedirFotoperfil/${usuario}"),radius: 40,
                        child: usuario==Sesion.usuario?
                            Align(
                              alignment: Alignment.bottomRight,
                              child:
                                  Container(
                                    height: 30,
                                      width: 30,
                                      child: FloatingActionButton(
                                        onPressed: ()async{
                                          await Navigator.push(context, MaterialPageRoute(builder: (context) => Camara(perfil: true,)));
                                          cargarPerfil(usuario,controlador);
                                        },

                                        child: Icon(Icons.camera_alt),

                                      )
                                  )

                            )
                        :null,),
                      Text(respuestaServidor['usuario']),
                    ],),




                    TextButton(onPressed: (){}, child: Text("Seguidores : ${ respuestaServidor is Map ? respuestaServidor['seguidores'].length : 0}",
                                                                style: TextStyle(color: paletaRoja.shade50,fontSize: 20.0),
                    )

                    ),

                    if(usuario!=Sesion.usuario && !esSeguidor(Sesion.usuario,respuestaServidor['seguidores']  ))...[
                      IconButton(onPressed: ()async{

                        if(!AsyncEnMarcha)
                        {
                          AsyncEnMarcha = true;
                          print("Se emite seguimiento ${Sesion.usuario}  ${usuario}");
                          Sesion.socket.emit('follow',[Sesion.usuario,usuario]);

                        }


                      }, icon: Icon(Icons.person_add_alt_1)),]
                    else if(usuario!=Sesion.usuario)...[
                      IconButton(onPressed: ()async{

                        if(!AsyncEnMarcha)
                        {
                          AsyncEnMarcha = true;
                          //print("Se deja de seguir ${Sesion.usuario}  ${usuario}");
                          Sesion.socket.emit('unfollow',[Sesion.usuario,usuario]);
                        }


                      }, icon: Icon(Icons.person_remove_alt_1_sharp))
                    ],


                  ],),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("")],),

                //Barra de filtrado
                Divider(color: Colors.black45,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [IconButton(onPressed: (){
                    tipo = "imagen";
                    controlador.add("");
                  }, icon: Icon(tipo=="imagen"?Icons.photo_size_select_actual:Icons.photo_size_select_actual_outlined)),
                    IconButton(onPressed: (){
                      tipo = "producto";
                      controlador.add("");
                    }, icon: Icon(tipo=="producto"?Icons.monetization_on:Icons.monetization_on_outlined)),

                    IconButton(onPressed: (){
                      tipo = "video";
                      controlador.add("");
                    }, icon: Icon(tipo=="video"?Icons.video_collection:Icons.video_collection_outlined))
                  ],
                )    ,

                Divider(color: Colors.black45,),



                GridView.count(crossAxisCount: 3, mainAxisSpacing: 5.0, crossAxisSpacing: 5.0,
                  shrinkWrap: true,
                  children: [

                    for(int i=0;i<elegidos.length;i++)...[

                      Container(
                        child: Column(children: [

                          Container(
                            child:
                                GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  child:

                                  Container(child:tipo=="video"?
                                  reproductorVideoNetwork("${Sesion.servidor}/API/imagen/${usuario}/${elegidos[i]['id']}")  :

                                  Image.network("${Sesion.servidor}/API/imagen/${usuario}/${elegidos[i]['id']}",fit: BoxFit.fill,
                                  ),

                                      height: MediaQuery.of(context).size.width * (!kIsWeb?(2/9):(2/15)),
                                      width : MediaQuery.of(context).size.width * (!kIsWeb?(2/9):(2/15))



                                  ),


                                  onTap: () async {
                                    //var r = await context.go Publicacion(correo: correo,publicacion: (snapshot.data['publicaciones'] as List)[j]['nombre'],id: (snapshot.data['publicaciones'] as List)[j]['id'].toString()));
                                    var direccion = "/${usuario}/${elegidos[i]['id'].toString()}";
                                    var r = await context.push(direccion);


                                    if(Sesion.publicacionBorrada) {Timer(Duration(milliseconds: 500),() {cargarPerfil(usuario, controlador);}); Sesion.publicacionBorrada =false;}
                                  },
                                ),


                          ),

                          if(tipo == "producto")...[

                            SizedBox(height: 5,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.sell),
                                Text("${elegidos[i]['precio']} €")
                              ],)
                          ]

                        ],),
                      )


                    ],

                    //for(int i=0; i< 10; i++)...[
                    //  Container(width: 200,height: 200,color: Colors.red,)
                   // ]


                  ],
                )

              ]

              )
              ,
            )



          ),
              ),
          if( !kIsWeb && Sesion.usuario == usuario)...[
            Container(
                alignment: Alignment(0.96,0.96),
                child:FloatingActionButton(
                  backgroundColor: paletaRoja[200],
                  onPressed: (){


                  if(!kIsWeb)
                    {
                      showDialog(context: context, builder: (context){
                        return _elegirFuenteImagen(context,usuario,controlador);
                      });
                    }
                  else
                    {
                      _navegarAGaleria(context);
                    }


                  },child: Icon(Icons.add_a_photo),)),


          ]


        ],
        );
        }
        else if(respuestaServidor == null)
          {
            return Center(child:new CircularProgressIndicator());
          }
        else
          {
            return Center(child: Text("No existe el usuario"),);
          }

      });

  
  
}

Widget _elegirFuenteImagen(context,correo,controlador)
{
  return Dialog(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton(
            onPressed: () async {

              await _navegarACamara(context);
              cargarPerfil(correo,controlador);


              },
          child: Column(children: [Icon(Icons.camera_alt), Text("Cámara")],
          ),

        ),

        FloatingActionButton(
          onPressed: () async {

            try{
              await _navegarAGaleria(context);
              cargarPerfil(correo,controlador);
            }
            catch(e)
            {
              print(e);
            }

          },
          child: Column(children: [Icon(Icons.collections), Text("Galería")],
          ),

        )
      ],
    ),
  );
}

_navegarAGaleria(context) async
{
  final archivo = await picker.pickImage(source: ImageSource.gallery);

  if(archivo != null)
  await Navigator.push(context,  MaterialPageRoute(builder: (context) => NuevaPublicacion(archivo: /*kIsWeb?archivo!.path :*/ io.File(archivo!.path))));

}

_navegarACamara(context) async
{
  await Navigator.push(context, MaterialPageRoute(builder: (context) => Camara(perfil: false,)));
}

bool esSeguidor(String usuario,List lista)
{

  return lista.map((e) => e['usuario1']).contains(usuario);

}

cargarPerfil(correo,controlador) async
{

  print("pidiendo imagenes del perfil");


  var response = await http.get(
    Uri.parse("${Sesion.servidor}/API/${correo}"),
  );

  //print();

  if(response.body == "WRONG")
    {
      respuestaServidor = "WRONG";
    }
  else
    {
      respuestaServidor = jsonDecode(response.body);
    }
  //
  controlador.add("");
  //print(imagenes[0]['nombre']);
}
