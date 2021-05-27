import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:provider/provider.dart';
import 'package:seracker/firestore_islemleri.dart';
import 'package:seracker/models/nabiz.dart';
import 'package:seracker/pages/ana_sayfa.dart';
import 'package:seracker/viewmodel/user_model.dart';
import 'models/Users.dart';
import 'models/adim.dart';
import 'models/saglikModel.dart';
import 'utils/saglıkDbHelper.dart';
import 'package:http/http.dart' as http;



class ChatPage extends StatefulWidget {
  final BluetoothDevice server;

  const ChatPage({this.server});

  @override
  _ChatPage createState() => new _ChatPage();
}

class _Message {
  int whom;
  String text;

  _Message(this.whom, this.text);
}

class _ChatPage extends State<ChatPage> {
 
  static final clientID = 0;
  BluetoothConnection connection;

  List<_Message> messages = List<_Message>();
  String _messageBuffer = '';

  final TextEditingController textEditingController =
      new TextEditingController();
  final ScrollController listScrollController = new ScrollController();

  bool isConnecting = true;
  bool get isConnected => connection != null && connection.isConnected;

  bool isDisconnecting = false;

 
  Nabiz _nabiz;
  String nabizTarihi;
  DateTime today= DateTime.now();
  bool yukleniyor = true;
  List<String> nabizDegeri=[],tarih=[];
  String sonNabiz;
  String a;
  SaglikDbHelper _databaseHelper;
  List<SaglikModel> tumSaglikListesi;
  int hastalikTur=0;
  String ilkAdim,sonAdim;
  int adimFark;
  int yas;
  DateTime ilkSaat=DateTime.now();
  String iSaat;
  List<String> izinUserID=[],tokens=[];
  List<String> nabizYas=["20-60-100","25-58-97","30-57-95","35-55-92","40-54-90","45-52-87","50-51-85","55-49-82",
    "60-48-80","65-46-77","70-45-75"];
  int minNabiz,maxNabiz;
  String isim,soyisim;
  Adim _adim;
  bool bekle=false;
  bool cevap=false,cevap2=false;

  bool exist=false,kosuyorMu=false;
   Users _users;


  @override
  void initState() {
    super.initState();

    BluetoothConnection.toAddress(widget.server.address).then((_connection) {
      print('Cihaza bağlandı');
      connection = _connection;
      setState(() {
        isConnecting = false;
        isDisconnecting = false;
      });
      connection.input.listen(_onDataReceived).onDone(() {
       
        if (isDisconnecting) {
          print('bağlantı zayıf!');
        } else {
          print('uzaklıktan dolayı bağlantı kesiliyor!');
        }
        if (this.mounted) {
          setState(() {});
        }
      });
    }).catchError((error) {
      print('Hata! bağlanamadı');
      print(error);
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

    return  yukleniyor ? Center(child: CircularProgressIndicator(),)
        :Container(
         
          child: Column(
                    children: [
                     Image.asset( "img/pulse.gif", height: 70, width:120,),
                     Text(sonNabiz==null?"deger yok":sonNabiz,style: TextStyle(fontSize: 15),),
                     ],  ),
        );
    
            
  }
  void nabizText(){
    final List<Text> list = messages.map((_message) {
      return  Text(
              (text) {
            return text == '/shrug' ? '¯\\_(ツ)_/¯' : text;
          }(_message.text.trim()),
          style: TextStyle(color: Colors.white,fontSize: 20, ));
    }).toList();
    parca(list.last,list.length);
  }
 
  Future<String> parca(Text txt,int uzunluk)async{
    String deger = txt.data;
    print("parca çalıştı");
    DateTime nabizZamani= DateTime.now();
    if(nabizZamani.minute<10){
      a="${nabizZamani.hour.toString()}:0${nabizZamani.minute.toString()}";
    }else{
      a="${nabizZamani.hour.toString()}:${nabizZamani.minute.toString()}";
    };
    print("$a");
    if(deger.substring(0,5)=="NABIZ"){
      nabizDegeri.add(deger.substring(5)+" saat: "+a);
      sonNabiz = deger.substring(5);
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
    else if(deger.substring(0,1)=="1"){
    
     cevap2=true;
    }
   
  }
  void _onDataReceived(Uint8List data) async{
    
    int backspacesCounter = 0;
    data.forEach((byte) {
      if (byte == 8 || byte == 127) {
        backspacesCounter++;
      }
    });
    Uint8List buffer = Uint8List(data.length - backspacesCounter);
    int bufferIndex = buffer.length;

   
    backspacesCounter = 0;
    for (int i = data.length - 1; i >= 0; i--) {
      if (data[i] == 8 || data[i] == 127) {
        backspacesCounter++;
      } else {
        if (backspacesCounter > 0) {
          backspacesCounter--;
        } else {
          buffer[--bufferIndex] = data[i];
        }
      }
    }

    
    String dataString = String.fromCharCodes(buffer);
    int index = buffer.indexOf(13);
    if (~index != 0) {
      setState(() {
        messages.add(
          _Message(
            1,
            backspacesCounter > 0
                ? _messageBuffer.substring(
                    0, _messageBuffer.length - backspacesCounter)
                : _messageBuffer + dataString.substring(0, index),
          ),
        );
        _messageBuffer = dataString.substring(index);
      });
    } else {
      _messageBuffer = (backspacesCounter > 0
          ? _messageBuffer.substring(
              0, _messageBuffer.length - backspacesCounter)
          : _messageBuffer + dataString);
    }
    await nabizText();
  }

  void _sendMessage(String text) async {
    text = text.trim();
    textEditingController.clear();

    if (text.length > 0) {
      try {
        connection.output.add(utf8.encode(text + "\r\n"));
        await connection.output.allSent;

        setState(() {
          messages.add(_Message(clientID, text));
        });

        Future.delayed(Duration(milliseconds: 333)).then((_) {
          listScrollController.animateTo(
              listScrollController.position.maxScrollExtent,
              duration: Duration(milliseconds: 333),
              curve: Curves.easeOut);
        });
      } catch (e) {
        // Hatayı yok say, ancak durumu bildir
        setState(() {});
      }
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
  Future<void> veriGetirNabizz() async{
    final _userModel = Provider.of<UserModel>(context,listen: false);
    _nabiz= await _userModel.readNabiz(_userModel.users.userID,nabizTarihi);
  }
  ///--------------------------------------------------------------
  Future<void> veriGetirNabiz() async{/// veri ekle lazım
    final _userModel = Provider.of<UserModel>(context,listen: false);

    _userModel.readNabiz(_userModel.users.userID,nabizTarihi).then((value) {
      setState(() {
        _nabiz=value;
      });
    });
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
    Timer(Duration(minutes: 1),(){
          setState(() {
           cevap=true;
          });
        });
}
  void nabizKontrol(int n){
    print("burası njnd");
    if(n<minNabiz&&!bekle && n>20){
      hastalikKontrol(1);
      print("gridi 1");
      if(hastalikTur==2){
        print("girdi 2");
        if(n<(minNabiz-10)){
          print("girdi 3");
          for(int i=0;i<30;i++){
            _sendMessage('0');
          }
          
          dkBekle();
          bekle=true;
        }
      }else{
        print("amk");
        for(int i=0;i<30;i++){
            _sendMessage('0');
          }
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
            for(int i=0;i<30;i++){
            _sendMessage('0');
          }
            dkBekle();
            bekle=true;
          }

        }
        else{
          print("max sen");
          for(int i=0;i<30;i++){
            _sendMessage('0');
          }
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

        default:hastalikTur=0;
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

        default:hastalikTur=0;
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
