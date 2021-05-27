import 'dart:async';

import 'package:flutter/material.dart';

import 'package:seracker/models/eczaneListe.dart';
import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;




class SehirEczane extends StatefulWidget {
  final int plaka;
  const SehirEczane({Key key,this.plaka}):super(key: key);
  @override
  _SehirEczaneState createState() => _SehirEczaneState();
}

class _SehirEczaneState extends State<SehirEczane> {

  String enlem="36.52528438399691";
  String boylam="32.081614360326796";
  int eczaneSayisi=0;
 
  bool yukleniyor=true;
  List<Pharmacy> pharmacy=[];
  Completer<GoogleMapController> harita=Completer<GoogleMapController>();
  Map <MarkerId,Marker> isaretler= <MarkerId,Marker>{};
GoogleMapController controller;

  Uri url =Uri.parse("https://eczaneleri.net/api/eczane-api?demo=1&type=json");
      
  EczaneListe eczane;
  Future<EczaneListe> veri;

  Future<EczaneListe> eczaneleriGetir() async {
    var response = await http.get(url);
    var decodedJson = json.decode(response.body);


    return EczaneListe.fromJson(decodedJson);

  }

 

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
    eczane=await eczaneleriGetir();
      eczane.data[widget.plaka-1].area.forEach((element){
        pharmacy.addAll(element.pharmacy);
      });
      setState(() {
        yukleniyor=false;
      });
    });




  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("eczane"),),
      body: yukleniyor ? Center(child: CircularProgressIndicator()) : Column (

        mainAxisAlignment: MainAxisAlignment.start,

        children: [
          Container(
            height: 300,
            width:double.maxFinite ,
            child: GoogleMap(
              mapType: MapType.normal,
              markers: Set<Marker>.of(isaretler.values),
              initialCameraPosition: CameraPosition(
                target: LatLng(double.parse(enlem), double.parse(boylam)),
                zoom: 17,
              ),

              onMapCreated:mapCreated,


            ),
          ),
          Expanded(
              
              child: ListView.builder(
                itemCount:pharmacy.length ,

                itemBuilder: (BuildContext context, int index) {
                  return  Card(

                    child: Padding(
                      padding: const EdgeInsets.all(2.0),

                      child: ListTile(

                        onTap: (){
                            setState(() {
                              enlem=pharmacy[index].maps.substring(0,9);
                        boylam=pharmacy[index].maps.substring(10);
                        moveCamera(enlem, boylam);
                            });


                        },

                        title: Text(pharmacy[index].name),

                        subtitle: Text(
                            pharmacy[index].address

                        ),
                        trailing: Text(eczane.data[widget.plaka-1].cityName),
                      ),
                    ),
                    elevation: 6,
                  );
                },




              )
          ), ],),
      

    );
  }


moveCamera(String enlem,String boylam) {
   final MarkerId isaredId=MarkerId("Eczane");
                final Marker isaret =Marker(
                  markerId: isaredId,
                  position: LatLng(double.parse(enlem), double.parse(boylam)),
                  infoWindow: InfoWindow(
                      title:"En Yakın Hastane",
                      snippet: "Hastaneler",
                      onTap: (){

                      }
                  ),

                );
                setState(() {
                 
                isaretler[isaredId]=isaret;
                
                });
    if (controller != null) {
      controller
          .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(double.parse(enlem), double.parse(boylam)),
       zoom: 17,
      )));
    }
  }

void mapCreated(cont) {
  final MarkerId isaredId=MarkerId("Eczane");
                final Marker isaret =Marker(
                  markerId: isaredId,
                  position: LatLng(double.parse(enlem), double.parse(boylam)),
                  infoWindow: InfoWindow(
                      title:"En Yakın Hastane",
                      snippet: "Hastaneler",
                      onTap: (){

                      }
                  ),

                );

                setState(() {
                  harita.complete(controller);
                isaretler[isaredId]=isaret;
                controller = cont;
                });
    

  }
}


