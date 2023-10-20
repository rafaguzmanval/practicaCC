


import 'package:flutter/material.dart';
import 'package:instafoto/cartera.dart';
import 'package:instafoto/respuestaHTTP.dart';
import 'package:instafoto/salavirtual.dart';
import 'package:universal_html/html.dart' as uniHtml;
import 'package:http/http.dart' as http;
import 'package:go_router_flow/go_router_flow.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'Sesion.dart';
import 'main.dart';

Widget ajustes(BuildContext context){


  return

    Container(

      decoration: BoxDecoration(gradient: LinearGradient(colors: [paletaAmarilla.shade900,paletaRoja.shade900],begin: Alignment.topLeft, end: Alignment.bottomRight,)),
      child:

          Container(

            padding: EdgeInsets.only(top: 30,bottom: 30,left: 30,right: 30),
           // constraints: BoxConstraints(maxHeight: 500,maxWidth: 500,minWidth: 50,minHeight: 50),


            margin:EdgeInsets.only(left:MediaQuery.of(context).size.width*(2/11) ,right: MediaQuery.of(context).size.width*(2/11),top:MediaQuery.of(context).size.height*(1/10),bottom:MediaQuery.of(context).size.height*(1/10)),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Colors.white38),
            child:

            Column(

              children: [

                Spacer(),

                GestureDetector(child:
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text("Cartera ",style: TextStyle(fontSize: 25),) , Icon(Icons.wallet,size: 30,)],),
                  onTap: (){
                    Navigator.push(context,MaterialPageRoute(builder: (context) =>Cartera()));
                  },
                ),

                Spacer(),

                GestureDetector(child:
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text("Sala virtual ",style: TextStyle(fontSize: 25),) , Icon(Icons.location_city,size: 30,)],),
                  onTap: ()async{
                    await Navigator.push(context,MaterialPageRoute(builder: (context) => salaVirtual()));
                    Sesion.nombrePagina = "home";
                  },

                ),

                Spacer(flex: 2,),

                TextButton(
                    key : Key("cerrarSesion"),
                    onPressed: () async{

                  _cerrarSesion(context);

                }, child: Text('Cerrar Sesión',style: TextStyle(fontSize: 25,color: paleta.shade100),)),

                Spacer(),

                TextButton(
                    key : Key("eliminarCuenta"),
                    onPressed: () async{


                  TextEditingController controlador = TextEditingController();
                  //borrar la cookie en caso de estar en el navegador

                  showDialog(context: context, builder: (context){
                    return Dialog(

                      child: Column(children: [
                        Text("Introduce tu clave para eliminar la cuenta:"),

                        TextField(
                          key : Key("inputClave"),
                          controller: controlador,),


                        Row(


                          children: [

                          TextButton(
                              key : Key("confirmarEliminacion"),
                              onPressed: () async{

                            eliminarCuenta(context : context, usuario: Sesion.usuario,
                                clave: controlador.text, token: Sesion.auth);

                          }, child: Text("Sí")),
                          TextButton(onPressed: (){Navigator.pop(context);}, child: Text("No")),

                        ],)

                      ],),

                    );
                  });

                }, child: Text('Eliminar cuenta',style: TextStyle(color: paletaRoja.shade400,fontSize: 20.0),)),

                Spacer(),

                /*TextButton(onPressed: (){
      //Navigator.push(context, MaterialPageRoute(builder: (context) => WebGlCamera(fileName: "graficos")));

    }, child: Text("graficos"))*/

              ],),
          )


      ,);

}

_cerrarSesion(BuildContext context) async {
  //borrar la cookie en caso de estar en el navegador
  if(uniHtml.document.cookie != null)
  {
    await http.get(Uri.parse('${Sesion.servidor}/logout'));
  }

  Sesion.streamMensajes.close();

  Sesion.permisos = 0;

  Sesion.status = Status.Desconectando;

  print(context);

  context.go('/');
}

Future<RespuestaHTTP> eliminarCuenta({required BuildContext? context, required String usuario,
  required String clave, required String token}) async{

  var body = {'usuario':usuario, 'clave':clave, 'auth': token};
  var respuesta = await http.post(Uri.parse('${Sesion.servidor}/API/eliminarCuenta'),body: body);

  if(respuesta.statusCode == 200)
  {
    if(uniHtml.document.cookie != null)
    {

      await http.get(Uri.parse('${Sesion.servidor}/logout'));
    }

    Sesion.permisos = 0;
    Sesion.status = Status.Desconectando;

    if(context != null)
    GoRouter.of(context).go('/');



  }
  return RespuestaHTTP(respuesta.statusCode, respuesta.body);
}