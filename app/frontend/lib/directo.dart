import 'dart:async';
import 'dart:convert';
import 'dart:developer';
//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:http/http.dart' as http;
import 'package:camera/camera.dart';
import 'package:instafoto/Sesion.dart';
import 'package:sdp_transform/sdp_transform.dart';
import 'package:logger/logger.dart';

import 'Sesion.dart';

class Directo extends StatefulWidget {
  const Directo({super.key, required this.receptor, required this.tipo, required this.oferta});

  final String receptor;
  final String tipo;
  final String oferta;
  @override
  State<Directo> createState() => _DirectoState();
}

class _DirectoState extends State<Directo> {
  bool _offer = false;
  bool _answer = false;
  var interlocutor = "";
  var respuesta = "";
  var candidatos = [];
  var candi = "";
  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;
  RTCVideoRenderer _localRenderer = new RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = new RTCVideoRenderer();

  StreamController controladorStream = StreamController();
  var texto = "hola";

  @override
  dispose() {
    print("Destruyendo retransmision");
    //Sesion.paginaActual = Sesion.contextoAnterior;
    //Sesion.nombrePagina = Sesion.nombreAnterior;

    print("PAGINA ACTUAL  " + Sesion.paginaActual.toString() + "  " + Sesion.nombrePagina.toString());


    _peerConnection?.close();
    _localStream?.dispose();
    _localRenderer.srcObject = null;
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    super.dispose();
  }

  @override
  void initState()
  {

    interlocutor = widget.receptor;
    initRenderer();
    _createPeerConnecion().then((pc) async {
      _peerConnection = pc;

      if(widget.tipo == 'emisor')
        {
          //Sesion.nombreAnterior = Sesion.nombrePagina;
          //Sesion.contextoAnterior = Sesion.paginaActual;
          _createOffer();
        }
      if(widget.tipo == 'receptor')
        {
           llegadaOferta(widget.oferta);
        }

      Sesion.paginaActual = this;
      Sesion.nombrePagina = "llamada";

    });
    super.initState();
  }

