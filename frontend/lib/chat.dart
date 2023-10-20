

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instafoto/directo.dart';
import 'package:instafoto/main.dart';
import 'package:http/http.dart' as http;

import 'Sesion.dart';

class Chat extends StatefulWidget {
  const Chat({super.key, required this.usuario,required this.idChat});

  final String usuario;
  final int idChat;

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<Chat> createState() => _ChatState();
}

class Mensaje{
  int idChat;
  String contenido;
  String tipo;
  String emisor;
  String receptor;
  int tiempo;
  Mensaje(this.idChat, this.tipo,this.contenido,  this.emisor,this.receptor, this.tiempo);
}

class _ChatState extends State<Chat> {

  StreamController controladorStreamMensajes = new StreamController();
  var usuario = "";

  var i = 0;
  int idChat = -1;


  @override
  void initState() {
    // TODO: implement initState
    Sesion.paginaActual = this;
    Sesion.nombrePagina = "chat";
    usuario = widget.usuario;
    idChat = widget.idChat;

    //print("nuevo chat " + widget.usuario + " ${widget.idChat} ");

    super.initState();
    //Timer.periodic(Duration(seconds: 1), (timer) { nuevoMensaje(Mensaje("mensaje " + i.toString(), "texto", i%2==0?"b":"loco", "loco", 24231412)); i++; setState(() {
    //});});
  }

  @override
  void dispose() {
    controladorStreamMensajes.close();
    Sesion.nombrePagina = "Home";
    super.dispose();
  }


  @override
  Widget build(BuildContext context){

    return chatWidget(context, widget.usuario, widget.idChat);
    //return chatWidget(context, usuario);
  }



}


enviarMensaje(Mensaje mensaje)
{
  //recibirMensaje(mensaje);
  Sesion.socket.emit("mensaje",[mensaje.idChat,mensaje.tipo,mensaje.contenido,mensaje.emisor,mensaje.receptor,mensaje.tiempo]);
}

void showInSnackBar(BuildContext context,String message) {
  ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(message)));
}




