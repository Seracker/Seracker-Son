import 'package:flutter/material.dart';

class Ayarlar extends StatefulWidget {
  @override
  _AyarlarState createState() => _AyarlarState();
}

class _AyarlarState extends State<Ayarlar> {
  bool bluetoothDeger=false;
  bool konumDeger=false;
  int secilenTur = 0;
  double sesDeger=0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ayarlar"),
      ),
      body: Column(
        //mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
        /*  Column(
            children: [
              Center(
               child: Image.asset(
        "img/user.png",
        height: 100,
        width: 100,
      ),),
              Text("Recep kılıç",style: TextStyle(fontSize: 25),)
            ],
          ),
          SizedBox(height: 20,),
          Text("Profil",style: TextStyle(fontSize: 20),),
          Column(
            children: [
              ExpansionTile(title: Text("Kişisel Bilgiler"),children: [
                Container(
                  color: Colors.blue,
                  height: 50,
                )
              ],)
            ],
          ),
          Column(
            children: [
              ExpansionTile(title: Text("Sağlık Bilgileri"),children: [
                Container(
                  color: Colors.blue,
                  height: 50,
                )
              ],)
            ],
          ),
          Column(
            children: [
              ExpansionTile(title: Text("Yakınlarım"),children: [
                Container(
                  color: Colors.blue,
                  height: 50,
                )
              ],)
            ],
          ),*/
          //Text("Gizlilik",style: TextStyle(fontSize: 20),),
          Container(

              child :
              SwitchListTile(value: konumDeger, onChanged: (deger){
                setState(() {
                  konumDeger=deger;

                });
              },
                title: Text("Konum"),
              )

          ),
          Container(

            child :
              SwitchListTile(value: bluetoothDeger, onChanged: (deger){
                setState(() {
                  bluetoothDeger=deger;

                });
              },
                title: Text("bluetooth"),
              )

          ),
         /* Column(
            children: [
              ExpansionTile(title: Text("Hesap Ayarları"),children: [
                Container(
                  color: Colors.blue,
                  height: 50,
                )
              ],)
            ],
          ),*/

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("    Yazı Büyüklüğü",style: TextStyle(fontSize: 15),),
              DropdownButton<int>(
                items: takipEdilenKisiTuru(),
                value: secilenTur,
                onChanged: (secilenDeger) {
                  setState(() {
                    secilenTur = secilenDeger;
                  });
                },
              ),
            ],
          ),

          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("Ses Seviyesi",textAlign: TextAlign.start,style: TextStyle(fontSize: 15),),
              SizedBox(width: 25,),
              Slider(value: sesDeger, onChanged: (deger){
                setState(() {
                  sesDeger=deger;
                });
              },
                min:0,max: 100,divisions: 20,label: sesDeger.toInt().toString(),
              )
            ],
          ),





        ],
      ),
    );
  }
  List<DropdownMenuItem<int>> takipEdilenKisiTuru() {
    List<DropdownMenuItem<int>> turler = [];

    turler.add(DropdownMenuItem<int>(
      child: Text(
        "Küçük",
        style: TextStyle(fontSize: 14),
      ),
      value: 0,
    ));
    turler.add(DropdownMenuItem<int>(
      child: Text("Orta", style: TextStyle(fontSize: 17)),
      value: 1,
    ));
    turler.add(DropdownMenuItem<int>(
      child: Text("Büyük", style: TextStyle(fontSize: 21)),
      value: 2,
    ));
    turler.add(DropdownMenuItem<int>(
      child: Text("En Büyük", style: TextStyle(fontSize: 25)),
      value: 3,
    ));
    return turler;
  }
}
