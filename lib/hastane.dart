import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


import 'package:seracker/eczane.dart';


class Hastane extends StatefulWidget {

  
  
  @override
  _HastaneState createState() => _HastaneState();
}

class _HastaneState extends State<Hastane> {

  String enlem="36.52528438399691";
  String boylam="32.081614360326796";
  GoogleMapController controller;

  Completer<GoogleMapController> harita=Completer<GoogleMapController>();
      Map <MarkerId,Marker> isaretler= <MarkerId,Marker>{}; 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Haritalar"),
      ),
      body: Column(
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
      Container(
        height: 100,
        child: Eczane(),
      ),
      ],)
    );
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