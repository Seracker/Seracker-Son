import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:provider/provider.dart';
import 'package:seracker/firestore_islemleri.dart';
import 'package:seracker/models/Users.dart';
import 'package:seracker/models/adim.dart';

import 'package:seracker/models/nabiz.dart';
import 'package:seracker/pages/ana_sayfa.dart';
import 'package:seracker/viewmodel/user_model.dart';

import 'package:http/http.dart' as http;

import 'models/saglikModel.dart';
import 'utils/saglıkDbHelper.dart';

///bildirim sayfası


class TestPage extends StatefulWidget {

  @override
  _TestPage createState() => new _TestPage();
}

class _TestPage extends State<TestPage> {

  static final clientID = 0;
  BluetoothConnection connection;

  String _messageBuffer = '';

  final TextEditingController textEditingController =
  new TextEditingController();
  final ScrollController listScrollController = new ScrollController();

  bool isConnecting = true;
  bool get isConnected => connection != null && connection.isConnected;

  bool isDisconnecting = false;


  Nabiz _nabiz;
  String nabizTarihi;
  String a;
  String ilkAdim,sonAdim;
  int adimFark;
  DateTime today= DateTime.now();
  DateTime ilkSaat=DateTime.now();
  String iSaat;
  bool yukleniyor = true;
  List<String> nabizDegeri=[],tarih=[];
  Adim _adim;
  int yas;
  Users _users;
  bool exist=false,kosuyorMu=false;
  List<String> izinUserID=[],tokens=[];
  List<String> nabizYas=["20-60-100","25-58-97","30-57-95","35-55-92","40-54-90","45-52-87","50-51-85","55-49-82",
    "60-48-80","65-46-77","70-45-75"];
  int minNabiz,maxNabiz;
  String isim,soyisim;
  SaglikDbHelper _databaseHelper;
  List<SaglikModel> tumSaglikListesi;
  int hastalikTur=0;
  bool bekle=false;
  bool cevap=false,cevap2=false;
  var sd;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      nabizTarihi ="${today.year.toString()}-${today.month.toString().padLeft(2,'0')}-${today.day.toString().padLeft(2,'0')}";
      tarih.add(nabizTarihi);
      final _userModel = Provider.of<UserModel>(context,listen: false);
      var db = await FirebaseFirestore.instance;
      final snapShot = await db.collection("Users").doc(_userModel.users.userID).collection("nabiz").doc(nabizTarihi).get();
      if(snapShot.exists){
        Nabiz kadir=Nabiz.fromMap(snapShot.data());
        kadir.nabiz.forEach((element) {
          nabizDegeri.add(element);
        });
        exist = true;
      }
      await veriGetir();
      await veriGetirAdim();
      await veriGetirNabiz();
      await yasGetir();
      await izinSorgu();
      await tokenSorgu();
      minMax();
      
