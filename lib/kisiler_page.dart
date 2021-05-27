import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seracker/models/Users.dart';
import 'package:seracker/models/izin_db.dart';
import 'package:seracker/profil_page/kisilerim.dart';
import 'package:seracker/viewmodel/user_model.dart';

class Yazi extends StatefulWidget {
  final String gelenID;
  const Yazi({Key key,this.gelenID}):super(key: key);
  @override
  _YaziState createState() => _YaziState();
}

class _YaziState extends State<Yazi> {
  Users _users;
  String gelenAd,gelenSoyad;
  bool yukleniyor = true;
  String sonAdim,nabizTarihi;
  DateTime today = new DateTime.now();
  List<dynamic> sonNabiz;
  dynamic hastaliklar=[];
  IzinDb _izin;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      nabizTarihi ="${today.year.toString()}-${today.month.toString().padLeft(2,'0')}-${today.day.toString().padLeft(2,'0')}";
      await gelenIDAra(widget.gelenID);
      await hastalikSorgu();
      await siralamaNabiz();
      await siralamaAdim();
       _izin =await veriGetirIPI(widget.gelenID);
      setState(() {
        yukleniyor =false;
      });
    });

  }
  @override
  Widget build(BuildContext context) {
    //String gelenID;
    int index=0;
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
          child: ListView(children: <Widget>[
            Center(
              heightFactor: 1.5,

              child: Image.asset(
                "img/user.png",
                scale: 4,
              ),
            ),
            Center(
              child: Container(
                  width: 300,
                  height: 50,
                  child: Center(
                      child: Text("$gelenAd $gelenSoyad",style: TextStyle(fontSize: 27)))),),

            Container(
              height: 85,
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: Card(
                elevation: 5,
                color: Colors.grey.shade700 ,
                child: Column(
                  children: [
                    Text("Hastalıkları",style: TextStyle(fontSize: 21,color: Colors.black),),
                    SizedBox(height: 20,),
                    Text(_izin.hastaliklar==false?"izin yok":hastaliklar[index].toString().replaceAll("[", "").replaceAll("]", ""),
                      style: TextStyle(color: Colors.black),),
                    SizedBox(height: 10,),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20,),
            Container(
              height: 85,
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: Card(
                elevation: 5,
                color: Colors.grey.shade600 ,
                child: Column(
                  children: [
                    Text("Nabız",style: TextStyle(fontSize: 21,color: Colors.black),),
                    SizedBox(height: 20,),
                    Text(_izin.nabiz==false?"izin yok":"nabız "+sonNabiz.last.toString(),style: TextStyle(color: Colors.black),),
                    SizedBox(height: 10,),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20,),
            Container(
              height: 90,
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: Card(
                elevation: 5,
                color: Colors.grey.shade500 ,
                child: Column(
                  children: [
                    Text("Adım",style: TextStyle(fontSize: 21,color: Colors.black),),
                    SizedBox(height: 20,),
                    Text(_izin.adim==false?"izin yok":"Bugünkü Adım Sayısı: "+sonAdim,style: TextStyle(color: Colors.black),),
                    SizedBox(height: 10,),
                  ],
                ),
              ),
            ),

            //Center(child: Card(child: Text("${widget.gelenID}"))),
          ] ),
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
  Future<IzinDb> veriGetirIPI(String gelenID) async{
    final _userModel = Provider.of<UserModel>(context,listen: false);
    return await _userModel.readIzin(gelenID,_userModel.users.userID);
  }
  Future<void> hastalikSorgu()async{
    final _userModel = Provider.of<UserModel>(context,listen: false);
    var db = await FirebaseFirestore.instance
        .collection("Users").doc(widget.gelenID).collection("saglikBilgileri").doc("hastalikAdi").get();
    db.data().forEach((key, value) {
      hastalikAdifromMap(db.data());
    });
    print(hastaliklar);
  }
  hastalikAdifromMap(Map<String,dynamic> map){
    setState(() {
      hastaliklar.add(map["hastalik"]);
    });
  }
  Future<void> gelenIDAra(String gelenID)async{
    final _userModel = Provider.of<UserModel>(context,listen: false);
    var db = await FirebaseFirestore.instance
        .collection("Users").where('userID',isEqualTo: gelenID).get();

    db.docs.forEach((element) {
      gelenAd = element.get("name");
      gelenSoyad = element.get("surname");
    });
    print("$gelenAd $gelenSoyad");
  }
  Future<void>siralamaAdim()async{
    final _userModel = Provider.of<UserModel>(context,listen: false);
    var db = await FirebaseFirestore.instance
        .collection("Users").doc(widget.gelenID).collection("adim").orderBy("adimTarihi").limitToLast(1).get();
    db.docs.forEach((element) {

      sonAdim=element["adim"];
    });
  }
  Future<void>siralamaNabiz()async{
    final _userModel = Provider.of<UserModel>(context,listen: false);
    var db2 = await FirebaseFirestore.instance
        .collection("Users").doc(widget.gelenID).collection("nabiz").get();
    //print("sonuc: "+db2.data().toString());
    db2.docs.forEach((element) {
      sonNabiz=element["nabiz"];
    });
    /*db2.data().forEach((key, value) {
      sonNabiz.add(value["nabiz"]);
    });*/
    print("son nabiz");
    print(sonNabiz);
  }
  nabizfromMap(Map<String,dynamic> map){
    setState(() {
      sonNabiz.add(map['nabiz']);
    });///fromMap= database den okuduğun map i objeye dönüştürüyor
    ///id kontrol
    print("son nabiz");
    //print(sonNabiz);
  }

}

