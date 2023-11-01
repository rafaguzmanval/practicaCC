

import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:instafoto/chat.dart';
import 'package:instafoto/llamada.dart';
import 'package:instafoto/perfil.dart';
import 'package:socket_io_client/socket_io_client.dart';

import 'directo.dart';
import 'main.dart';

var nombreAnterior;
var contextoAnterior;

enum Status{
  Inicio,
  Login,
  Llamada,
  Desconectando

}

class Sesion{
  static const String _ipVPN = "172.26.68.172";
  static const String _ipLocal = "192.168.0.28";
  static const String _ipUsada = _ipLocal;
  static const String servidor = "https://${_ipUsada}:4000";
  static const String servidorHttp = "http://${_ipUsada}:3000";
  static var cookiesAceptadas = false;

  static var test = false;


  static var paginaActual;

  static String nombrePagina = "Login";
  static var controlador;
  static var correo = "";
  static var usuario = "";
  static var permisos = 0;


   static late Socket socket;
  static var notificaciones = 0;
  static var publicacionBorrada = false;
  static var contactos = [];
  static var status = Status.Inicio;
  static var auth = "0";
  static var nMensajes = 0;
  static StreamController streamMensajes = StreamController();

  static var chatActual = null;
  static var controladorStreamChat = StreamController();



  static inicializarSocket(String server)
  {
    socket = io("${server}", <String, dynamic>{
      'transports': ['websocket'],
      'rejectUnauthorized': false,
      'withCredentials' : false,
      'autoConnect': false,

      //'secure' : true
      'extraHeaders': {'verify' :false}
    }
    );

    socket.connect();

    socket.onConnectError((data) =>
        print(data));


    socket.onConnect( (_) {
      print('conectado por socket.io');
      socket.emit('auth',Sesion.usuario);
    }
    );

    socket.on('notificacion',(n){
      AwesomeNotifications().createNotification(content: NotificationContent(id: notificaciones, channelKey: 'basic_chanel', title: n,body: 'nueva noti'));
      notificaciones++;

    });

    socket.on('follow',(res){

      print(Sesion.paginaActual.toString());
      if(Sesion.nombrePagina == 'perfil')
        {
          ScaffoldMessenger.of(Sesion.paginaActual.context).showSnackBar(
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
                  child: Text("Ahora sigues a " + res[1]),
                )),


          );
          cargarPerfil(res[1],Sesion.controlador);
        }

    });

    socket.on('unfollow',(res){

      print(Sesion.paginaActual.toString());
      if(Sesion.nombrePagina == 'perfil')
      {
        ScaffoldMessenger.of(Sesion.paginaActual.context).showSnackBar(
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
                child: Text("Has de dejado de seguir a " + res[1]),
              )),
        );


        cargarPerfil(res[1],Sesion.controlador);
        // pedirFotos(correo, controlador);
      }

    });


    socket.on("chats", (data) {
      Sesion.contactos = data;
      Sesion.controlador.add("");
      //print(data);
    });

    socket.on("mensajeEntrante", (data) {
      var pagina = true;
      //print("nuevo mensaje " + paginaActual.toString());
      if(chatActual != null)
        {

          if(chatActual == data[0])
            {
              pagina = false;
              print("nuevo mensaje :" + data[1]);

              Mensaje msg = new Mensaje(data[0],data[1],data[2], data[3], data[4], data[5]);

              controladorStreamChat.add(msg);

              //Sesion.paginaActual.recibirMensaje(msg);
            }

        }

      if(pagina)
        {
          if(WebRTC.platformIsAndroid)
            {
              AwesomeNotifications().createNotification(content: NotificationContent(id: notificaciones, channelKey: 'basic_chanel', title: data[3],body: data[2]));
              notificaciones++;
            }

          Sesion.nMensajes++;
          streamMensajes.add(Sesion.nMensajes);

          //print("nuevo mensaje de  " + data[3] + data[2]);

        }


    });

    socket.on("mensaje", (data) {

      if(chatActual == -1)
        {
          chatActual = data;
          controladorStreamChat.add(data);
        }

    });

    socket.on("cargaMensajes", (data) {

      var mensajes = data;

      //print("nuevos mensajes " + mensajes[0]);

      controladorStreamChat.add(data);

      var nuevoArray = <Mensaje>[];

      for(int i = 0; i < mensajes.length; i++)
        {
          Mensaje msg = new Mensaje(mensajes[i]['idChat'], mensajes[i]['tipo'],mensajes[i]['contenido'], mensajes[i]['emisor'], mensajes[i]['receptor'], mensajes[i]['tiempo']);
          nuevoArray.add(msg);
        }

      controladorStreamChat.add(nuevoArray);



    });

    socket.on("pedirOferta", (data) {

      Sesion.paginaActual.llegadaOferta(data[0]);
      Sesion.paginaActual.interlocutor = data[1];
    });

    socket.on("respuesta", (data) {
        Sesion.paginaActual.llegadaRespuesta(data);
    });

    socket.on("candidato", (data) {
      Sesion.paginaActual.llegadaCandidato(data);
    });
    
    socket.on("pedirCandidato", (data) {
      print("envio a ${data} mi candidato ${Sesion.paginaActual.candidatos[0]}");
      socket.emit('candidato',[Sesion.paginaActual.candidatos[0],data]);
    });

    socket.on('infoPublicacion',(data) {

      if(Sesion.nombrePagina == 'publicacion')
        {
          print(data[0].toString() + " " + data[1].toString());
          Sesion.paginaActual.nuevosLikes(data[0],data[1]);
        }

    });

    socket.on('llamada',(data) async{

      print('llamada entrante');
      print(paginaActual.toString() + "  " + nombrePagina.toString());

      nombreAnterior = nombrePagina;
      contextoAnterior = paginaActual;
      var statusprevio = status;
      status = Status.Llamada;
      await Navigator.push(paginaActual.context, MaterialPageRoute(builder: (context) => Llamada(emisor: data[0],oferta: data[1])));

      Sesion.paginaActual = contextoAnterior;
      nombrePagina = nombreAnterior;
      status = statusprevio;
      print("PAGINA ACTUAL  " + paginaActual.toString() + "  " + nombrePagina.toString());

    });

    socket.on('cancelarLlamada',(data) {

      //print(nombrePagina);
      if(nombrePagina == "llamada")
        {
          print('llamada cancelada');

          Navigator.pop(paginaActual.context);
          Sesion.paginaActual = contextoAnterior;
          nombrePagina = nombreAnterior;
        }
      else
        {
          print("fallo: no hay llamada");
        }



    });


    socket.on('nuevoJugador',(data){


      if(Sesion.nombrePagina =="salavirtual")
        {
          print(data);

          Sesion.paginaActual.instanciarNuevoJugador(data[0],data[1]);
        }

    //scene.instanciarModelo("perico");


    //console.log("me he conectado")
    });

    socket.on('cargarSala',(data){

      if(Sesion.nombrePagina =="salavirtual")
      {
        //print("nuevoJugador" );

        Sesion.paginaActual.cargarSala(data);
      }

    });


    socket.on("dejarSala",(data){
            if(Sesion.nombrePagina =="salavirtual")
            {
              //print("nuevoJugador" );

              Sesion.paginaActual.dejarSala(data);
            }
        }
    );

    socket.on('movimiento',(data){


      if(Sesion.nombrePagina =="salavirtual")
      {
        //print("nuevoJugador" );

        Sesion.paginaActual.moverJugador(data[0],data[1],data[2]);
      }

      //scene.instanciarModelo("perico");


      //console.log("me he conectado")
    });

  }




  }



