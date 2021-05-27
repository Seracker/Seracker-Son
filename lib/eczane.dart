import 'package:flutter/material.dart';
import 'package:seracker/sehirEczane.dart';

import 'dart:convert';
import 'models/Sehir.dart';






class Eczane extends StatefulWidget {
  @override
  _EczaneState createState() => _EczaneState();
}

class _EczaneState extends State<Eczane> {

  List<Sehir> tumSehirler;
  var sehirler=[];
  int seciliSehir;
 
  
  
@override
  void initState() {
    // TODO: implement initState
    super.initState();
   
    tumSehirler=[];
    
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
      child:FutureBuilder(
            future: veriKaynaginiOku(),
            
            builder: (context, sonuc) {

            if(sonuc.hasData){
              tumSehirler = sonuc.data;
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  padding: EdgeInsets.only(left:16,right:16),

                  decoration: BoxDecoration(
                    border: Border.all(color:Colors.green,width:1),
                    borderRadius: BorderRadius.circular(15)
                  ),
                  child: DropdownButton( 
                hint: Text("şehir seciniz"),
                
                iconSize: 35,
                isExpanded: true,
                underline: SizedBox(),
                style: TextStyle(color: Colors.white,
              fontSize: 22),
                onChanged:(secilen){
                  setState(() {
                    seciliSehir=secilen;
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SehirEczane(plaka: seciliSehir,)));
                  });
                  
                  
              },
              value: seciliSehir,
              items: tumSehirler.map((e) {
                
                return DropdownMenuItem(
                  value: e.plaka_no,
                
                  child: Text(e.sehir_adi),
                  
                );
                
              }).toList()
              ),),
              );
            }else{

              return Center(child: CircularProgressIndicator(),);
            }



            }),
    ),
    );
  }
  
  
  
    

  Future<List<Sehir>> veriKaynaginiOku() async {
   

    final gelenJson = await DefaultAssetBundle.of(context)
        .loadString("assets/data/sehir.json");
        final responseData = jsonDecode(gelenJson) as List;
        List<Sehir> sehirListesi=[];
    for(int i=0;i<81;i++){
  sehirListesi.add(Sehir.fromJsonMap(responseData[i]));
  
    }

  //  List<Sehir> sehirListesi = (json.decode(gelenJson) as List).map((mapYapisi) => Sehir.fromJsonMap(mapYapisi)).toList();
  // var rcp= json.decode(gelenJson) as Map<String,dynamic>;

    //print(rcp);
    

    return sehirListesi;
   
  }
}

      
    
  
