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
import 'camara.dart';
import 'main.dart';

class Directo extends StatefulWidget {
  const Directo({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<Directo> createState() => _DirectoState();
}

class _DirectoState extends State<Directo> {
  bool _offer = false;
  var respuesta = "";
  var candi = "";
  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;
  RTCVideoRenderer _localRenderer = new RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = new RTCVideoRenderer();

  final sdpController = TextEditingController();
  var texto = "hola";

  @override
  dispose() {
    _localStream?.dispose();
    _localRenderer.srcObject = null;
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    sdpController.dispose();
    super.dispose();
  }

  @override
  void initState()
  {
    Sesion.paginaActual = this;
    initRenderer();
    _createPeerConnecion().then((pc) {
      _peerConnection = pc;
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
        {
          "urls":
          "stun:stun.l.google.com:19302"

        },
      ]
    };

    final Map<String, dynamic> offerSdpConstraints = {
      "mandatory": {
        "OfferToReceiveAudio": true,
        "OfferToReceiveVideo": true,
      },
      "optional": [],
    };



    //CONEXION CAMARA
    _localStream = await _getUserMedia();

    RTCPeerConnection pc =
    await createPeerConnection(configuration, offerSdpConstraints);

    //pc.createDataChannel('channel', RTCDataChannelInit());

    _localStream!.getTracks().forEach((track) {
      pc.addTrack(track,_localStream!);
    });

    setState(() {

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
          print(candidato);

          if(!candidato.contains("network-cost") )
          {
            texto = texto +"\n\n"+ candidato;
            setState(() {

            });
          }


          if(!_offer && respuesta != "" && candi == "" && !candidato.contains("network-cost") && candidato.contains("172.26.37.136") && candidato.contains("UDP") )
          {
            candi = candidato;
            print("ENVIO DE LA INFORMACION DE VUELTA");
            Sesion.socket.emit("respuesta",[respuesta,candidato,Sesion.correo]);
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


    pc.onAddStream = (stream) {
      try{
        print('addStream: ' + stream.id);
        _remoteRenderer.srcObject = stream;
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

    final Map<String, dynamic> constraints2 = {
      'video': true,
      'audio': false
    };


    try {
      MediaStream stream;
      if(WebRTC.platformIsAndroid) {
        stream = await navigator.mediaDevices.getUserMedia(
            constraints);
      }
      else
      {
        stream = await navigator.mediaDevices.getDisplayMedia(constraints);
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
      await _peerConnection!.createOffer({'offerToReceiveVideo': 1});
      var session = parse(description.sdp.toString());
      print(json.encode(session));
      Sesion.socket.emit("oferta",[json.encode(session),Sesion.correo]);
      _offer = true;
      _peerConnection!.setLocalDescription(description);


    }
    catch(e){
      throw e;
    }
  }

  void llegadaOferta(oferta) async
  {
    print("oferta del tio:" + oferta);
    await _setRemoteDescription(oferta);
    respuesta = await _createAnswer();
    //print(respuesta);
    //
  }

  void llegadaRespuesta(data) async{

    print("llegada de la respuesta: \n" + data[0] + "\n" + data[1]);

    texto = "llegada de la respuesta: \n" + data[0] + "\n" + data[1];


    await _setRemoteDescription(data[0]);
    await _addCandidate(data[1]);

    setState(() {

    });
  }

  _createAnswer() async {
    try {
      _offer = false;
      RTCSessionDescription description =
      await _peerConnection!.createAnswer({'offerToReceiveVideo': 1});

      var session = parse(description.sdp.toString());

      _peerConnection!.setLocalDescription(description);
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
      print(description.toMap());

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
      print(session['candidate']);
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

  SizedBox videoRenderers() => SizedBox(
      height: 210,
      child: Row(children: [
        Flexible(
          child: new Container(
              key: new Key("local"),
              margin: new EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
              decoration: new BoxDecoration(color: Colors.black),
              child: new RTCVideoView(_localRenderer)),
        ),
        Flexible(
          child: new Container(
              key: new Key("remote"),
              margin: new EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
              decoration: new BoxDecoration(color: Colors.black),
              child: new RTCVideoView(_remoteRenderer)),
        )
      ]));

  Row offerAndAnswerButtons() =>
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <Widget>[

        new ElevatedButton(
          // onPressed: () {
          //   return showDialog(
          //       context: context,
          //       builder: (context) {
          //         return AlertDialog(
          //           content: Text(sdpController.text),
          //         );
          //       });
          // },
          onPressed: _createOffer,
          child: Text('llamar'),
          // color: Colors.amber,
        ),

        new ElevatedButton(
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
        ),


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
      child: Text(texto)
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Directo"),
        ),
        body: SingleChildScrollView(child: Container(
            child: Container(
                child: Column(
                  children: [
                    videoRenderers(),
                    offerAndAnswerButtons(),
                    sdpCandidatesTF(),
                    sdpCandidateButtons(),
                  ],
                ))

        )));
  }

}