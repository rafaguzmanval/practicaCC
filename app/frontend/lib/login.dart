
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router_flow/go_router_flow.dart';
import 'package:http/http.dart' as http;
import 'package:instafoto/home.dart';
import 'package:instafoto/registro.dart';
import 'package:instafoto/respuestaHTTP.dart';

import 'Sesion.dart';
import 'main.dart';
import 'perfil.dart';



class Login extends StatefulWidget {
  const Login({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<Login> createState() => _LoginState();

  Future<RespuestaHTTP> login({BuildContext? context, required String correo, required String clave}) async
  {
    var body = {"correo" : correo, 'clave' : clave};

    print(body.toString());

    var response = await http.post(
      Uri.parse("${Sesion.servidor}/API/auth"),
      body: body,
    );

    var respuesta = jsonDecode(response.body);

    print(response.statusCode);

    if(response.statusCode != 200)
    {
      print("error");
      if(context != null)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.transparent,
              duration: Duration(seconds: 2),
              elevation: 0,
              content: Container(
                padding: const EdgeInsets.all(16),
                height: 90,
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(235, 23, 65, 0.92),
                  borderRadius: BorderRadius.all(Radius.circular(29)),

                ),
                child: Text("El correo o la contraseña son incorrectos"),
              )),
        );

      return RespuestaHTTP(response.statusCode, respuesta['auth']);
    }
    else
    {
      int permisos = respuesta['permisos'];

      if(context != null)
        {
          print("navegando a home");
          Sesion.auth = respuesta['auth'];
          Sesion.status = Status.Login;
          Sesion.correo = correo;
          Sesion.permisos = permisos;
          Sesion.usuario = respuesta['nombre'];

          context.go('/home');
        }

      return RespuestaHTTP(response.statusCode, respuesta['auth']);
    }

  }

}

class _LoginState extends State<Login> {


  TextEditingController Inputclave = new TextEditingController();
  TextEditingController Inputcorreo = new TextEditingController();


  @override
  void initState(){
    print("PAGINA DE LOGIN " + kIsWeb.toString());
    Sesion.permisos = 0;
    Sesion.correo = "";
    Sesion.usuario = "";
    super.initState();
  }

  @override
  void dispose() {
    Inputclave.dispose();
    Inputcorreo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    if(Sesion.cookiesAceptadas == false && kIsWeb)
      {
        Sesion.cookiesAceptadas = true;
        showDialog(context: context,
            barrierDismissible: false,
            barrierColor: Colors.black12,

            builder: (context){

          return Dialog(
            insetPadding: EdgeInsets.only(bottom: 10,top: MediaQuery.of(context).size.height*4/5,left: 10,right: 10),

            child:
            Container(
                constraints: BoxConstraints(minWidth: 100,maxWidth: 600),
                child: Column(
              mainAxisAlignment:MainAxisAlignment.start,
              children: [
                Expanded(child:  Text("Aviso de Cookies\n ",style: TextStyle(fontSize: 30),),),

                Expanded(child: Text("Solo se usa una cookie para mantener tu sesión abierta",style: TextStyle(fontSize: 25),textAlign: TextAlign.left,), ),
                Expanded(child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [TextButton(onPressed: (){Navigator.pop(context);}, child: Text("OK",style: TextStyle(fontSize: 30)))],))


              ],),)
          );

        });
      }

    return

      SafeArea(child: Scaffold(
        body:

            Container(

              decoration: BoxDecoration(gradient: LinearGradient(colors: [paletaAmarilla.shade50,paletaRoja.shade900],begin: Alignment.topLeft, end: Alignment.bottomRight,)),


              child:

              Center(child:

                  SingleChildScrollView(
                    child:

            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children:[

                  //Spacer(flex: 2,),

                  Container(
                    padding: EdgeInsets.only(top: 30,bottom: 30,left: 30,right: 30),
                    constraints: BoxConstraints(maxHeight: 500,maxWidth: 500,minWidth: 100,minHeight: 100),


                    margin:EdgeInsets.only(left:MediaQuery.of(context).size.width*(2/11) ,right: MediaQuery.of(context).size.width*(2/11),top:MediaQuery.of(context).size.height*(1/10),bottom:MediaQuery.of(context).size.height*(1/10)),

                    decoration: BoxDecoration(color: Colors.white38,borderRadius: BorderRadius.circular(40.0)),
                    child: Column(children: [

                    Image.asset("assets/images/imagotipo.png",width: kIsWeb?300:200,height: kIsWeb?300:200,),
                    //Image.network("http://${servidor}/API/imagenes.php?imagen=bird",height: 150,width: 150,),

                    Container(

                      //margin: EdgeInsets.only(left:MediaQuery.of(context).size.width/9 ,right: MediaQuery.of(context).size.width/9 ),
                      child: Column(children: [


                        
                            TextFormField(
                              key: Key("correo"),
                              controller: Inputcorreo,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                                  icon:  Icon(Icons.mail),
                                  hintText: 'Correo electrónico'
                              ),
                            ),
                        

                            TextFormField(
                              key: Key("clave"),
                              controller: Inputclave,
                              obscureText: true,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
                                  icon:  Icon(Icons.password),
                                  hintText: 'Clave'
                              ),
                            ),

                          SizedBox(height: 20.0,),

                          Align(
                            alignment:Alignment.centerRight,
                            child:ElevatedButton(

                                key: Key("Entrar"),

                                style: ElevatedButton.styleFrom(
                                    shape: StadiumBorder(),
                                    backgroundColor: paletaRoja.shade300
                                ),


                                onPressed: (){
                                  widget.login(context: context,correo: Inputcorreo.value.text,clave :Inputclave.value.text);},

                                child:

                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [

                                    Text("Entrar",style: TextStyle(fontWeight: FontWeight.w900),),
                                    Icon(Icons.arrow_forward)
                                  ],)),
                          )





                      ],),),



                  ],),),


                  //SizedBox(height: 20,),


                  OutlinedButton(
                    key: Key("Registro"),
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Registro(title: widget.title,)));
                    },

                      style: ButtonStyle(foregroundColor: MaterialStatePropertyAll<Color>(Color.fromRGBO(0, 0, 0, 0.99))),

                      child: Text("Crear una nueva cuenta",style: TextStyle(fontSize: 20.0),),),

                  //Spacer(flex: 2,)

                ]

            ),

                  )

    ),)


    ));
  }


}