  initRenderer() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
  }



  _createPeerConnecion() async {
    Map<String, dynamic> configuration = {
      "iceServers": [

          /*{
            'urls': "turn:relay.metered.ca:443",
            'username': "7fb18753f36fdd3a9bb9c62a",
            'credential': "K+WlktxBW9ubqpfn",
          },*/
        {
          'urls': [
            "stun:stun.l.google.com:19302"
          ]
        }
      ],
      'sdpSemantics': 'unified-plan'
    };

    final Map<String, dynamic> _config = {
      "mandatory": {
      },
      "optional": [{'DtlsSrtpKeyAgreement':true}],
    };
    final Map<String, dynamic> offerSdpConstraints = {
      "mandatory": {
        "OfferToReceiveAudio": false,
        "OfferToReceiveVideo": false,
      },
      "optional": [],
    };



    //CONEXION CAMARA
    _localStream = await _getUserMedia();

    if(WebRTC.platformIsAndroid)
    {

      setState(() {

      });
    }

    RTCPeerConnection pc =
    await createPeerConnection(configuration, _config);

    //pc.createDataChannel('channel', RTCDataChannelInit());

    _localStream!.getTracks().forEach((track) {
      pc.addTrack(track,_localStream!);
    });


    /////////

    pc.onIceCandidate = (e) {
      try{
      if (e.candidate != null) {
        var candidato = json.encode({
          'candidate': e.candidate.toString(),
          'sdpMid': e.sdpMid.toString(),
          'sdpMlineIndex': e.sdpMLineIndex,
        });


        if(candidato.contains("typ host") && (candidato.contains("192.168")))
          {
            texto = texto +"\n\n"+ candidato;
            controladorStream.add("");

            candidatos.add(candidato);

          }
        //print(candidato);

        if(respuesta != "" && candi == "" && candidato.contains("192.168") )
          {
            candi = candidato;
            //print("ENVIO DE LA INFORMACION DE VUELTA");
            print("candidato ${candi}");
            Sesion.socket.emit("candidato",[candi,interlocutor]);
          }

      }
      }
      catch(e){
        throw e;
      }
    };

    pc.onIceConnectionState = (e) {
      try {
        print(e);

      }

        catch(e){
          throw e;
        }
    };

    pc.onRenegotiationNeeded = (){
      print("deberiamos renegociar");
      if(_answer)
        {
          print("Vamos a renegociar");
          Sesion.socket.emit('pedirCandidato',[interlocutor,Sesion.usuario]);
          /*_answer = false;
          _createOffer();*/

        }

    };

    pc.onAddStream = (stream) {
      try{
      print('addStream: ' + stream.id);
      _remoteRenderer.srcObject = stream;

      if(WebRTC.platformIsAndroid)
      {
        setState(() {

        });
      }
      }
      catch(e){
        throw e;
      }
    };

    return pc;
  }

  _conectarCamara() async
  {
    _localStream = await _getUserMedia();
  }

  _getUserMedia() async {

    final Map<String, dynamic> constraints = {
      'video': true,
      'audio': false,
    };

    try {
      MediaStream stream;
      if(WebRTC.platformIsAndroid) {
         stream = await navigator.mediaDevices.getUserMedia(
            constraints);
      }
      else
        {
          stream = await navigator.mediaDevices.getUserMedia(
              constraints);
          print(stream.toString());
          //stream = await navigator.mediaDevices.getDisplayMedia(constraints);
        }

      _localRenderer.srcObject = stream;
      // _localRenderer.mirror = true;

      /*setState(() {

      });
*/
      return stream;
    }catch(error) {
      throw error;
    }
  }

  void _createOffer() async {
    try{

    RTCSessionDescription description =
    await _peerConnection!.createOffer();
    var session = parse(description.sdp.toString());
    //print(json.encode(session));
    Sesion.socket.emit("oferta",[json.encode(session),Sesion.usuario,widget.receptor]);
    _offer = true;
    _peerConnection!.setLocalDescription(description);


  }
  catch(e){
    throw e;
  }
  }

  void llegadaOferta(oferta) async
  {
    //print("oferta del tio:" + oferta);
    await _setRemoteDescription(oferta);
    respuesta = await _createAnswer();
    Sesion.socket.emit("respuesta",[respuesta,interlocutor]);
    //print(respuesta);
    //
  }

  void llegadaRespuesta(data) async{

    //print("llegada de la respuesta: \n" + data);


    await _setRemoteDescription(data);


    /*setState(() {

    });*/
  }

  void llegadaCandidato(data) async{

    //print("llegada de la candidato : \n" + data);

    await _addCandidate(data);
  }

   _createAnswer() async {
    try {
      _offer = false;
      _answer = true;
      RTCSessionDescription description =
      await _peerConnection!.createAnswer();

      var session = parse(description.sdp.toString());

      await _peerConnection!.setLocalDescription(description);
      return json.encode(session);
    }
    catch(e){
      throw e;
    }
  }

   _setRemoteDescription(oferta) async {

    try{
    String jsonString = oferta;
    dynamic session = await jsonDecode('$jsonString');

    String sdp = write(session, null);

    RTCSessionDescription description =
    new RTCSessionDescription(sdp, _offer ? 'answer' : 'offer');
    //print(description.toMap());

    await _peerConnection!.setRemoteDescription(description);
    return true;

  }
  catch(e){
    throw e;
  }
  }

   _addCandidate(candidato) async {

    try {
      String jsonString = candidato;
      dynamic session = await jsonDecode('$jsonString');
      //print(session['candidate']);
      dynamic candidate =
      new RTCIceCandidate(
          session['candidate'], session['sdpMid'], session['sdpMlineIndex']);
      await _peerConnection!.addCandidate(candidate);
      return true;

  }
  catch(e){
    throw e;
  }

  }

  colgar()
  {
    Sesion.socket.emit('cancelarLlamada',[Sesion.usuario,interlocutor]);
    Navigator.pop(context);
  }

  Row offerAndAnswerButtons() =>
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <Widget>[




      ]);

  Row sdpCandidateButtons() =>
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <Widget>[

        /*ElevatedButton(
          onPressed: _addCandidate,
          child: Text('Add Candidate'),
          // color: Colors.amber,
        ),*/

        /*ElevatedButton(
          onPressed: _conectarCamara,
          child: Text('grabar'),
          // color: Colors.amber,
        )*/
      ]);

  Padding sdpCandidatesTF() => Padding(
    padding: const EdgeInsets.all(16.0),
    child:
    StreamBuilder(
        stream: controladorStream.stream,
        builder: (context,snapshot){
      return     Text(texto);
    })

  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [

        Align(
        alignment: Alignment.topCenter,
        child: new Container(

        key: new Key("remote"),
        margin: new EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 205.0),
        decoration: new BoxDecoration(color: Colors.black),
        child: new RTCVideoView(_remoteRenderer)),
        ),
        Align(
        alignment: Alignment.bottomCenter,
        child:Container(
          width: 200,
        height: 200,
        key: new Key("local"),
    margin: new EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
    decoration: new BoxDecoration(color: Colors.black),
    child: new RTCVideoView(_localRenderer)
    ),
    ),

    Align(
    alignment: Alignment.bottomLeft,
    child:ElevatedButton(
    // onPressed: () {
    //   return showDialog(
    //       context: context,
    //       builder: (context) {
    //         return AlertDialog(
    //           content: Text(sdpController.text),
    //         );
    //       });
    // },
    onPressed: colgar,
    child: Icon(Icons.call_end),
    // color: Colors.amber,
    ),
    ),

/*
    Align(
      alignment: Alignment.bottomRight,
    child:ElevatedButton(
    // onPressed: () {
    //   return showDialog(
    //       context: context,
    //       builder: (context) {
    //         return AlertDialog(
    //           content: Text(sdpController.text),
    //         );
    //       });
    // },
    onPressed:(){

    Sesion.socket.emit('pedirOferta');

    }   ,
    child: Text('responder'),
    // color: Colors.amber,
    ))
  */
    ]));


  }

}