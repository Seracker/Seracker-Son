import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seracker/models/Users.dart';
import 'package:seracker/models/izin_db.dart';
import 'package:seracker/models/kisisel_bilgilerdb.dart';
import 'package:seracker/viewmodel/user_model.dart';

class Izin extends StatefulWidget {
  final String gelenID;
  const Izin({Key key,this.gelenID}):super(key: key);
  @override
  _IzinState createState() => _IzinState();
}

class _IzinState extends State<Izin> {
  int secilenTur = 0;
  bool yukleniyor = true;
  bool adim,nabiz,hastaliklar,switchState=false,switchState2=false,switchState3=false;
  String email;
  Users _users;
  IzinDb _izin;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      await izinSorgu(widget.gelenID);
      //await gelenIDAra(widget.gelenID);
      await veriGetirIP();
      await veriGetirIPI(widget.gelenID);
      setState(() {
        yukleniyor =false;
      });
    });

  }
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        accentColor: Colors.white,
        primaryColor: Colors.green,
        hintColor: Colors.teal,
      ),
      child: Scaffold(
        backgroundColor: Colors.grey.shade800,
        appBar: AppBar(
          centerTitle: true,
          title: SizedBox(
            child: Image.asset(
              "img/seracker.png",
              scale: 10,
            ),
          ),
          backgroundColor: Colors.grey.shade900,
        ),
        body: yukleniyor ? Center(child: CircularProgressIndicator(),)
            : Center(
          child: ListView(
            children: <Widget>[
              Center(
                heightFactor: 3,
                  child: Text("İZİNLER",style: TextStyle(fontSize: 30),)),
              Container(
                padding: EdgeInsets.all(10),
                height: 90,
                child: Card(
                  color: Colors.grey.shade500,
                  child: SwitchListTile(
                    title:  Text("Adım",style: TextStyle(fontSize: 21,color: Colors.black),),
                    value: _izin == null?false:_izin.adim,
                    onChanged: (deger) async{
                      setState(
                            () {
                          _izin.adim=deger;
                        },
                      );
                    },
                    activeColor: Colors.green,
                  ),
                ),
              ),
              SizedBox(height: 30,),
              Container(
                padding: EdgeInsets.all(10),
                height: 90,
                child: Card(
                  color: Colors.grey.shade500,
                  child: SwitchListTile(
                    title:  Text("Nabız",style: TextStyle(fontSize: 21,color: Colors.black),),
                    value: _izin == null?false:_izin.nabiz,
                    onChanged: (deger) async{
                      setState(
                            () {
                          _izin.nabiz=deger;
                        },
                      );
                    },
                    activeColor: Colors.green,
                  ),
                ),
              ),
              SizedBox(height: 30,),
              Container(
                padding: EdgeInsets.all(10),
                height: 90,
                child: Card(
                  color: Colors.grey.shade500,
                  child: SwitchListTile(
                    title:  Text("Hastalıklar",style: TextStyle(fontSize: 21,color: Colors.black),),
                    value: _izin == null?false:_izin.hastaliklar,
                    onChanged: (deger) {
                      setState(() {
                              _izin.hastaliklar=deger;
                        },
                      );
                    },
                    activeColor: Colors.green,
                  ),
                ),
              ),
              SizedBox(height: 30,),
              Container(
                padding: EdgeInsets.all(10),
                height: 90,
                child: Card(
                  color: Colors.grey.shade500,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("   Takipçi Türü",style: TextStyle(fontSize: 21,color: Colors.black),),
                      DropdownButton<int>(
                        items: takipEdilenKisiTuru(),
                        value: _izin == null?0:_izin.secilenTur,
                        onChanged: (secilenDeger) {
                          setState(() {
                            _izin.secilenTur = secilenDeger;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Center(
                child: ElevatedButton(
                  child: Text("Degişiklikleri Onayla"),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white12),
                    padding: MaterialStateProperty.all(EdgeInsets.all(10)),
                    textStyle: MaterialStateProperty.all(TextStyle(fontSize: 16)),),
                  onPressed: () {
                    veriGuncelleIP();
                    Navigator.of(context).pop();
                  },
                ),
              ),
              //Text("${widget.gelenID}"),

            ],
          ),
        ),
      ),
    );
  }
  List<DropdownMenuItem<int>> takipEdilenKisiTuru() {
    List<DropdownMenuItem<int>> turler = [];

    turler.add(DropdownMenuItem<int>(
      child: Text(
        "Aile",
        style: TextStyle(fontSize: 20),
      ),
      value: 0,
    ));
    turler.add(DropdownMenuItem<int>(
      child: Text("Arkadaş", style: TextStyle(fontSize: 20)),
      value: 1,
    ));
    turler.add(DropdownMenuItem<int>(
      child: Text(
        "Akraba",
        style: TextStyle(fontSize: 20),
      ),
      value: 2,
    ));

    return turler;
  }
  Future<void> veriGetirIP() async{
    final _userModel = Provider.of<UserModel>(context,listen: false);
    setState(() {
      _users = _userModel.users;
    });

  }
  Future<void> veriGetirIPI(String gelenID) async{
    final _userModel = Provider.of<UserModel>(context,listen: false);
    _userModel.readIzin(_userModel.users.userID,gelenID).then((value) {
      setState(() {
        _izin=value;
      });
    });
  }
  Future<void> veriGuncelleIP() async{
    final _userModel = Provider.of<UserModel>(context,listen: false);
    setState(() {
      _userModel.izin=_izin;
    });
    print("izin = $_izin");
    await _userModel.updateIzin(_izin,_users,widget.gelenID);
  }
  Future<void> izinSorgu(String gelenID)async{
    final _userModel = Provider.of<UserModel>(context,listen: false);
    var db = await FirebaseFirestore.instance
        .collection("Users").doc(_userModel.users.userID).collection("takipci").doc(gelenID).get();
    db.data().forEach((key, value) {
      izinAdifromMap(db.data());
    });
    print("izin sorgu $adim $nabiz $hastaliklar");

  }
  izinAdifromMap(Map<String,dynamic> map){
    setState(() {
      adim = map["adim"];
      nabiz = map["nabiz"];
      hastaliklar = map["hastaliklar"];
    });
    print("çalıştı");
  }
}