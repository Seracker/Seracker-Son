import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seracker/firestore_islemleri.dart';
import 'package:seracker/models/Users.dart';
import 'package:seracker/profil_page/kisilerim.dart';
import 'package:seracker/viewmodel/user_model.dart';
import 'package:http/http.dart' as http;
FirebaseAuth _auth = FirebaseAuth.instance;
class OrtakPaylasim extends StatefulWidget {
  @override
  _OrtakPaylasimState createState() => _OrtakPaylasimState();
}

class _OrtakPaylasimState extends State<OrtakPaylasim> {
  int secilenTur = 0,durum = 0;
  String kisiId,email,takipID,takipEmail,takipName,takipSurname,emailID,token,ek;
  bool adim=false,nabiz=false,hastaliklar=false,tahlil=false;
  Users _users;
  var teName,teSurname,teID,teEmail;

  var formkey = GlobalKey<FormState>();
  bool yukleniyor=true;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        yukleniyor=false;
      });

    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: ExactAssetImage("img/ortakKalp.png"), fit: BoxFit.cover),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                DropdownButton<int>(
                  items: takipEdilenKisiTuru(),
                  value: secilenTur,
                  onChanged: (secilenDeger) {
                    setState(() {
                      secilenTur = secilenDeger;
                    });
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Form(
                  key: formkey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Kişi E-Postası",
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 2),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                        validator: (girilenDeger) {
                          if (girilenDeger.length > 0) {
                            return null;
                          } else
                            return "E-posta bos olamaz";
                        },
                        onChanged: (deger){
                          email =deger;
                        },
                        onSaved: (KaydedilenDeger) {
                          setState(() {
                            email = KaydedilenDeger;
                          });
                        },
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      padding: EdgeInsets.all(8.0),
                      onPressed: () async{
                        await sorgu();
                        debugPrint("kaydedilen deger $email");
                        debugPrint("seçilen tür $secilenTur");
                      },
                      child: Text("Kişiyi Ekle"),
                      color: Colors.blue,
                      height: 50,
                      minWidth: 180,
                    ),
                    FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      onPressed: () async{
                       Navigator.push(context, MaterialPageRoute(builder: (context) => Kisilerim()));

                      },
                      child: Text("Kişilerim"),
                      color: Colors.blue,
                      height: 50,
                      minWidth: 180,
                    ),
                  ],
                )
              ],
            ),
          ],
        ));
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
  Future<void> kontrol()async{
    print("kontrol "+teID);
    final _userModel = Provider.of<UserModel>(context,listen: false);
    print("kontrol ${_userModel.users.userID}");
    var db = await FirebaseFirestore.instance
        .collection("Users").doc(_userModel.users.userID).collection("takipEdilen").where("takipID",isEqualTo: teID).get();
    db.docs.forEach((element) { 
      ek=element["takipID"];
    });
    print("ek $ek");
    if(ek==null){
      await veriEkleOPTE();
      await veriEkleOPT();
      await emailAra();
      await emailIDSorgu();
      await sendPushMessage();
      final snackBar = SnackBar(
        backgroundColor: Colors.grey.shade600,
        content: Text('Takip isteği gönderildi'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

    }else{
      final snackBar = SnackBar(
        backgroundColor: Colors.grey.shade600,
        content: Text('Bu kullanıcıyı daha önce zaten eklediniz!'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
  Future<void> veriGetirOP() async{
    final _userModel = Provider.of<UserModel>(context,listen: false);
    setState(() {
      _users = _userModel.users;
    });
  }
  Future<void> sorgu() async{
    var db = await FirebaseFirestore.instance
    .collection("Users").where('email' ,isEqualTo: email).get();
    db.docs.forEach((takipEdilen) {
      print(takipEdilen.get("password"));
    });

    db.docs.forEach((element) {
     setState(() {
       teName = element.get("name");
       teSurname = element.get("surname");
       teEmail = element.get("email");
       teID = element.get("userID");
     });
    });
    print("$teName $teSurname $teID $teEmail");
    await kontrol();
  }
  Future<void> veriEkleOPTE() async{
    setState(() {
      takipID = teID;
      takipEmail = teEmail;
      takipName = teName;
      takipSurname = teSurname;
    });
    try{
      User _credential = await _auth.currentUser;
      String _users = _credential.uid;
      await veriekleOPTE(_credential.uid,takipEmail,takipID,secilenTur,takipName,takipSurname);
    }catch(e){
      debugPrint("*************HATA VAR****************");
      debugPrint(e.toString());
    }
  }
  ///buraya takipci bilgileri gelecek
  Future<void> veriEkleOPT() async{
    final _userModel = Provider.of<UserModel>(context,listen: false);
    setState(() {
      takipID = teID;
    });
    try{
      await veriekleOPT(
          _userModel.users.userID,_userModel.users.email,takipID,_userModel.users.name,_userModel.users.surname,adim,nabiz,hastaliklar,secilenTur,durum,tahlil);
    }catch(e){
      debugPrint("*************HATA VAR****************");
      debugPrint(e.toString());
    }
  }

  Future<void> emailAra()async{
    final _userModel = Provider.of<UserModel>(context,listen: false);
    print("email ara "+email);
    var db = await FirebaseFirestore.instance
        .collection("Users").where('email',isEqualTo: email).get();
    db.docs.forEach((element) {
      emailfromMap(element.data());
    });
  }
  emailfromMap(Map<String,dynamic> map){
    setState(() {
      emailID = map['userID'];
    });///fromMap= database den okuduğun map i objeye dönüştürüyor
    ///id kontrol
    print("email id fromMap");
    print(emailID);
  }
  Future<void>emailIDSorgu()async{
    final _userModel = Provider.of<UserModel>(context,listen: false);
    print(emailID);
    var ids = await FirebaseFirestore.instance.collection("tokens")
        .where('userID',isEqualTo: emailID).get();
      ids.docs.forEach((element) {
        token = element['token'];
      });
      print("email id sorgu");
      print("token: $token");
  }
  Future<void> sendPushMessage() async {
    if (token == null) {
      print('Unable to send FCM message, no token exists.');
      return;
    }
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'key=AAAAfbVdXSw:APA91bG0HwMcnA9wAmKIHYj31OMLil1GLeSxDpWekWVYy16PnS3xNsuk0kQNK1cDQ2twAs0VHf8uqfllYwUgCTQ4SP5L3kP5ox9O28DvRofNFOPWuhGDdvsHNiHK4Wau0BaAj9Hey0kE',
          },
        body: constructFCMPayload(token),
      );
      print('FCM request for device sent!');
    } catch (e) {
      print(e);
    }
  }
  int _messageCount = 0;
  String constructFCMPayload(String token) {
    _messageCount++;
    print("constructPayload ************   "+token);
    return jsonEncode(
      <String, dynamic>{
        'notification': <String, dynamic>{'body': '${_users.name} ${_users.surname} size takip isteği gönderdi', 'title': 'Seracker'},
        'priority': 'high',
        'data': <String, dynamic>{
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        },
        'to': token,
      },
    );
  }
}