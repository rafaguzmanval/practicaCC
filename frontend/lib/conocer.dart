


import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:instafoto/main.dart';
import 'Sesion.dart';


var contactos = null;

Widget conocer()
{

  StreamController controladorStream = new StreamController();
  String tipoRelacionBuscada = "Relacion que buscas";
  List<String> tiposRelaciones = ["Relacion que buscas","Amistad","Cita","Trabajo"];

  String sexo = "Sexo";
  List<String> ListaSexos = ["Sexo","Hombre","Mujer"];

  String interesSexual = "Te interesan";
  List<String> interesesSexuales = ["Te interesan","Hombres","Mujeres","Ambos"];

  double edadMinima = 18;
  double edadMaxima = 120;

  var icontactos = 0;
  var botonesVisibles = true;

  TextEditingController edadController = new TextEditingController();
  TextEditingController descriptorController = new TextEditingController();

  _cargarContactos(controladorStream);

  return Scaffold(
      appBar: AppBar(

        flexibleSpace: Container(decoration: BoxDecoration(
          gradient: LinearGradient(colors: [paletaAmarilla.shade50,paletaRoja.shade900],begin: Alignment.topLeft, end: Alignment.bottomRight,),
        ),),

        backgroundColor: paletaAmarilla.shade600,

        automaticallyImplyLeading: false,actions: [IconButton(onPressed: (){

        controladorStream.add("NO REGISTRADO");

      }, icon: Icon(Icons.settings))],),
body:StreamBuilder(
      stream: controladorStream.stream,
      builder: (context,snapshot){



          if(snapshot.data=="NO REGISTRADO")
            {
              return

              Center(child:
                Container(

                    width: MediaQuery.of(context).size.width / 3,
                    child: Column(
                children: [
              Text("¡Conoce a personas cercanas a tí con tus gustos!")
              ,

              DropdownButton(
                  value: sexo,
                  items: ListaSexos.map<DropdownMenuItem<String>>((String e) {
                    return DropdownMenuItem<String>(
                      value: e,
                      child: Text(e),);
                  }).toList(),
                  onChanged: (item) {
                    sexo = item!;
                    controladorStream.add("NO REGISTRADO");
                  }),


              TextField(

                controller: edadController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Edad'
                ),
              ),

              TextField(

                controller: descriptorController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '¡Describe como eres!',
                ),

              ),
              DropdownButton(
                  value: tipoRelacionBuscada,
                  items: tiposRelaciones.map<DropdownMenuItem<String>>((
                      String e) {
                    return DropdownMenuItem<String>(
                      value: e,
                      child: Text(e),);
                  }).toList(),
                  onChanged: (item) {
                    tipoRelacionBuscada = item!;
                    controladorStream.add("NO REGISTRADO");
                  }),

              DropdownButton(
                  value: interesSexual,
                  items: interesesSexuales.map<DropdownMenuItem<String>>((
                      String e) {
                    return DropdownMenuItem<String>(
                      value: e,
                      child: Text(e),);
                  }).toList(),
                  onChanged: (item) {
                    interesSexual = item!;
                    controladorStream.add("NO REGISTRADO");
                  }),

              RangeSlider(
                  min: 18,
                  max: 120,
                  divisions: 120 - 18,
                  labels: RangeLabels(
                    edadMinima.round().toString(),
                    edadMaxima.round().toString(),
                  ),
                  values: RangeValues(edadMinima, edadMaxima),
                  onChanged: (values) {
                    edadMinima = values.start;
                    edadMaxima = values.end;
                    controladorStream.add("NO REGISTRADO");
                  }),


              ElevatedButton(onPressed: () async {
                if (sexo != "Sexo" &&
                    tipoRelacionBuscada != "Relacion que buscas" &&
                    interesSexual != "Te interesan") {
                  var body = {
                    "usuario": Sesion.usuario,
                    "sexo": sexo,
                    "descripcion": descriptorController.text,
                    "edad": edadController.text,
                    "latitud": "0",
                    "longitud": "0",
                    "relacion": tipoRelacionBuscada,
                    "interes": interesSexual,
                    "edadMinima": edadMinima.round().toString(),
                    "edadMaxima": edadMaxima.round().toString(),
                    "distancia": "200"
                  };
                  print(body.toString());


                  var response = await http.post(
                      Uri.parse("${Sesion.servidor}/API/registrarPerfilCitas"),
                      body: body
                  );

                  if(response.body == 'ok')
                    {
                      _cargarContactos(controladorStream);
                    }
                }
              }, child: Text("Empezar a buscar"))


              /*
              TextField(

                controller: precioController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Precio',
                ),

              ),*/

              ],
              )),);

            }
          else if(contactos is List)
            {

              botonesVisibles= (icontactos < contactos.length);
              if(contactos.isNotEmpty)
                {
                  return Stack(children: [


                    Visibility(
                        visible: botonesVisibles,
                        child:
                        Container(
                          alignment: Alignment(0.9,0.9),
                          child:
                          FloatingActionButton(
                            onPressed: (){
                              icontactos ++;
                              controladorStream.add("");

                            },child: Icon( Icons.thumb_up),),
                        )),


                    Visibility(
                        visible: botonesVisibles,
                        child:
                        Container(
                          alignment: Alignment(-0.9,0.9),
                          child:    FloatingActionButton(
                          backgroundColor: paletaRoja.shade50,

                            onPressed: (){
                            icontactos++;
                            controladorStream.add("");
                          },child: Icon( Icons.thumb_down,),),
                        )),

                    if(icontactos < contactos.length)...[
                      Center(child:
                      Column(
                        children: [

                          CircleAvatar(backgroundImage: NetworkImage("${Sesion
                              .servidor}/API/pedirFotoperfil/${contactos[icontactos]['usuario']}"), radius: 100,),
                          Text(contactos[icontactos]['usuario'],style: TextStyle(fontSize: 20),),
                          Text(contactos[icontactos]['sexo'],style: TextStyle(fontSize: 13),),

                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(width: 1),
                                borderRadius: BorderRadius.circular(13)
                            ),
                            child: Text("\n " + contactos[icontactos]['descripcion'].toString() + " \n"),)

                        ],)),

                    ]else...[
                      Center(
                        child: Text("No hay más contactos que encajen con tus preferencias"),
                      )
                    ]





                  ],);
                }
              else{
                return   Center(
                  child: Text("No se encuentra a nadie que concuerde con tus preferencias"),
                );
              }




            }
          else
            {
              return Center(child: new CircularProgressIndicator(),);
            }



  }));
}

_cargarContactos(StreamController controlador) async {

  var response = await http.get(
  Uri.parse("${Sesion.servidor}/API/encontrarContactos/"+ Sesion.usuario),
  );

  if(response.body == "NO REGISTRADO")
    {
      controlador.add("NO REGISTRADO");
    }
  else

    {
      var respuestaJson = jsonDecode(response.body);
      if(respuestaJson is List)
        contactos = respuestaJson;

      controlador.add(response.body);
    }

  

}

