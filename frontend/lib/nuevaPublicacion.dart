

import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:instafoto/reproductorVideo.dart';
import 'package:instafoto/respuestaHTTP.dart';


import 'Sesion.dart';

enum tipoPublicacion {
  imagen,
  video,
  producto
}

class NuevaPublicacion extends StatefulWidget {
  const NuevaPublicacion({super.key, required this.archivo});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  final File archivo;

  @override
  State<NuevaPublicacion> createState() => _NuevaPublicacionState();


  Future<RespuestaHTTP> subirArchivo({required BuildContext? context,required String usuario, required String auth,required String descripcion,required tipoPublicacion tipo,String? precio,String? descripcionProducto,String? categoria}) async
  {
    var url = "${Sesion.servidor}/API/subir";

    var request = new http.MultipartRequest("POST", Uri.parse(url));
    request.headers['auth'] = auth;
    request.fields['usuario'] = usuario;
    request.fields['descripcion'] = descripcion;
    request.fields['tipo'] = tipo.name.toString();
    request.fields['precio'] = "null";

    if(tipo == tipoPublicacion.producto && precio != null && descripcionProducto != null && categoria != null)
    {
      request.fields['precio'] = precio.toString();
      request.fields['descripcionProducto'] = descripcionProducto;
      request.fields['categoria'] = categoria == 'Elegir categoría'? 'otro' : categoria;
    }

    var extension = tipo==tipoPublicacion.video?".mp4":".jpg";

    request.files.add(http.MultipartFile.fromBytes('picture',
        archivo.readAsBytesSync(),
        filename: DateTime.now().millisecondsSinceEpoch.toString() + usuario + extension));

    var res = await request.send();

    var respuesta = await res.stream.bytesToString();

    if(context != null)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            duration: Duration(seconds: 10),
            elevation: 0,
            content: Container(
              padding: const EdgeInsets.all(16),
              height: 90,
              decoration: const BoxDecoration(
                color: Color(0xFF000000),
                borderRadius: BorderRadius.all(Radius.circular(29)),

              ),
              child: Text(res.statusCode==200?"Publicación subida correctamente": "Ha habido un problema"),
            )),
      );


    return RespuestaHTTP(res.statusCode, respuesta);
  }
}


class _NuevaPublicacionState extends State<NuevaPublicacion> {

  var descriptorController = TextEditingController();
  var descriptorProductoController = TextEditingController();
  var precioController = TextEditingController();
  var vender = false;
  int precio = 0;
  var tipo = tipoPublicacion.imagen;


  var lista = ['Elegir categoría','otro','informatica'];

  String categoriaElegida = "Elegir categoría";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _encontrarCategorias();

    if(widget.archivo.path.endsWith(".mp4"))
      {
        tipo = tipoPublicacion.video;
      }

    categoriaElegida = lista.first;
    //_subirImagen();
  }

  @override
  void dispose() {
    descriptorController.dispose();
    descriptorProductoController.dispose();
    precioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body:
      SafeArea(
          child:
          SingleChildScrollView(child:
          Column(children: [

            if(tipo== tipoPublicacion.imagen)...[
              if(kIsWeb)...[
              Image.network(widget.archivo.path),
              ]
              else
                Image.file(widget.archivo),
            ]else if(tipo== tipoPublicacion.video)...[
              reproductorVideo(widget.archivo)
            ],


            if(tipo== tipoPublicacion.imagen)...[
              Row(children: [
                IconButton(onPressed: (){
                  vender = false;
                  setState(() {

                  });
                }, icon: Icon(vender?Icons.photo_size_select_actual_outlined:Icons.photo_size_select_actual)),
                IconButton(onPressed: (){
                  vender = true;
                  setState(() {

                  });
                }, icon: Icon(vender?Icons.sell: Icons.sell_outlined)),
              ],),
            ],




            TextField(
              controller: descriptorController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: vender?'Nombre':'Descripción',
              ),
            ),

            if(vender && tipo == tipoPublicacion.imagen)...[

              TextField(

                controller: descriptorProductoController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Descripcion',
                ),

              ),
              DropdownButton(
                  value: categoriaElegida,
                  items: lista.map<DropdownMenuItem<String>>((String e){
                    return DropdownMenuItem<String>(
                      value: e,
                      child: Text(e),);
                  }).toList(),
                  onChanged: (item) {
                    setState(() {
                      categoriaElegida = item!;
                    });
                  }),
              TextField(

                controller: precioController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Precio',
                ),

              ),
            ],

            Align(alignment: Alignment.bottomRight,
                child:
                IconButton(icon: Icon(Icons.check),onPressed: (){

                  if(tipo != tipoPublicacion.producto)
                    widget.subirArchivo(context: context,
                        auth: Sesion.auth,
                        usuario: Sesion.usuario,
                        descripcion: descriptorController.text,
                        tipo: tipo);
                  else
                    widget.subirArchivo(context: context,
                        auth: Sesion.auth,
                        usuario: Sesion.usuario, descripcion: descriptorController.text, tipo: tipo
                        ,precio: precioController.text,descripcionProducto: descriptorProductoController.text,categoria: categoriaElegida);

                  Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst);

                },)
            ),

            Align(alignment: Alignment.bottomLeft,
              child: IconButton(icon: Icon(Icons.arrow_back),onPressed: ()=>{Navigator.pop(context)},),
            )


          ],)
            ,)

      )


    );
  }

  _encontrarCategorias() async
  {
    var url = "${Sesion.servidor}/API/categorias";
    var request = await http.get(Uri.parse(url),);

    List nuevaLista = jsonDecode(request.body);

    lista = nuevaLista.map<String>((e) => e['nombre']).toList();
    lista.add('Elegir categoría');

  }


  }



