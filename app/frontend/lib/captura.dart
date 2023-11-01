import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:camera/camera.dart';
import 'package:instafoto/nuevaPublicacion.dart';
import 'package:instafoto/reproductorVideo.dart';
import 'package:video_player/video_player.dart';

import 'Sesion.dart';
import 'main.dart';

class Captura extends StatefulWidget {
  const Captura({super.key, required this.archivo,required this.EsFotoPerfil});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  final XFile archivo;
  final bool EsFotoPerfil;

  @override
  State<Captura> createState() => _CapturaState();
}

class _CapturaState extends State<Captura> {

  late File archivo ;
  late VideoPlayerController controladorVideo;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //_subirImagen();
    archivo = File(widget.archivo.path);
    print(widget.archivo.path);

    if(archivo.path.endsWith("mp4"))
    {
    controladorVideo = VideoPlayerController.file(File(archivo.path))..initialize().then((_) {
      setState((){});

    });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:
            Stack(
                children:[

                  if(archivo.path.endsWith("jpg"))...[
                    Image.file(archivo),
                  ]
                  else if(archivo.path.endsWith("mp4"))...[
                    SafeArea(child:Center(
                              child: reproductorVideo(archivo)

                              /*controladorVideo.value.isInitialized
                                  ? Column(children: [

                              AspectRatio(
                              aspectRatio: controladorVideo.value.aspectRatio,
                                child: VideoPlayer(controladorVideo),
                              )
                              ,
                                FloatingActionButton(
                                  onPressed: () {
                                    setState(() {
    controladorVideo.value.isPlaying
                                          ? controladorVideo.pause()
                                          : controladorVideo.play();
                                    });
                                  },
                                  child: Icon(
    controladorVideo.value.isPlaying ? Icons.pause : Icons.play_arrow,
                                  ),),

                              ],)
                                  : new CircularProgressIndicator()
                    )*/
                    )
    ),

                ],

                  Align(alignment: Alignment.bottomRight,
                      child:
                      IconButton(icon: Icon(Icons.check),onPressed: (){
                        if(widget.EsFotoPerfil)
                          _subirImagenPerfil(widget.archivo, Sesion.usuario);
                        else
                          Navigator.push(context,  MaterialPageRoute(builder: (context) => NuevaPublicacion(archivo: archivo)));

                      },)
                  ),

                  Align(alignment: Alignment.bottomLeft,
                    child: IconButton(icon: Icon(Icons.arrow_back),onPressed: ()=>{Navigator.pop(context)},),
                  )
    ]

            ),

    );
  }

  _subirImagenPerfil(imagen,usuario) async
  {
    var url = "${Sesion.servidor}/API/fotoPerfil";
    var request = new http.MultipartRequest("POST", Uri.parse(url));
    request.fields['usuario'] = usuario;
    request.files.add(http.MultipartFile.fromBytes('picture',
        File(imagen.path).readAsBytesSync(),
        filename: DateTime.now().millisecondsSinceEpoch.toString() + Sesion.usuario + ".jpg"));

    var res = await request.send();

    var respuesta = await res.stream.bytesToString();

    print(respuesta);

  }


}