import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seracker/firestore_islemleri.dart';
import 'package:seracker/models/kisisel_bilgilerdb.dart';
import 'package:seracker/profil_page/saglik_bilgileri.dart';

import 'package:seracker/viewmodel/user_model.dart';
import 'profil_page/hesap_ayrintilari.dart';
import 'profil_page/kisilerim.dart';
import 'profil_page/kisisel_bilgiler.dart';
import 'models/Users.dart';
FirebaseAuth _auth = FirebaseAuth.instance;
class ProfilEkrani extends StatefulWidget {


  @override
  _ProfilEkraniState createState() => _ProfilEkraniState();
}

class _ProfilEkraniState extends State<ProfilEkrani> {
  var _UID;
  bool yukleniyor = true;
  String _userID, _dogumTarihi, _kanGrubu,_boy, _kilo,_email,_password;
  KBI _infos;
  Users _users;
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await veriGetir();
      await veriGetirKB();
      setState(() {
        yukleniyor = false;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    final _userModel = Provider.of<UserModel>(context,listen: false);
    return Theme(
      data: Theme.of(context).copyWith(
        accentColor: Colors.white,
        primaryColor: Colors.green,
        hintColor: Colors.teal,
      ),
      child: Scaffold(
        backgroundColor: Colors.grey.shade800,
        body: yukleniyor ? Center(child: CircularProgressIndicator(),)
            : ListView(
          padding: EdgeInsets.all(16),
            children: [
              Center(
                heightFactor: 1.5,

                child: Image.asset(
                  "img/user.png",
                  scale: 4,
                ),
              ),
              //Kayıt olduktan sonraki isim soyisim verisi alınacak !!!
              Center(
                heightFactor: 1.1,
                child: Text(_userModel.users.name + " " +_userModel.users.surname,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: 350,
                  height: 40,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                      side: BorderSide(color: Colors.green),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Text(
                          "Hesap Ayrıntıları",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        Icon(Icons.arrow_right_sharp),
                      ],
                    ),
                    color: Colors.grey.shade300,
                    onPressed: () {
                      veriGetir();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HesapAyrintilari()),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: 350,
                  height: 40,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                      side: BorderSide(color: Colors.green),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Text(
                          "Kişisel Bilgiler",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        Icon(Icons.arrow_right_sharp),
                      ],
                    ),
                    color: Colors.grey.shade300,
                    onPressed: () {

                      veriGetir();
                      veriGetirKB();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => KisiselBilgiler()),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: 350,
                  height: 40,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                      side: BorderSide(color: Colors.green),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Text(
                          "Kişilerim",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        Icon(Icons.arrow_right_sharp),
                      ],
                    ),
                    color: Colors.grey.shade300,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Kisilerim()),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: 350,
                  height: 40,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                      side: BorderSide(color: Colors.green),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Text(
                          "Sağlık Bilgileri",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        Icon(Icons.arrow_right_sharp),
                      ],
                    ),
                    color: Colors.grey.shade300,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SaglikBilgileri()),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),

      ),
    );
  }
  Future<void> veriGetir() async{
    final _userModel = Provider.of<UserModel>(context,listen: false);
    setState(() {
      _users = _userModel.users;
    });

  }
  Future<void> veriGetirKB() async{
    final _userModel = Provider.of<UserModel>(context,listen: false);
    setState(() {
      _infos = _userModel.infos;

    });
  }
  /*Future<KBI> veriGetirKB() async{
    final _userModel = Provider.of<UserModel>(context,listen: false);
    DocumentSnapshot documentSnapshot =
    await FirebaseFirestore.instance.collection("Users").doc(_infos.userID).collection("info").doc("kisiselBilgiler").get();
    setState(() {
      _infos = _userModel.infos;
    });
  }*/
  Future<void> veriEkleKB () async{
    try{
      User _credential = await _auth.currentUser;
      String _users = _credential.uid;
      await veriekleKB(_credential.uid,_boy,_kilo,_kanGrubu);
    }catch(e){
      debugPrint("*************HATA VAR****************");
      debugPrint(e.toString());
    }
  }
}





