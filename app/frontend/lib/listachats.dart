

import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instafoto/main.dart';

import 'Sesion.dart';
import 'chat.dart';
import 'package:http/http.dart' as http;

var chatElegido = null;


Widget listaChat()
{

  print("listachat");
  chatElegido = null;
  StreamController controlador = StreamController();
  Sesion.controlador = controlador;
  Sesion.socket.emit("chats",Sesion.usuario);

  var resultado = [];

  return StreamBuilder(
      stream: controlador.stream,
      builder: (context,snapshot) {

       // print("nueva actualizacion " + chatElegido.toString());

    return kIsWeb?
          Row(children: [
            Container(child:  _listaDeChats(context,controlador, resultado),width: MediaQuery.of(context).size.width * 2 / 7,

                decoration: BoxDecoration(gradient: LinearGradient(colors: [paletaAmarilla.shade50,paletaRoja.shade900],begin: Alignment.topLeft, end: Alignment.bottomRight,)),
                ),

            chatElegido == null?

            Expanded(child: Center(child: Opacity(opacity: 0.3,child:
                    Image.asset("assets/images/logo.png",)              ),))
                      :

            Expanded(child: Center(child: Opacity(opacity: 1,child:
                     chatWidget(context, chatElegido['usuario'], chatElegido['idChat']),))),


            Container(width: (MediaQuery.of(context).size.width<1000.0 || !kIsWeb)?0.0:MediaQuery.of(context).size.width/10,
                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width/10,minWidth: 0.0),

                decoration: BoxDecoration(gradient: LinearGradient(colors:
                [paletaAmarilla.shade50,paletaRoja.shade900],begin: Alignment.topLeft, end: Alignment.bottomRight,)),)


          ],)
        :

    _listaDeChats(context,controlador,resultado);


  });

}

Widget _listaDeChats(BuildContext context,controlador,List resultado){
  return Column(
      children: [

        Padding(
          padding: EdgeInsets.only(top: 16,left: 16,right: 16),
          child: TextField(
            key: Key("Buscador"),
            onChanged: (n) async{
              if(n.isNotEmpty)
              {
                var response = await http.post(
                  Uri.parse("${Sesion.servidor}/API/buscar/perfiles/${n}"),
                );

                var res = jsonDecode(response.body)['res'];
                resultado.clear();

                for(int i = 0; i< res.length; i++)
                {
                  resultado.add(res[i]);
                }

                controlador.add('');
              }
            },
            decoration: InputDecoration(
              hintText: "Buscar chat...",
              hintStyle: TextStyle(color: Colors.grey.shade600),
              prefixIcon: Icon(Icons.search,color: Colors.grey.shade600, size: 20,),
              filled: true,
              fillColor: Colors.grey.shade100,
              contentPadding: EdgeInsets.all(8),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                      color: Colors.grey.shade100
                  )
              ),
            ),


          ),
        ),

        if(resultado.isEmpty)...[
          for(int i = 0 ; i < Sesion.contactos.length; i++)...[
            SizedBox(height: 5.0,),
            GestureDetector(
              key: Key("chat${Sesion.contactos[i]['user']}"),
              child:
                  _filaChat(Sesion.contactos[i]['user'],ultimoMensaje:Sesion.contactos[i]['ultimoMensaje']),
              //Row(children: [CircleAvatar(child:Image.network("${servidor}/API/pedirFotoperfil/${Sesion.contactos[i]['user']}")),Text(Sesion.contactos[i]['user'])],),
              onTap: (){
                if(kIsWeb)
                  {

                    try{
                      print("nuevo chat ${Sesion.contactos[i]['user']}  ${Sesion.contactos[i]['idChat']}" );

                      chatElegido = {'usuario' : Sesion.contactos[i]['user'],'idChat': Sesion.contactos[i]['idChat']};
                      //WidgetChatElegido = Builder(builder: (context) => chatElegido);
                      controlador.add('');

                    }
                    catch(e){
                      print(e);
                    }
                  }
                else
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Chat(usuario: Sesion.contactos[i]['user'], idChat: Sesion.contactos[i]['idChat'])));
                  }

              },


            ),

            SizedBox(height: 5.0,),
            Divider(),
            SizedBox(height: 2.0,)
          ]

        ]
        else...[
          for(int i = 0 ; i < resultado.length; i++)...[
            SizedBox(height: 5.0,),
            GestureDetector(
              key: Key("chat${resultado[i]['nombre']}"),
              child:
              _filaChat(resultado[i]['nombre']),
              //Row(children: [CircleAvatar(child:Image.network("${servidor}/API/pedirFotoperfil/${Sesion.contactos[i]['user']}")),Text(Sesion.contactos[i]['user'])],),
              onTap: () async {

                int index = Sesion.contactos.indexWhere((element) => element['user'] == resultado[i]['nombre']);
                int idchat = index == -1? -1:Sesion.contactos[index]['idChat'];

                if(kIsWeb)
                {
                 // chatElegido = Builder(builder: (context) => Chat(usuario: resultado[i]['nombre'], idChat: -1));
                  chatElegido = {'usuario' : resultado[i]['nombre'],'idChat': idchat};
                  controlador.add('');
                }
                else
                {
                  var npag = Sesion.nombrePagina;
                  var pAct = Sesion.paginaActual;
                  await Navigator.push(context, MaterialPageRoute(builder: (context) => Chat(usuario: resultado[i]['nombre'], idChat: idchat)));
                  Sesion.nombrePagina = npag;
                  Sesion.paginaActual = pAct;
                }


              },


            ),

            SizedBox(height: 5.0,),
            Divider(),
            SizedBox(height: 2.0,)
          ]
        ]
      ]


  );


}


Widget _filaChat(String nombre, {String? ultimoMensaje})
{
  return  Row(
      children: <Widget>[
        SizedBox(width: 20,),
        Expanded(

          child: Row(
            children: <Widget>[
              CircleAvatar(
                backgroundImage: NetworkImage("${Sesion.servidor}/API/pedirFotoperfil/${nombre}"),
                maxRadius: 30,
              ),
              SizedBox(width: 16,),
              Expanded(
                child: Container(
                  color: Colors.transparent,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(nombre, style: TextStyle(fontSize: 16),),
                      if(ultimoMensaje != null)...[
                        SizedBox(height: 6,),
                        Text(ultimoMensaje,style: TextStyle(fontSize: 14,color: paleta.shade200, fontWeight: false?FontWeight.bold:FontWeight.normal),),
                      ]

                    ],
                  ),
                ),
              ),
            ],
          ),
        )
      ]
  );
}