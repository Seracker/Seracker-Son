import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seracker/models/Users.dart';
import 'package:seracker/models/izin_db.dart';
import 'package:seracker/viewmodel/user_model.dart';

class Lider extends StatefulWidget {
  @override
  _LiderState createState() => _LiderState();
}

class _LiderState extends State<Lider> {
  bool yukleniyor = true;
  Users _users;
  IzinDb _izin;
  bool aIzin;
  String sonAdim;
  String c;
  List<String> a=[];
  List<String> b=[];
  List<String> lsa=[];
  List<String> lSA=[];
  List<bool> adimIzin=[];
  List<String> lad=[];
  List<String> lAD=[];
  List<String> lsad = [];
  List<String> lSAD = [];
  List<String> lid = [];


  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      await veriGetirL();
      await takipEdilenIDSorgu();
      await adimIzinSorgu();
      await siralamaAdim();
      await izinSorgu();
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
        body: ListView(
          children: <Widget>[
            SizedBox(height: 20,),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Lider Tablosu  ",style: TextStyle(fontSize: 24,color: Colors.teal),),
                  SizedBox(
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.directions_run_rounded),
                        SizedBox(width: 20,),
                        Icon(Icons.flag_outlined),
                        Text("---"),
                        Icon(Icons.flag_outlined),
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 20,),
            ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: lAD.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(10, 2, 2, 2),
                child: Container(
                  height: 60,
                  width: double.infinity,
                  child: Card(
                    elevation: 10,
                    color: Colors.white24,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 3, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            child: Text(
                              " "+b[index],
                              style: TextStyle(fontSize: 22, color: Colors.black),
                              textAlign: TextAlign.left,
                            ),
                            width: 247,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              child:
                              Icon(
                                Icons.star_rate_rounded,
                                color: index==0?Colors.amber.shade500:Colors.white70,),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
          ),
        ],
        ),
      ),
    );
  }

  Future<void> veriGetirL() async{
    final _userModel = Provider.of<UserModel>(context,listen: false);
    setState(() {
      _users = _userModel.users;
    });
  }
  Future<void> takipEdilenIDSorgu() async {
    final _userModel = Provider.of<UserModel>(context,listen: false);
    var db= await FirebaseFirestore.instance
        .collection("Users").doc(_userModel.users.userID).collection("takipEdilen").get();
    db.docs.forEach((element) {
      idfromMap(element.data());
    });
    print("id Sorgu");
  }
  idfromMap(Map<String,dynamic> map){
    setState(() {
      lid.add(map["takipID"]);
      lad.add(map["name"]);
      lsad.add(map["surname"]);
    });
    print(lid);
  }
  Future<void> adimIzinSorgu() async {
    final _userModel = Provider.of<UserModel>(context,listen: false);
    for(int i=0;i<lid.length;i++){
      print("çalıştı");
      print(_userModel.users.userID);
      var db= await FirebaseFirestore.instance
          .collection("Users").doc(lid[i]).collection("takipci").where("userID",isEqualTo: _userModel.users.userID).get();
      db.docs.forEach((element) {
        aIzin=element["adim"];
        adimIzin.add(aIzin);
      });
    }
    print("adım Sorgu");
    print("adim izin $adimIzin");
  }
  Future<void>siralamaAdim()async{
    final _userModel = Provider.of<UserModel>(context,listen: false);
    for(int i=0;i<lid.length;i++){
      var db = await FirebaseFirestore.instance
          .collection("Users").doc(lid[i]).collection("adim").orderBy("adimTarihi").limitToLast(1).get();
      db.docs.forEach((element) {
        sonAdim=element["adim"];
        lsa.add(sonAdim);
      });
    }
    print("adim");
    print(lsa);
  }
  Future<void> izinSorgu() async{
    print(adimIzin);
    print(lad);
    for(int i=0;i<lid.length;i++){
      if(adimIzin[i]==true){
        lAD.add(lad[i]);
        lSAD.add(lsad[i]);
        lSA.add(lsa[i]);
        a.add(lSA[i]+" "+lAD[i]+" "+lSAD[i]);
      }
    }
    a.sort();
    print(a.length);
    print(a);
    int k= a.length;
    for(int j=0;j<k;j++){
      b.add(a.last);
      a.removeLast();
      print(j.toString());
    }
    print("izin sorgu");
    print("$lSA $lAD $lSAD");
    print(a);
    print(b);
  }
}
