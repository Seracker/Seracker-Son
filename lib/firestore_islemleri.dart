import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class FirestoreIslemleri extends StatefulWidget {
  @override
  _FirestoreIslemleriState createState() => _FirestoreIslemleriState();
}

class _FirestoreIslemleriState extends State<FirestoreIslemleri> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("firestorm işlemleri"),
      ),
      body: Center(
        child: Column(
          children: [
          ],
        ),
      ),
    );
  }


}
  Future<void> veriekle(_userID,_isim,_soyisim,_tcNo,_email,_tel,_password,_cinsiyet,_dogumTarihi,_age) async {

  Map<String, dynamic> kisiEkle = Map();
  kisiEkle['userID']=_userID;
  kisiEkle['name']= _isim;
  kisiEkle['surname']= _soyisim;
  kisiEkle['tcNo']= _tcNo;
  kisiEkle['email']= _email;
  kisiEkle['tel']= _tel;
  kisiEkle['password']= _password;
  kisiEkle['cinsiyet']= _cinsiyet;
  kisiEkle['dogumTarihi']= _dogumTarihi;
  kisiEkle['age']= _age;
  debugPrint("Buraya geldi");
  await _firestore.collection("Users").doc(_userID).set(kisiEkle).then((value) => debugPrint("Kişi eklendi"));

}
Future<void> veriekleKB(_userID,_boy,_kilo,_kanGrubu) async {

  Map<String, dynamic> kisiBilgiEkle = Map();
  kisiBilgiEkle['userID']=_userID;
  kisiBilgiEkle['boy']= _boy ?? 0;
  kisiBilgiEkle['kilo']= _kilo ?? 0;
  //kisiBilgiEkle['dogumTarihi']= _dogumTarihi;
  kisiBilgiEkle['kanGrubu']= _kanGrubu ?? '';

  debugPrint("Buraya geldi -verieklekb-");
  await _firestore.collection("Users").doc(_userID).collection("info").doc("kisiselBilgiler").set(kisiBilgiEkle).then((value) => debugPrint("Kişi bilgisi eklendi"));

}
Future<void> veriekleOPTE(_userID,_takipEmail,_takipID,_secilenTur,_takipName,_takipSurname) async {

  Map<String, dynamic> kisiBilgiEkle = Map();
  //kisiBilgiEkle['userID']=_userID;
  kisiBilgiEkle['email']= _takipEmail;
  kisiBilgiEkle['takipID']= _takipID;
  kisiBilgiEkle['secilenTur']= _secilenTur;
  kisiBilgiEkle['name']= _takipName;
  kisiBilgiEkle['surname']= _takipSurname;


  debugPrint("Buraya geldi -veriekleopte-");
  await _firestore.collection("Users").doc(_userID).collection("takipEdilen").doc(_takipID).set(kisiBilgiEkle).then((value) => debugPrint("Hesap bilgisi eklendi"));

}
Future<void> veriekleOPT(_userID,_takipciEmail,_takipciID,_takipciName,_takipciSurname,_takipciadim,_takipcinabiz,_takipcihastaliklar,_takipciTur,_durum,_tahlil) async {

  Map<String, dynamic> kisiBilgiEkle = Map();
  kisiBilgiEkle['userID']=_userID;
  kisiBilgiEkle['email']= _takipciEmail;
  kisiBilgiEkle['name']= _takipciName;
  kisiBilgiEkle['surname']= _takipciSurname;
  kisiBilgiEkle['adim']= _takipciadim;
  kisiBilgiEkle['nabiz']= _takipcinabiz;
  kisiBilgiEkle['hastaliklar']= _takipcihastaliklar;
  kisiBilgiEkle['secilenTur']= _takipciTur;
  kisiBilgiEkle['durum']= _durum;
  kisiBilgiEkle['tahlil']= _tahlil;
  debugPrint("Buraya geldi -veriekleopt-");
  await _firestore.collection("Users").doc(_takipciID).collection("takipci").doc(_userID).set(kisiBilgiEkle).then((value) => debugPrint("Hesap bilgisi eklendi"));

}
Future<void> veriekleSBH(_userID,List<String> _hastalikAdi) async {
  Map<String,dynamic> kisiBilgiEkle = Map();

  kisiBilgiEkle['hastalik'] = _hastalikAdi;

  debugPrint("Buraya geldi -verieklesbh-");
  await _firestore.collection("Users").doc(_userID).collection("saglikBilgileri").doc("hastalikAdi").set(kisiBilgiEkle).then((value) => debugPrint("Hesap bilgisi eklendi"));

}
Future<void> veriekleSBI(_userID,List<String> _ilacAdi) async {

  Map<String, dynamic> kisiBilgiEkle = Map();

  kisiBilgiEkle['ilac']= _ilacAdi;

  debugPrint("Buraya geldi -verieklesbi-");
  await _firestore.collection("Users").doc(_userID).collection("saglikBilgileri").doc("ilacAdi").set(kisiBilgiEkle).then((value) => debugPrint("Hesap bilgisi eklendi"));

}
Future<void> veriekleAdim(_userID,String _adim,String adimTarihi) async {

  Map<String, dynamic> kisiBilgiEkle = Map();

  kisiBilgiEkle['adim']= _adim;
  kisiBilgiEkle['adimTarihi']= adimTarihi;
  debugPrint("Buraya geldi -veriekleAdim-");
  await _firestore.collection("Users").doc(_userID).collection("adim").doc("$adimTarihi").set(kisiBilgiEkle).then((value) => debugPrint("Hesap bilgisi eklendi"));

}
Future<void> veriekleNabiz(_userID,List<String> _nabiz,String nabizTarihi) async {
  Map<String, List<dynamic>> kisiBilgiEkle = Map();

  kisiBilgiEkle['nabiz']= _nabiz;
  debugPrint("Buraya geldi -veriekleNabiz-");
  await _firestore.collection("Users").doc(_userID).collection("nabiz").doc("$nabizTarihi").set(kisiBilgiEkle).then((value) => debugPrint("Hesap bilgisi eklendi"));
}