      ilkAdim=_adim.adim;
      iSaat="${ilkSaat.hour.toString()}:${ilkSaat.minute.toString()}";
      setState(() {
        yukleniyor = false;
      });
    });
    tumSaglikListesi = List<SaglikModel>();
    _databaseHelper = SaglikDbHelper();
    _databaseHelper.tumSaglik().then((map){
      for(Map okunanMap in map){
        SaglikModel a=SaglikModel.fromMap(okunanMap);
        if(a.tur=="1"){
          tumSaglikListesi.add(a);

        }

      }
      setState(() {


      });
    }).catchError((hata)=>print("hata:"+hata));

  }
  @override
  void dispose() {
    if (isConnected) {
      isDisconnecting = true;
      connection.dispose();
      connection = null;
      AnaSayfa(bluetoothDurum: false,);
    }
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    ///Liste eklenecek
    List<String>list=["NABIZ80","NABIZ79","NABIZ76","NABIZ81","NABIZ83","NABIZ87","NABIZ35",];
    //parca(list.last,list.length);
    
    return   yukleniyor ? Center(child: CircularProgressIndicator(),)
        :Scaffold(
        body:Column(
          children: [
            Image.asset("img/pulse.gif", height: 70, width:120,),
            Text(list.last),
            Center(
              child: ElevatedButton(onPressed: () async{
                parca(list.last, list.length);
  
                
              }, child: Text("buton")),
            ),
          ],  ));
  }
  Future<String> parca(String deger,int uzunluk)async{
    print("parca çalıştı");
    print(iSaat);
    print(ilkAdim);
    DateTime nabizZamani= DateTime.now();
    if(nabizZamani.minute<10){
      a="${nabizZamani.hour.toString()}:0${nabizZamani.minute.toString()}";
    }else{
      a="${nabizZamani.hour.toString()}:${nabizZamani.minute.toString()}";
    }
    print("$a");
    if(deger.substring(0,5)=="NABIZ"){
      nabizDegeri.add(deger.substring(5)+" saat: "+a);
      print("$nabizTarihi");
      nabizKontrol(int.parse(deger.substring(5)));
      if(cevap&&!cevap2){
          sendPushMessage();
          bekle=false;
          cevap=false;
       }
      if(exist){
        print("ife girdi");
        await veriGuncelleNG();
      }else{
        print("else e girdi");
        await veriEkleSN();
      }
    }
    else if(deger.substring(0,4)=="tit0"){
    }
  }
  Future<void> veriGetir() async{
    final _userModel = Provider.of<UserModel>(context,listen: false);
    setState(() {
      _users = _userModel.users;
    });
  }
  String atama(){
    print("atama");
    String n= nabizDegeri.last;
    return n;
  }
  Future<void> veriGetirNabiz() async{
    final _userModel = Provider.of<UserModel>(context,listen: false);
    _nabiz= await _userModel.readNabiz(_userModel.users.userID,nabizTarihi);
  }
  Future<void> veriEkleSN() async{
    final _userModel = Provider.of<UserModel>(context,listen: false);
    print(nabizDegeri.length.toString());
    try{
      await veriekleNabiz(_userModel.users.userID,nabizDegeri,nabizTarihi);
    }catch(e){
      debugPrint("*HATA VAR**");
      debugPrint(e.toString());
    }
  }
  Future<void> veriGuncelleNG() async{
    final _userModel = Provider.of<UserModel>(context,listen: false);
    setState(() {
      _userModel.nabiz=_nabiz;
    });
    print("nabiz = $_nabiz");
    _nabiz.nabiz=nabizDegeri;
    await _userModel.updateNabiz(_userModel.users,_nabiz,nabizTarihi);
  }
  Future<void> veriGetirAdim() async{
    final _userModel = Provider.of<UserModel>(context,listen: false);
    _userModel.readAdim(_userModel.users.userID,nabizTarihi).then((value) {
      setState(() {
        _adim=value;
      });
    });
  }
  Future<void> sonAdimm()async{
    String c;
    final _userModel = Provider.of<UserModel>(context,listen: false);
    var db= await FirebaseFirestore.instance.collection("Users").doc(_userModel.users.userID).collection("adim")
        .where("adimTarihi",isEqualTo: nabizTarihi).get();
    db.docs.forEach((element) {
      c=element["adim"];
    });
    await adimHesapla(c);
  }
  Future<void> adimHesapla(String sonAdim){
    print("ilk adim"+ilkAdim);
    print("son adim"+sonAdim);
    adimFark=int.parse(sonAdim)-int.parse(ilkAdim);
    print("adim fark "+adimFark.toString());
    int dakika = zamanHesapla();
    if(adimFark/dakika>=110){
      kosuyorMu= true;
    }else{
      kosuyorMu=false;
    }
    print("kosuyor mu? "+kosuyorMu.toString());
  }
  int zamanHesapla(){
    String saat=iSaat.substring(0,2);
    String dk=iSaat.substring(3);
    print("saat"+saat);
    print("dakika"+dk);
    int ysaat=DateTime.now().hour-int.parse(saat);
    int ydk=DateTime.now().minute-int.parse(dk);
    print("ysaat"+ysaat.toString());
    print("ydk"+ydk.toString());
    if(ysaat>0 && ydk<=0){
      ydk=ydk+60;
      ysaat=ysaat-1;
    }
    if(ysaat>0){
      ydk=ydk+(60*ysaat);
    }
    return ydk;
  }
  Future<void> yasGetir()async{
    final _userModel = Provider.of<UserModel>(context,listen: false);
    var db= await FirebaseFirestore.instance.collection("Users").doc(_userModel.users.userID).get();
    db.data().forEach((key, value) {
      agefromMap(db.data());
    });
  }
  agefromMap(Map<String,dynamic> map){
    setState(() {
      yas=map["age"];
    });
    print("çalıştı "+yas.toString());
  }
  void minMax(){
    for(int i=0;i<nabizYas.length;i++){
      if(yas>=int.parse(nabizYas[i].substring(0,2))){
        minNabiz=int.parse(nabizYas[i].substring(3,5));
        maxNabiz=int.parse(nabizYas[i].substring(6));
      }
    }
    print(minNabiz.toString()+" "+maxNabiz.toString());
  }
  void dkBekle(){
    Timer(Duration(seconds: 20),(){
          setState(() {
           cevap=true;
           print("cavap"+cevap.toString());
          });
        });
}
 void nabizKontrol(int n){
    print("burası njnd");
    if(n<minNabiz&&!bekle){
      hastalikKontrol(1);
      print("gridi 1");
      if(hastalikTur==2){
        print("girdi 2");
        if(n<(minNabiz-10)){
          print("girdi 3");
         // _sendMessage('0');
          dkBekle();
          bekle=true;
        }
      }else{
        print("amk");
       // _sendMessage('0');
        dkBekle();
        bekle=true;
      }

    }else if(n>maxNabiz && !bekle){
      sonAdimm();
      if(!kosuyorMu){
        print(kosuyorMu.toString());
        hastalikKontrol(0);
        if(hastalikTur==1){
          if(n>(maxNabiz+10)){
            print("has max send");
            //_sendMessage('0');
            dkBekle();
            bekle=true;
          }

        }
        else{
          print("max sen");
         // _sendMessage('0');
          dkBekle();
          bekle=true;
        }
        //hastaMi
        //değilse tit1 yolla
        // sendPushMessage();
      }
    }
  }
  void hastalikKontrol(int sebep){
    for(int i=0;i<tumSaglikListesi.length;i++){
      String hastalik=tumSaglikListesi[i].isim;
      print(hastalik);
      if(sebep==0){
        switch (hastalik) {
          case "Tifo":{
            hastalikTur=1;

          }
          break;

          case "Kalp Yetmezliği":{
            hastalikTur=1;
          }
          break;
          case "Tiroit":{
            hastalikTur=1;
          }
          break;
          case "Guatr":{
            hastalikTur=1;
          }
          break;


        }


      }
      else{
        switch (hastalik) {
          case "Endokardit Enfeksiyon":{
            hastalikTur=2;
          }
          break;
          case "Dilate kardiyomiyopat":{
            hastalikTur=2;
          }
          break;
          case "Kalp delikleri":{
            hastalikTur=2;
          }
          break;
          case "Koroner damar yetmezliği":{
            hastalikTur=2;
          }
          break;
          case "uyku apnesi":{
            hastalikTur=2;
          }
          break;


        }

      }


    }}

  Future<void> izinSorgu()async{
    print("izinSorgu");
    final _userModel = Provider.of<UserModel>(context,listen: false);
    var db= await FirebaseFirestore.instance.collection("Users").doc(_userModel.users.userID).collection("takipci")
        .where("nabiz",isEqualTo: true).get();
    db.docs.forEach((element) {
      izinUserID.add(element["userID"]);
    });
    print(izinUserID);
  }
  Future<void> tokenSorgu()async{
    print("tokenSorgu");
    final _userModel = Provider.of<UserModel>(context,listen: false);
    for(int i=0 ;i<izinUserID.length;i++){
      var db= await FirebaseFirestore.instance.collection("tokens").doc(izinUserID[i]).get();
      db.data().forEach((key, value) {
        tokensfromMap(db.data());
      });
    }
  }
  tokensfromMap(Map<String,dynamic> map){
    print("tokensfrommap");
    setState(() {
      tokens.add(map["token"]);
    });
    print(tokens);
  }
  Future<void> sendPushMessage() async {
    if (tokens == null) {
      print('Unable to send FCM message, no token exists.');
      return;
    }
    for(int i=0;i<tokens.length;i++){
      try {
        await http.post(
          Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'key=AAAAfbVdXSw:APA91bG0HwMcnA9wAmKIHYj31OMLil1GLeSxDpWekWVYy16PnS3xNsuk0kQNK1cDQ2twAs0VHf8uqfllYwUgCTQ4SP5L3kP5ox9O28DvRofNFOPWuhGDdvsHNiHK4Wau0BaAj9Hey0kE',
          },
          body: constructFCMPayload(tokens[i]),
        );
        print('FCM request for device sent!');
      } catch (e) {
        print(e);
      }
    }
  }
  int _messageCount = 0;
  String constructFCMPayload(String token) {
    _messageCount++;
    print("constructPayload ************   "+token);
    return jsonEncode(
      <String, dynamic>{
        'notification': <String, dynamic>{'body': '${_users.name} ${_users.surname} Kişisini Kontrol Ediniz', 'title': 'Nabız Uyarısı'},
        'priority': 'high',
        'data': <String, dynamic>{
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        },
        'to': token,
      },
    );
  }
}