Widget chatWidget(BuildContext context,String usuario,int idC)
{

  Sesion.chatActual = idC;
  Sesion.controladorStreamChat.close();
  Sesion.controladorStreamChat = new StreamController();

  ScrollController controladorLista = new ScrollController();
  var mensajes = [];
  TextEditingController controladorMensaje = new TextEditingController();
  TextEditingController controladorDinero = new TextEditingController();

  var idChat = idC;

  print("chatt elegido  " + idChat.toString());

  if(idChat != -1)
    Sesion.socket.emit("cargaMensajes",idChat);

  int scrollDown = 0;


  return Scaffold(

    appBar: AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      flexibleSpace: SafeArea(
        child: Container(
          padding: EdgeInsets.only(right: 16),
          child: Row(
            children: <Widget>[

              if(!kIsWeb)...[
                IconButton(
                  key: Key("back"),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back,color: Colors.black,),
                ),
              ],
              SizedBox(width: 2,),
              CircleAvatar(
                backgroundImage: NetworkImage("${Sesion.servidor}/API/pedirFotoperfil/${usuario}"),
                maxRadius: 20,
              ),
              SizedBox(width: 12,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(usuario,style: TextStyle( fontSize: 16 ,fontWeight: FontWeight.w600),),
                    SizedBox(height: 6,),
                    Text("Desconectado",style: TextStyle(color: Colors.grey.shade600, fontSize: 13),),
                  ],
                ),
              ),
              IconButton(onPressed: ()async{

                var nombreAnterior = Sesion.nombrePagina;
                var contextoAnterior = Sesion.paginaActual;
                var statusprevio = Sesion.status;
                Sesion.status = Status.Llamada;
                await Navigator.push(context, MaterialPageRoute(builder: (context) => Directo(receptor: usuario,tipo: 'emisor',oferta: '',)));

                Sesion.paginaActual = contextoAnterior;
                Sesion.nombrePagina = nombreAnterior;
                Sesion.status = statusprevio;
                print("PAGINA ACTUAL  " + Sesion.paginaActual.toString() + "  " + Sesion.nombrePagina.toString());


                },

                  icon: Icon(Icons.phone,color: Colors.black54,))
              ,
            ],
          ),
        ),
      ),
    ),


    body:  SafeArea(

  child:
  Stack(children: [


  SizedBox(height: 10,),


  StreamBuilder(
  stream: Sesion.controladorStreamChat.stream,
  builder: (context,snapshot) {

                if(!snapshot.hasData && idC != -1)
                  return Center(child: new CircularProgressIndicator(),);

                if(snapshot.data is List)
                  {
                    //print(snapshot.data);
                    mensajes = snapshot.data;
                  }
                else if(snapshot.data is Mensaje)
                  {
                    mensajes.add(snapshot.data);
                  }
                else if(idChat == -1 && snapshot.data is int)
                  {
                    idChat = snapshot.data;
                  }


                if(scrollDown < mensajes.length){


                  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    if(controladorLista.hasClients)
                    {
                      if(scrollDown == 0)
                        controladorLista.jumpTo(controladorLista.position.maxScrollExtent);
                      else
                        controladorLista.animateTo(controladorLista.position.maxScrollExtent, duration: Duration(seconds: 1), curve: Curves.ease);
                    }


                    scrollDown = mensajes.length;

                  });

                }


                return  ListView.builder(
                    itemCount: idChat==-1?0:mensajes.length,

                    shrinkWrap: true,
                    padding: EdgeInsets.only(top: 10,bottom: 60),
                    physics: ScrollPhysics(),
                    controller: controladorLista,


                    itemBuilder: (context,index) {
                      var tiempo = DateTime.fromMillisecondsSinceEpoch(mensajes[index].tiempo);
                      var contenido = mensajes[index].contenido;


                      if(mensajes[index].tipo == "operacion")
                      {
                        var partes = mensajes[index].contenido.toString().split("#");

                        if(Sesion.usuario == partes[0])
                        {
                          contenido = "Has dado ${partes[1]}€";
                        }
                        else
                        {
                          contenido = "${partes[0]} te ha dado ${partes[1]}€";
                        }
                      }

                      return Container(
                        padding: EdgeInsets.only(left: 14,right: 14,top: 10,bottom: 10),
                        child: Align(
                          alignment: (mensajes[index].emisor!= Sesion.usuario?Alignment.topLeft:Alignment.topRight),
                          child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: (mensajes[index].emisor == Sesion.usuario? Colors.grey.shade200:Colors.blue[200]),

                              ),
                              padding: EdgeInsets.all(16),
                              child:
                              Column(children:[


                                Text(contenido,style: TextStyle(fontSize: mensajes[index].tipo == "operacion"?20:15, color: mensajes[index].tipo == "operacion"?Colors.lightGreen:Colors.black87), ),

                                Text(
                                  '${tiempo.hour.toString()}:${tiempo.minute.toString()}',style: TextStyle(fontSize: 10), textAlign: TextAlign.right,)


                              ])
                          ),
                        ),
                      );

                    });
        }),

    /**
     * OPCIONES DEL CHAT
     */
    Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        padding: EdgeInsets.only(left: 10,bottom: 10,top: 10),
        height: 60,
        width: double.infinity,
        color: Colors.white,
        child: Row(
          children: <Widget>[
            GestureDetector(
              onTap: (){
                showModalBottomSheet<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return SizedBox(
                      height: 200,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ElevatedButton(
                              child:  Row(children: [
                                Text('Enviar dinero '),
                                Icon(Icons.monetization_on)],),
                              onPressed: () async{

                                await showDialog(context: context, builder: (context){
                                  return Dialog(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                        children:[TextField(

                                          controller: controladorDinero,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              hintText: 'Cantidad'
                                          ),


                                        ),

                                          ElevatedButton(onPressed: ()async{

                                            var body = {'usuario1':Sesion.usuario,'usuario2':usuario, 'dinero': controladorDinero.text};
                                            var response = await http.post(Uri.parse("${Sesion.servidor}/API/donacion"),
                                                body: body);

                                            if(response.body == "ok")
                                            {
                                              Navigator.pop(context);
                                              showInSnackBar(context,"Operación exitosa");

                                              Mensaje nuevoMensaje = Mensaje(idChat, "operacion", "${Sesion.usuario}#${controladorDinero.text}", Sesion.usuario, usuario, DateTime.now().millisecondsSinceEpoch);
                                              enviarMensaje(nuevoMensaje);

                                              Sesion.controladorStreamChat.add(nuevoMensaje);

                                              controladorDinero.text = "";
                                            }
                                            else if(response.body == "NoMoney"){
                                              Navigator.pop(context);
                                              showInSnackBar(context,"No tienes suficiente dinero");
                                            }
                                            else
                                            {
                                              Navigator.pop(context);
                                              showInSnackBar(context,"Fallo en el sistema ${response.body}, vuelve a intentarlo");
                                            }



                                          }, child: Text('Enviar'))

                                        ]
                                    ),
                                  );
                                }
                                );

                                Navigator.pop(context);

                                //Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );

              },
              child: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  color: Colors.lightBlue,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Icon(Icons.add, color: Colors.white, size: 20, ),
              ),
            ),
            SizedBox(width: 15,),
            Expanded(
              child: TextField(
                key: Key("Input"),
                controller: controladorMensaje,
                decoration: InputDecoration(
                    hintText: "Escribe...",
                    hintStyle: TextStyle(color: Colors.black54),
                    border: InputBorder.none
                ),
              ),
            ),
            SizedBox(width: 15,),
            FloatingActionButton(
              key: Key("BotonEnviaMensaje"),
              onPressed: (){

                if(controladorMensaje.text.isNotEmpty)
                {

                  print("id del chat " + idChat.toString());
                  var nuevoMensaje = Mensaje(idChat, "texto",controladorMensaje.text, Sesion.usuario, usuario, DateTime.now().millisecondsSinceEpoch);
                  Sesion.controladorStreamChat.add(nuevoMensaje);
                  enviarMensaje(nuevoMensaje);

                  controladorMensaje.text = "";


                }


              },
              child: Icon(Icons.send,color: Colors.white,size: 18,),
              backgroundColor: Colors.blue,
              elevation: 0,
            ),
          ],

        ),
      ),
    )



  ]
  ,)));
}
