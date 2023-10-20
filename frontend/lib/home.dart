import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router_flow/go_router_flow.dart';
import 'package:http/http.dart' as http;
import 'package:instafoto/ajustes.dart';
import 'package:instafoto/conocer.dart';
import 'package:instafoto/listachats.dart';
import 'package:instafoto/perfil.dart';
import 'package:instafoto/reproductorVideo.dart';
//import 'package:universal_html/html.dart';

import 'Sesion.dart';
import 'main.dart';

int noti= 0;

enum modoBusqueda {
  perfiles,
  productos
}


class Home extends StatefulWidget {
  const Home({super.key});


  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  //var imagenes = [];
  var data = "Sin mensajes";
  var _selectedIndex = 0;
  var camaraController;



  Widget home()
  {

    var publicaciones = [];
    StreamController controladorStream = new StreamController();
    _pedirMuro(controladorStream);

    //print("eres " + Sesion.permisos.toString());

    return
      RefreshIndicator(child:
      StreamBuilder(
        stream: controladorStream.stream,
        builder:(context,snapshot)
            {

              if(snapshot.data is List)
              publicaciones = snapshot.data;
              //print(snapshot.data);
              if(publicaciones.isNotEmpty) {

                //var publicaciones = (snapshot.data as List);

                return
                  SingleChildScrollView(
                    child:
                      Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [



                      Container(
                        width: MediaQuery.of(context).size.width  / 4,
                        constraints: BoxConstraints(minWidth: kIsWeb?400:200,maxWidth: 1000),
                        margin: EdgeInsets.only(left: MediaQuery.of(context).size.width/5,//((MediaQuery.of(context).size.width > 1000)? 1/4 : 1/10),
                            ), //( MediaQuery.of(context).size.width > 1000 )?MediaQuery.of(context).size.width*(2/4):  MediaQuery.of(context).size.width*(1/10)),
                        child:

                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //  IconButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => Directo()));}, icon: Icon(Icons.phone,color: Colors.black54,)),

                            for(int i = 0; i <
                                publicaciones.length; i++)...[

                              GestureDetector(child:
                              Container(child:
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  CircleAvatar(backgroundImage: NetworkImage(
                                      "${Sesion.servidor}/API/pedirFotoperfil/${publicaciones[i]['nombre']}")),
                                  Text((snapshot.data as List)[i]['nombre']),
                                ],),
                              ),

                                onTapUp: (_){
                                  context.push('/${publicaciones[i]['nombre']}');
                                },
                              ),

                              SizedBox(height: 10.0,),



                              if(publicaciones[i]['tipo'] == 'video')...[
                                GestureDetector(
                                  child:Container(
                                      constraints: BoxConstraints(minWidth: kIsWeb?400:250,maxWidth: 1000,minHeight: kIsWeb?400:250,maxHeight: 1000),
                                    decoration: BoxDecoration(border: Border.all(color: paletaRoja.shade600)),
                                    child: Center(child: reproductorVideoNetwork("${Sesion.servidor}/API/imagen/" +
                                        publicaciones[i]['nombre'] + '/' +
                                        publicaciones[i]['id'].toString())),
                                    width: MediaQuery.of(context).size.width*1/4,//(( MediaQuery.of(context).size.width > 1000 )?(1/4):(4/5)),
                                    height: MediaQuery.of(context).size.width*1/4),//(( MediaQuery.of(context).size.width > 1000 )?(1/4):(4/5)),),
                                  onDoubleTap: (){
                                    context.push('/${publicaciones[i]['nombre']}/${publicaciones[i]['id'].toString()}');
                                  },



                                ),


                              ]else...[

                                GestureDetector(child:
                                    Container(
                                      constraints: BoxConstraints(minWidth: kIsWeb?400:250,maxWidth: 1000),

                                                    child:
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                constraints: BoxConstraints(minWidth: kIsWeb?400:250,maxWidth: 1000,minHeight: kIsWeb?400:250,maxHeight: 1000),
                                                width: MediaQuery.of(context).size.width*1/4,//(( MediaQuery.of(context).size.width > 1000 )?(1/4):(4/5)),
                                                height: MediaQuery.of(context).size.width*1/4,//(( MediaQuery.of(context).size.width > 1000 )?(1/4):(4/5)),
                                                child:
                                              Image.network("${Sesion.servidor}/API/imagen/" +
                                                  publicaciones[i]['nombre'] + '/' +
                                                  publicaciones[i]['id'].toString(),


                                                fit: BoxFit.fill,),


                                              ),


                                            if(publicaciones[i]['tipo'] == 'producto')...[
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                              Text("${publicaciones[i]['descripcion']}"),
                                              Icon(Icons.sell),
                                              Text("${publicaciones[i]['precio']} €")
                                            ],)
                                            ]

                                            ],),
                                          ),


                                  onTapUp: (_){
                                    context.push('/${publicaciones[i]['nombre']}/${publicaciones[i]['id'].toString()}');
                                  },

                                ),
                              ],

                              if(Sesion.permisos > 0 && publicaciones[i]['denuncias'] != null)...[

                                Text("Denuncias: ${publicaciones[i]['denuncias']}",style: TextStyle(fontSize: 17),),
                            ],








                              Divider(color: Colors.black45,),
                              SizedBox(height: 20,)
                            ]

                          ],)
                        ,),


                      
                      if(MediaQuery.of(context).size.width > 1000 && kIsWeb)...[

                        Expanded(child:


                            Container(
                              padding: EdgeInsets.only(top: 100),
                              child: Column(children: [
                                Image.asset("assets/images/logo.png",width: 200,height: 200,),
                                Text("CONTACTO:\nRafael Guzmán Valverde\n rafagval@correo.ugr.es\n rafagval@gmail.com")

            ],),)


                         )


                          /*Expanded(child:

                          Center(child: Image.asset("assets/images/logo.png",width: 200,height: 200,),)

                          )*/
                        
                      ]
                      
                      
                      
                    ],));


              }
              else if(snapshot.data is List && (snapshot.data as List).isEmpty)
                {
                  return new Center(child:Text("Publica algo o sigue a alguien para ver nuevas publicaciones aquí",style: TextStyle(fontSize: 20),textAlign:TextAlign.center,));
                }
              else

                {
                  return new Center(child:CircularProgressIndicator());
                }
            }
      ),
          onRefresh: () async {
            await _pedirMuro(controladorStream);
          });


  }




  @override
  void initState() {
    // TODO: implement initState

    print("PAGINA DE HOME");

    Sesion.nombrePagina = "home";
    Sesion.inicializarSocket(Sesion.test?Sesion.servidorHttp:Sesion.servidor);
    Sesion.paginaActual = this;



    super.initState();
    //_pedirFotos(widget.correo);
    //_pedirAsinc();
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    Widget selected = Center(child: Text("ERROR AL GENERAR PÁGINA"),);
    if(_selectedIndex == 0 ){
      print("cambio a principal");
      selected = home();

    }
    if(_selectedIndex == 1 )
      {
        print("cambio a buscador");
        selected = buscador();
      }

    if(_selectedIndex == 2 && Sesion.permisos == 0)
    {
      print("cambio a conocer");
      selected = conocer();
    }

    if(_selectedIndex == 3 && Sesion.permisos == 0)
      {
        print("cambio a perfil");
        selected = perfil(Sesion.usuario);
      }

    if(_selectedIndex == 4 && Sesion.permisos == 0)
      {
        print("cambio chats");
        selected = listaChat();
      }

    if(_selectedIndex == 5 || (Sesion.permisos != 0 && _selectedIndex == 2))
      {
        print("cambio a ajustes");
        selected = ajustes(context);

      }

    return
      Scaffold(
        key: Key("homeScaffold"),

        body:
        SafeArea(

            child:
                kIsWeb?
                Row(
                  children: [
                    NavigationRail(destinations: [


                      NavigationRailDestination(
                        icon: Icon(Icons.home),
                        label: Text('Principal'),
                        ),

                      NavigationRailDestination(
                        icon:Icon(Icons.search),
                        label: Text('Buscador'),
                      ),

                      if(Sesion.permisos == 0)...[
                        NavigationRailDestination(
                          icon: Icon(Icons.people),
                          label: Text('Conocer'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.person),
                          label: Text('Perfil'),
                        ),
                        NavigationRailDestination(
                            icon:
                            StreamBuilder(
                                stream: Sesion.streamMensajes.stream,
                                builder: (context,snapshot){
                                  return Badge(child:Icon(Icons.chat_bubble),label: Text(Sesion.nMensajes.toString()),isLabelVisible: Sesion.nMensajes != 0,);
                                }
                            ),
                            label:  Text('Mensajes')
                        ),

                      ],

                      NavigationRailDestination(
                        icon: Icon(Icons.settings),
                        label: Text('Ajustes'),
                      ),

                    ], selectedIndex: _selectedIndex,
                    onDestinationSelected: _onItemTapped,),
                    Expanded(child: selected)


                  ],

                ):
        selected
        ),

        bottomNavigationBar: !kIsWeb? BottomNavigationBar(



          selectedItemColor: paletaRoja.shade50,
          items:  <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              tooltip: "home",
              icon: Icon(Icons.home),
              label: 'Principal',
              backgroundColor: paleta[300],
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Buscador',
              backgroundColor: paleta[300],
            ),

            if(Sesion.permisos == 0)...[
              BottomNavigationBarItem(
                icon: Icon(Icons.people),
                label: 'Conocer',
                backgroundColor: paleta[300],
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Perfil',
                backgroundColor: paleta[300],
              ),
              BottomNavigationBarItem(
                tooltip: "chats",
                icon:

                StreamBuilder(
                    stream: Sesion.streamMensajes.stream,
                    builder: (context,snapshot){
                      print("nueva ESCUCHA");
                      return Badge(child:Icon(Icons.chat_bubble),label: Text(Sesion.nMensajes.toString()),isLabelVisible: Sesion.nMensajes != 0,);
                    }
                ),
                label: 'Mensajes',
                backgroundColor: paleta[300],
              ),
            ],

            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              tooltip: 'ajustes',
              label: 'Ajustes',
              backgroundColor: paleta[300],
            ),
          ],
          currentIndex: _selectedIndex,
          //selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
        ):null,

      ) ;

  }


  _onItemTapped(int select) async
  {

          if((kIsWeb && select != 1 ) || !kIsWeb)
            {
              _selectedIndex = select;
            }
          else if(select ==1 && kIsWeb)
            {
                showDialog(context: context, builder: (context){

                  return Dialog(
                    child: Container(child: buscador(),width: MediaQuery.of(context).size.width * 2 / 3, height: MediaQuery.of(context).size.width * 1/3,),
                  );

                });
            }


          if(_selectedIndex == 4)
            {
              Sesion.nMensajes = 0;
              Sesion.streamMensajes.add("");
            }

          setState(() {

          });
          /*
            if(_selectedIndex == 0)
              {
                _pedirMuro();
              }

           */

      /*
      print(_selectedIndex);


        setState(() {

        });*/
  }


  _pedirMuro(controlador) async
  {
    var body = {"usuario": Sesion.usuario, "permisos": Sesion.permisos.toString()};
    var response = await http.post(
        Uri.parse("${Sesion.servidor}/API/ultimas"),
        body: body,
        headers: {"auth" : Sesion.auth}
    );

    //print(response.body);
    controlador.add(jsonDecode(response.body));
    //return jsonDecode(response.body);
  }

   buscador(){
    modoBusqueda modo = modoBusqueda.perfiles;
    List lista = [];

    String DropdownValue = "Todo";
    TextEditingController controlador = TextEditingController();
    StreamController controladorStream = StreamController();
    var tipo = "perfil";
    var resultado = [];
    var valor = "";


    return StreamBuilder(
        initialData: "",
        stream: controladorStream.stream,
        builder: (BuildContext context,snapshot){

          if(snapshot.hasData)
          {
            return
              SingleChildScrollView(child:
                  Container(

                    alignment: Alignment.topCenter,
                    child:
                    Column(
                      children: [

                        Container(
                          margin: EdgeInsets.only(left: 10,right: 10),
                          child:
                        TextField(
                          style: TextStyle(fontSize: 20.0),
                          controller: controlador,onChanged: (n) async {

                          //print("enviando: " + n)
                          valor = n;
                          var res = await busqueda(patron: valor,categoria: DropdownValue,tipoAnterior : tipo,modo : modo);

                          tipo = res[0];
                          resultado = res[1];
                          controladorStream.add("");

                        },),
                        ),


                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              key: Key("iconoPerfiles"),
                                onPressed: () async {
                              modo = modoBusqueda.perfiles;
                              var res = await busqueda(patron: valor,categoria: DropdownValue,tipoAnterior : tipo,modo : modo);
                              tipo = res[0];
                              resultado = res[1];
                              controladorStream.add("");
                            }, icon: Icon(modo == modoBusqueda.perfiles?Icons.person_rounded:Icons.person_outline_outlined)),

                            IconButton(
                              key: Key("iconoProductos"),
                                onPressed: () async {
                              lista = await _encontrarCategorias();
                              lista.add("Todo");
                              modo = modoBusqueda.productos;
                              var res = await busqueda(patron: valor,categoria: DropdownValue,tipoAnterior : tipo,modo : modo);
                              tipo = res[0];
                              resultado = res[1];
                              controladorStream.add("");
                            }, icon: Icon(modo == modoBusqueda.productos?Icons.shopping_basket:Icons.shopping_basket_outlined)),

                          ],),

                        if(modo == modoBusqueda.productos)...[
                          DropdownButton(
                            key: Key("DespliegueCategorias"),
                              value: DropdownValue,
                              items: lista.map<DropdownMenuItem<String>>(
                                      (e){
                                    return DropdownMenuItem<String>(
                                        value: e,
                                        child: Text(e));
                                  }).toList(),
                              onChanged: (item) async {

                                DropdownValue = item!;
                                var res = await busqueda(patron: valor,categoria: DropdownValue,tipoAnterior : tipo,modo : modo);
                                tipo = res[0];
                                resultado = res[1];
                                controladorStream.add("");

                              }),
                        ],


                        if(tipo == "perfil")...[
                          for(int i = 0; i < resultado.length; i++)...[

                            ElevatedButton(onPressed: (){

                              //Navigator.push(con, MaterialPageRoute(builder: (context) => Perfil(correo: resultado[i]['correo'])));
                              //print('/${resultado[i]['correo'].toString()}');
                              context.push('/${resultado[i]['nombre'].toString()}');
                              //context.push('/holita');

                            }, child:
                            Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        CircleAvatar(
                                          backgroundImage: NetworkImage("${Sesion.servidor}/API/pedirFotoperfil/${resultado[i]['nombre']}"),
                                          maxRadius: 30,
                                        ),
                                        SizedBox(width: 16,),
                                        Expanded(
                                          child: Container(
                                            color: Colors.transparent,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(resultado[i]['nombre'], style: TextStyle(fontSize: 16),),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ]
                            ),



                            ),

                            SizedBox(height: 10,)




                          ]
                        ]
                        else if(tipo=="producto")...
                        [

                            SizedBox(height: 10,),

                            Container(
                              constraints: BoxConstraints(maxWidth: 500),
                              child:
                              GridView.count(

                                crossAxisCount: 2,
                                shrinkWrap: true,
                                mainAxisSpacing: 10.0,
                                crossAxisSpacing: 10.0,

                                children: [

                                  for(int i = 0; i < resultado.length; i++)...[

                                    GestureDetector(onTap: (){

                                      //Navigator.push(con, MaterialPageRoute(builder: (context) => Perfil(correo: resultado[i]['correo'])));
                                      //print('/${resultado[i]['correo'].toString()}');
                                      context.push('/${resultado[i]['usuario'].toString()}/${resultado[i]['id']}');
                                      //context.push('/holita');

                                    }, child:
                                    Container(
                                      
                                      decoration: BoxDecoration(

                                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                        color: paletaAmarilla.shade900,

                                      ),


                                      child:

                                      Column(
                                          children: <Widget>[

                                            SizedBox(height: 10,),

                                            Container(
                                              width: kIsWeb?200:130,
                                              height: kIsWeb?200:130,
                                              child:
                                              Image.network("${Sesion.servidor}/API/imagen/${resultado[i]['usuario']}/${resultado[i]['id']}",
                                                fit: BoxFit.fill,

                                              ),
                                            ),

                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text("${resultado[i]['descripcion']}"),
                                                Icon(Icons.sell),
                                                Text("${resultado[i]['precio']} €")
                                              ],)


                                          ]
                                      ),
                                    )




                                    )


                                  ]


                                ],)
                              ,
                            )



                        ]

                      ],)
                    ,
                  )
              );
          }
          else
          {
            return Center(child: new CircularProgressIndicator(),);
          }

        });
  }

 _encontrarCategorias() async
  {
    var url = "${Sesion.servidor}/API/categorias";
    var request = await http.get(Uri.parse(url),);

    List nuevaLista = jsonDecode(request.body);

    return nuevaLista.map<String>((e) => e['nombre']).toList();

  }


}


Future<List> busqueda({required String patron, String? categoria , String? tipoAnterior,required modoBusqueda modo}) async {

  var tipo = tipoAnterior;
  var arrayRespuesta = [];

  if(patron.isNotEmpty || modo == modoBusqueda.productos)
  {
    var busqueda = patron;
    if(patron.isEmpty)
    {
      busqueda = "\$";
    }
    //print("buscando " + n);
    var body = {"categoria" : categoria.toString()};
    var response = await http.post(
        Uri.parse("${Sesion.servidor}/API/buscar/${modo.name}/${busqueda}"),
        body: body
    );

    var res = jsonDecode(response.body);
    tipo = res['tipo'];
    arrayRespuesta = res['res'];

  }

  return [tipo,arrayRespuesta];
}