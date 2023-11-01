

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:instafoto/main.dart';
import 'package:video_player/video_player.dart';

import 'package:dio/dio.dart';

import 'package:path_provider/path_provider.dart';

import 'Sesion.dart';


Widget reproductorVideo(File archivo)
{
  StreamController controladorStream = new StreamController();
  VideoPlayerController controladorVideo = VideoPlayerController.file(File(archivo.path))..initialize().then((_) {

    controladorStream.add("");
  });

  return
    StreamBuilder(
        stream: controladorStream.stream,
        builder: (context,snapshot){


     return  Column(children: [

        AspectRatio(
          aspectRatio: controladorVideo.value.aspectRatio,
          child: VideoPlayer(controladorVideo),
        )
        ,
        FloatingActionButton(
          onPressed: () {
            controladorVideo.value.isPlaying
                ? controladorVideo.pause()
                : controladorVideo.play();

            controladorStream.add("");

          },
          child: Icon(
            controladorVideo.value.isPlaying ? Icons.pause : Icons.play_arrow,
          ),),

      ],);
    });


}


Widget reproductorVideoNetwork(String url)
{
  print(url);
  StreamController controladorStream = new StreamController();

  var controladorVideo = VideoPlayerController.network(url);

  var botonVisible = true;

  var icono = Icons.play_arrow;
  //controladorVideo.setLooping(true);
  _inicializarVideoPlayer(controladorVideo,controladorStream);


  controladorVideo.addListener(() {

    if(controladorVideo.value.duration != Duration.zero && controladorVideo.value.duration == controladorVideo.value.position)
    {
      print("VIDEO FINALIZADO");
      icono = Icons.play_arrow;
      botonVisible = true;
      controladorVideo.seekTo(Duration.zero);
      controladorStream.add("");
    }
  });

  return

    StreamBuilder(
        stream: controladorStream.stream,
        builder: (context,snapshot) {


          return  GestureDetector(child: Stack(

              children: [

              /*AspectRatio(
                aspectRatio: controladorVideo.value.aspectRatio,
                child:*/
                VideoPlayer(controladorVideo),
             /* /)*/

                Visibility(
                    visible: botonVisible,
                    child:
                Align(
                alignment: Alignment(0, 0),
                  child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                    border: Border.all(),
                    borderRadius: BorderRadius.all(Radius.circular(30))),

                child:
              Icon(
                icono ,color: paletaRoja[50],size: 50,
              )
                ,)
              ))

            ],),onTapDown: (_){

              if(controladorVideo.value.isPlaying)
                {
                  icono = Icons.pause;
                  controladorVideo.pause(); botonVisible = true;
                }
              else
                {
                  controladorVideo.play(); botonVisible = false;
                }

                controladorStream.add("");

              },);


        });


}


_inicializarVideoPlayer(controladorVideo,controladorStream) async
{

  await controladorVideo.initialize().catchError((error){print("ERRROR " + error);});
  controladorStream.add("");

}