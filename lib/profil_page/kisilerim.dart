import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seracker/izin_page.dart';
import 'package:seracker/models/Users.dart';
import 'package:seracker/pages/leaderboard.dart';
import 'package:seracker/viewmodel/user_model.dart';

import '../kisiler_page.dart';

class Kisilerim extends StatefulWidget {
  @override
  _KisilerimState createState() => _KisilerimState();
}

class _KisilerimState extends State<Kisilerim> {
  bool yukleniyor=true;
  int i;

  Users _users;
  ///        Takip Edilen
  List<String> takipedilenAileAd=[];
  List<String> takipedilenAileSoyad=[];
  List<String> takipedilenAileID=[];
  List<String> takipedilenArkadasAd=[];
  List<String> takipedilenArkadasSoyad=[];
  List<String> takipedilenArkadasID=[];
  List<String> takipedilenAkrabaAd=[];
  List<String> takipedilenAkrabaSoyad=[];
  List<String> takipedilenAkrabaID=[];

  ///        Takipci
  List<String> takipciAileAd=[];
  List<String> takipciAileSoyad=[];
  List<String> takipciAileID=[];
  List<String> takipciArkadasAd=[];
  List<String> takipciArkadasSoyad=[];
  List<String> takipciArkadasID=[];
  List<String> takipciAkrabaAd=[];
  List<String> takipciAkrabaSoyad=[];
  List<String> takipciAkrabaID=[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();




    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await takipedilenAraAile();
      await takipedilenAraAkraba();
      await takipedilenAraArkadas();
      await takipedilenAileIDSorgu();
      await takipedilenAkrabaIDSorgu();
      await takipedilenArkadasIDSorgu();

      await takipciAraAile();
      await takipciAraAkraba();
      await takipciAraArkadas();
      await takipciAileIDSorgu();
      await takipciArkadasIDSorgu();
      await takipciAkrabaIDSorgu();


      setState(() {
        yukleniyor=false;
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
            child: Row(
              children: [
                Image.asset(
                  "img/seracker.png",
                  scale: 10,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 0, 0, 0),
                  child: IconButton(icon: Icon(Icons.leaderboard_rounded,color: Colors.yellow.shade600),
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>Lider()));
                      }),
                ),
              ],
            ),
          ),
          backgroundColor: Colors.grey.shade900,
        ),
        body: yukleniyor ? Center(child: CircularProgressIndicator(),)
            : ListView(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              child: Center(
                child: Text(
                  "Benim Takip ettiklerim",
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ),
            Card(
              color: Colors.grey.shade700,
              child: ExpansionTile(
                backgroundColor: Colors.grey.shade500,
                title: Text("Aile"),
                subtitle: Text(takipedilenAileAd.length.toString()),
                children: <Widget>[
                  Container(
                    color: Colors.grey.shade700,
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount: takipedilenAileAd.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(10, 2, 2, 2),
                            child: TextButton(
                              style: ButtonStyle(
                                alignment: Alignment.topLeft,
                              ),
                              child: Text(takipedilenAileAd[index] + " " + takipedilenAileSoyad[index],
                                style: TextStyle(fontSize: 16,color: Colors.white),),
                              onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>Yazi(gelenID: takipedilenAileID[index],)));
                              },
                            ),
                          );
                        }),
                  )
                ],
              ),
            ),
            Card(
              color: Colors.grey.shade700,
              child: ExpansionTile(
                backgroundColor: Colors.grey.shade500,
                title: Text("Arkadaş"),
                subtitle: Text(takipedilenArkadasAd.length.toString()),
                children: <Widget>[
                  Container(
                    color: Colors.grey.shade700,
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount: takipedilenArkadasAd.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                              padding: const EdgeInsets.fromLTRB(10, 2, 2, 2),
                              child: TextButton(
                                style: ButtonStyle(
                                  alignment: Alignment.topLeft,
                                ),
                                child: Text(takipedilenArkadasAd[index] + " " + takipedilenArkadasSoyad[index],
                                  style: TextStyle(fontSize: 16,color: Colors.white),),
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => Yazi(gelenID: takipedilenArkadasID[index],),),
                                  );
                                }, //
                          )
                          );
                        }),
                  )
                ],
              ),
            ),
            Card(
              color: Colors.grey.shade700,
              child: ExpansionTile(
                backgroundColor: Colors.grey.shade500,
                title: Text("Akraba"),
                subtitle: Text(takipedilenAkrabaAd.length.toString()),
                children: <Widget>[
                  Container(
                    color: Colors.grey.shade700,
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount: takipedilenAkrabaAd.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(10, 2, 2, 2),
                            child: TextButton(
                              style: ButtonStyle(
                                alignment: Alignment.topLeft,
                              ),
                              child: Text(
                                takipedilenAkrabaAd[index] + " " + takipedilenAkrabaSoyad[index],
                                style: TextStyle(fontSize: 16,color: Colors.white),
                              ),
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => Yazi(gelenID: takipedilenAkrabaID[index],),),
                                );
                              },
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: Center(
                child: Text(
                  "Beni Takip edenler",
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ),
            Card(
              color: Colors.grey.shade700,
              child: ExpansionTile(
                backgroundColor: Colors.grey.shade500,
                title: Text("Aile"),
                subtitle: Text(takipciAileAd.length.toString()),
                children: <Widget>[
                  Container(
                    color: Colors.grey.shade700,
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount: takipciAileAd.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(10, 2, 2, 2),
                              child: TextButton(
                              style: ButtonStyle(
                                alignment: Alignment.topLeft,
                              ),
                              child: Text(
                                takipciAileAd[index] + " " + takipciAileSoyad[index],
                                style: TextStyle(fontSize: 16,color: Colors.white),
                              ),
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => Izin(gelenID: takipciAileID[index],),),
                                );
                              },
                            )
                          );
                        }),
                  )
                ],
              ),
            ),
            Card(
              color: Colors.grey.shade700,
              child: ExpansionTile(
                backgroundColor: Colors.grey.shade500,
                title: Text("Arkadaş"),
                subtitle: Text(takipciArkadasAd.length.toString()),
                children: <Widget>[
                  Container(
                    color: Colors.grey.shade700,
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount: takipciArkadasAd.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(padding: const EdgeInsets.fromLTRB(10, 2, 2, 2),
                            child: TextButton(
                              style: ButtonStyle(
                                alignment: Alignment.topLeft,
                              ),
                              child: Text(
                                takipciArkadasAd[index] + " " + takipciArkadasSoyad[index],
                                style: TextStyle(fontSize: 16,color: Colors.white),
                              ),
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => Izin(gelenID: takipciArkadasID[index],),),
                                );
                              },
                            ),
                          );
                        }),
                  )
                ],
              ),
            ),
            Card(
              color: Colors.grey.shade700,
              child: ExpansionTile(
                backgroundColor: Colors.grey.shade500,
                title: Text("Akraba"),
                subtitle: Text(takipciAkrabaAd.length.toString()),
                children: <Widget>[
                  Container(
                    color: Colors.grey.shade700,
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount: takipciAkrabaAd.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(10, 2, 2, 2),
                            child: TextButton(
                              style: ButtonStyle(
                                alignment: Alignment.topLeft,
                              ),
                              child: Text(
                                takipciAkrabaAd[index] + " " + takipciAkrabaSoyad[index],
                                style: TextStyle(fontSize: 16,color: Colors.white),
                              ),
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => Izin(gelenID: takipciAkrabaID[index],),),
                                );
                              },
                            ),
                          );
                        }),
                  ),

                ],
              ),
            ),

          ],

        ),
      ),
    );
  }

  Future<void> veriGetirOP() async{
    final _userModel = Provider.of<UserModel>(context,listen: false);
    setState(() {
      _users = _userModel.users;
    });
  }
  /// Takip Edilen
  Future<void> takipedilenAraAile()async{
      final _userModel = Provider.of<UserModel>(context,listen: false);
    var teEmail;
    var db = await FirebaseFirestore.instance
        .collection("Users").doc(_userModel.users.userID).collection('takipEdilen').where('secilenTur',isEqualTo: 0).get();
    db.docs.forEach((element) {
      takipedilenAilefromMap(element.data());
    });
    print("$teEmail");
  }
  takipedilenAilefromMap(Map<String,dynamic> map){
    setState(() {
      takipedilenAileID.add(map['takipID']);
    });///fromMap= database den okuduğun map i objeye dönüştürüyor
    ///id kontrol
    print("takip edilen id");
    print(takipedilenAileID);
  }
  Future<void>takipedilenAileIDSorgu()async{
    final _userModel = Provider.of<UserModel>(context,listen: false);
    for(int i = 0;i<takipedilenAileID.length;i++){
      var ids = await FirebaseFirestore.instance.collection("Users").where('userID',isEqualTo: takipedilenAileID[i]).get();
      ids.docs.forEach((element) {
        takipedilenAileIDfromMap(element.data());
      });
    }
    ///id kontrol
    print("takip edilen id");
    print(takipedilenAileID);

  }
  takipedilenAileIDfromMap(Map<String,dynamic> map){
    setState(() {
      takipedilenAileAd.add(map['name']);
      takipedilenAileSoyad.add(map['surname']);
    });
  }
  //--------------------------------------
  Future<void> takipedilenAraArkadas()async{
    final _userModel = Provider.of<UserModel>(context,listen: false);
    var teEmail;
    var db = await FirebaseFirestore.instance///takip edilen arkadas
        .collection("Users").doc(_userModel.users.userID).collection('takipEdilen').where('secilenTur',isEqualTo: 1).get();
    db.docs.forEach((element) {
      takipedilenArkadasfromMap(element.data());
    });
    print("$teEmail");
  }
  takipedilenArkadasfromMap(Map<String,dynamic> map){
    setState(() {
      takipedilenArkadasID.add(map["takipID"]);
    });
    ///id kontrol tearkadas
    print("takip edilen id");
    print(takipedilenArkadasID);
  }
  Future<void>takipedilenArkadasIDSorgu()async{
    final _userModel = Provider.of<UserModel>(context,listen: false);
    for(int i = 0;i<takipedilenArkadasID.length;i++){
      var ids = await FirebaseFirestore.instance.collection("Users").where('userID',isEqualTo: takipedilenArkadasID[i]).get();
      ids.docs.forEach((element) {
        takipedilenArkadasIDfromMap(element.data());
      });
    }
    ///id kontrol tearkadas
    print("takip edilen id");
    print(takipedilenArkadasID);
  }
  takipedilenArkadasIDfromMap(Map<String,dynamic> map){
    setState(() {
      takipedilenArkadasAd.add(map['name']);
      takipedilenArkadasSoyad.add(map['surname']);
    });
  }
  //--------------------------------------
  Future<void> takipedilenAraAkraba()async{
    final _userModel = Provider.of<UserModel>(context,listen: false);
    var teEmail;
    var db = await FirebaseFirestore.instance///takip edilen akraba
        .collection("Users").doc(_userModel.users.userID).collection('takipEdilen').where('secilenTur',isEqualTo: 2).get();
    db.docs.forEach((element) {
      takipedilenAkrabafromMap(element.data());
    });
    print("$teEmail");
  }
  takipedilenAkrabafromMap(Map<String,dynamic> map){
    setState(() {
      takipedilenAkrabaID.add(map['takipID']);
      //takipedilenAkrabaAd.add(map['name']);
      //takipedilenAkrabaSoyad.add(map['surname']);
    });
    ///id kontrol
    print("takip edilen id");
    print(takipedilenAkrabaID);

  }
  Future<void>takipedilenAkrabaIDSorgu()async{
    final _userModel = Provider.of<UserModel>(context,listen: false);
    for(int i = 0;i<takipedilenAkrabaID.length;i++){
      var ids = await FirebaseFirestore.instance.collection("Users").where('userID',isEqualTo: takipedilenAkrabaID[i]).get();
      ids.docs.forEach((element) {
        takipedilenAkrabaIDfromMap(element.data());
      });
    }
    ///id kontrol
    print("takip edilen id");
    print(takipedilenAkrabaID);

  }
  takipedilenAkrabaIDfromMap(Map<String,dynamic> map){
    setState(() {
      takipedilenAkrabaAd.add(map['name']);
      takipedilenAkrabaSoyad.add(map['surname']);
    });
  }
  /// Takipci
  Future<void> takipciAraAile()async{
      final _userModel = Provider.of<UserModel>(context,listen: false);
    var teEmail;
    var db = await FirebaseFirestore.instance
        .collection("Users").doc(_userModel.users.userID).collection('takipci').where('secilenTur',isEqualTo: 0).get();


    db.docs.forEach((element) {
      takipciAilefromMap(element.data());
    });
    print("$teEmail");
  }
  takipciAilefromMap(Map<String,dynamic> map){
    setState(() {
      takipciAileID.add(map['userID']);
    });

  }
  Future<void>takipciAileIDSorgu()async{
    final _userModel = Provider.of<UserModel>(context,listen: false);
    for(int i = 0;i<takipciAileID.length;i++){
      var ids = await FirebaseFirestore.instance.collection("Users").where('userID',isEqualTo: takipciAileID[i]).get();
      ids.docs.forEach((element) {
        takipciAileIDfromMap(element.data());
      });
    }
    ///id kontrol
    print("takipci aile id");
    print(takipciAileID);

  }
  takipciAileIDfromMap(Map<String,dynamic> map){
    setState(() {
      takipciAileAd.add(map['name']);
      takipciAileSoyad.add(map['surname']);
    });
    print("takipci aile ad soyad");
    print(takipciAileAd);
    print(takipciAileSoyad);
  }
  //--------------------------------------
  Future<void> takipciAraArkadas()async{
    final _userModel = Provider.of<UserModel>(context,listen: false);
    var teEmail;
    var db = await FirebaseFirestore.instance///takip edilen arkadas
        .collection("Users").doc(_userModel.users.userID).collection('takipci').where('secilenTur',isEqualTo: 1).get();


    db.docs.forEach((element) {
      takipciArkadasfromMap(element.data());
    });
    print("$teEmail");
  }
  takipciArkadasfromMap(Map<String,dynamic> map){
    setState(() {
      takipciArkadasID.add(map['userID']);

    });

  }
  Future<void>takipciArkadasIDSorgu()async{
    final _userModel = Provider.of<UserModel>(context,listen: false);
    for(int i = 0;i<takipciArkadasID.length;i++){
      var ids = await FirebaseFirestore.instance.collection("Users").where('userID',isEqualTo: takipciArkadasID[i]).get();
      ids.docs.forEach((element) {
        takipciArkadasIDfromMap(element.data());
      });
    }
    ///id kontrol
    print("takipci arkadas id");
    print(takipciArkadasID);

  }
  takipciArkadasIDfromMap(Map<String,dynamic> map){
    setState(() {
      takipciArkadasAd.add(map['name']);
      takipciArkadasSoyad.add(map['surname']);
    });
  }
  //--------------------------------------
  Future<void> takipciAraAkraba()async{
    final _userModel = Provider.of<UserModel>(context,listen: false);
    var teEmail;
    var db = await FirebaseFirestore.instance
        .collection("Users").doc(_userModel.users.userID).collection('takipci').where('secilenTur',isEqualTo: 2).get();


    db.docs.forEach((element) {
      takipciAkrabafromMap(element.data());
    });
    print("$teEmail");
  }
  takipciAkrabafromMap(Map<String,dynamic> map){
    setState(() {
      takipciAkrabaID.add(map["userID"]);
    });

  }
  Future<void>takipciAkrabaIDSorgu()async{
    final _userModel = Provider.of<UserModel>(context,listen: false);
    for(int i = 0;i<takipciAkrabaID.length;i++){
      var ids = await FirebaseFirestore.instance.collection("Users").where('userID',isEqualTo: takipciAkrabaID[i]).get();
      ids.docs.forEach((element) {
        takipedilenAkrabaIDfromMap(element.data());
      });
    }
    ///id kontrol
    print("takipci akraba id");
    print(takipciAkrabaID);

  }
  takipciAkrabaIDfromMap(Map<String,dynamic> map){
    setState(() {
      takipciAkrabaAd.add(map['name']);
      takipciAkrabaSoyad.add(map['surname']);
    });
  }
}







