import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:seracker/models/Users.dart';
import 'package:seracker/models/hatirlaticiModel.dart';
import 'package:seracker/pages/bildirim_izin.dart';
import 'package:seracker/pages/bildirim_kisi.dart';
import 'package:seracker/pages/hatirlaticilar.dart';
import 'package:seracker/profil_ekrani.dart';
import 'package:seracker/utils/sql_dbHelper.dart';
import 'package:seracker/viewmodel/user_model.dart';
import 'bildirim.dart';
import 'pages/ana_sayfa.dart';
import 'menu.dart';
import 'pages/ortak_paylasim.dart';

FirebaseAuth auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
class YuklemeEkrani extends StatefulWidget {
  final Users users;

  const YuklemeEkrani({Key key, this.users}) : super(key: key);

  @override
  _YuklemeEkraniState createState() => _YuklemeEkraniState();
}

class _YuklemeEkraniState extends State<YuklemeEkrani> {
  String tokenn;
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin fltNotification;
  int secilenMenuItem = 0;
  List<Widget> tumSayfalar;
  AnaSayfa sayfaAna;
  OrtakPaylasim sayfaOrtak;
  ProfilEkrani sayfaProfil;

  DatabaseHelper _databaseHelper;
  List<Hatirlatici> tumHatirlaticiListesi;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
      
  Future onSelectNotification(String payload) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return NewScreen(
        payload: payload,
      );
    }));
    /*Navigator.push(context,MaterialPageRoute(builder:
        (context) => BildirimIzin(gelenToken: tokenn,)));*/
  }

  
  void initState() {
    notitficationPermission();
    initMessaging();
    super.initState();
    
    sayfaAna = AnaSayfa(bluetoothDurum: false,);
    sayfaOrtak = OrtakPaylasim();
    sayfaProfil = ProfilEkrani();
    var initializationSettingsAndroid =
        AndroidInitializationSettings('kalpmin');
   
    var initSetttings = InitializationSettings(
       android: initializationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initSetttings,
        onSelectNotification: onSelectNotification);

    ///sayfaKisilerim = Kisilerim();
    tumSayfalar = [sayfaAna, sayfaProfil, sayfaOrtak];
    tumHatirlaticiListesi = List<Hatirlatici>();
    _databaseHelper = DatabaseHelper();
     _databaseHelper.tumHatirlaticilar().then((map){
        for(Map okunanMap in map){
          Hatirlatici a=Hatirlatici.fromMap(okunanMap);
              tumHatirlaticiListesi.add(a);
        }
       setState(() {});
     }).catchError((hata)=>print("hata:"+hata));
     zamanHesapla();

    /*messaging.onTokenRefresh.listen((newToken) async{
      print("Buraya geldi token");
      var _currentuser = await FirebaseAuth.instance.currentUser;
      await FirebaseFirestore.instance.collection("tokens").doc(_currentuser.uid)
          .set({'token': newToken,'userID': _currentuser.uid});
      //doc("tokens/${_currentuser.uid}").set({'token': newToken});
    });*/
  }

  void getToken() async {
    var _currentuser = await FirebaseAuth.instance.currentUser;
    print(await messaging.getToken());
    tokenn = await messaging.getToken();
    await FirebaseFirestore.instance.collection("tokens").doc(_currentuser.uid)
        .set({'token': tokenn,'userID': _currentuser.uid});
    print("current ******* uid"+_currentuser.uid);
  }
  Future<String> tokenEkle ()async{
    var _currentuser = await FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance.collection("tokens").doc(_currentuser.uid)
        .set({'token': messaging.getToken().toString(),'userID': _currentuser.uid});
    print("current ******* uid"+_currentuser.uid);
}
  void zamanHesapla(){
    for(int i=0;i<tumHatirlaticiListesi.length;i++){
      String zaman=tumHatirlaticiListesi[i].saat;
      String saat=zaman.substring(0,2);
      String dk=zaman.substring(3);
      String yil=tumHatirlaticiListesi[i].tarih.substring(0,4);
      String ay=tumHatirlaticiListesi[i].tarih.substring(5,7);
      String gun=tumHatirlaticiListesi[i].tarih.substring(8);

      int ygun=int.parse(gun)-DateTime.now().day;
      int ysaat=int.parse(saat)-DateTime.now().hour;
      int ydk=int.parse(dk)-DateTime.now().minute;
      
      if(ygun>0 && ysaat<=0){
          ysaat=ysaat+24;
          ygun=ygun-1;
      }
      if(ysaat>0 && ydk<=0){
          ydk=ydk+60;
          ysaat=ysaat-1;
      }
      print("yeni gün:"+ygun.toString()+"yeni saat:"+ysaat.toString()+"yeni dk"+ydk.toString());
      if(ysaat>=0&&ygun>=0&&ydk>=1){
          sureBildirim(ygun, ysaat, ydk,tumHatirlaticiListesi[i].isim);
      }
      if(ysaat<=0||ygun<=0||ydk<=0){
        _hatirlaticiSil(tumHatirlaticiListesi[i].id);
      }
    }}

    Future<void> sureBildirim(int gun ,int saat,int dk,String isim) async {
    var scheduledNotificationDateTime =
        DateTime.now().add(Duration(days: gun,hours: saat,minutes: dk));
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      '$saat:$dk',
      'Alarm',
      '$isim',
      icon: 'kalpmin',
      largeIcon: DrawableResourceAndroidBitmap('kalpmin'),
    );
    
    var platformChannelSpecifics = NotificationDetails(
       android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
        0,
        'Alarm',
        '$isim',
        scheduledNotificationDateTime,
        platformChannelSpecifics);
  }
  void _hatirlaticiSil(int dbdenSilmeyeYarayacakID) async{
     await _databaseHelper..hatirlaticiSil(dbdenSilmeyeYarayacakID);
     // tiklanilanOgrenciIDsi = null;
  }
  @override
  Widget build(BuildContext context) {
    getToken();
    final _userModel = Provider.of<UserModel>(context,listen: false);
    return Scaffold(
      drawer: Menu(),

      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: Image.asset(
                "img/seracker.png",
                height: 190,
                width: 190,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
              child: IconButton(icon: Icon(Icons.notifications_active_outlined), onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => BildirimKisi(),),);
              }),
            )
          ],
        ),
      ),
      body: secilenMenuItem <= tumSayfalar.length - 1
          ? tumSayfalar[secilenMenuItem]
          : tumSayfalar[0],
      bottomNavigationBar: bottomNavMenu(),
      
    );
  }
  Theme bottomNavMenu() {
    return Theme(
      
      data: ThemeData(
        primaryColor: Colors.green,
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.black54,
        unselectedItemColor: Colors.white,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: 30,
            ),
            title: Text("Ana Sayfa"),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_outline,
              size: 30,
            ),
            title: Text("Profil"),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.people_alt_outlined,
              size: 30,
            ),
            title: Text("Ortak Paylaşım"),
          ),
        ],
        currentIndex: secilenMenuItem,
        
        onTap: (index) async{
          setState(() {
            secilenMenuItem = index;
            zamanHesapla();
          });
          await messaging.subscribeToTopic('sendmeNotification');
        },
      ),
    );
  }
  void initMessaging() {

    var androiInit = AndroidInitializationSettings('kalpmin');

    var iosInit = IOSInitializationSettings();

    var initSetting = InitializationSettings(android: androiInit, iOS: iosInit);

    fltNotification = FlutterLocalNotificationsPlugin();

    fltNotification.initialize(initSetting);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showNotification();
    });
  }

  void showNotification() async {
    var androidDetails =
    AndroidNotificationDetails('1', 'channelName', 'channel Description');

    var iosDetails = IOSNotificationDetails();

    var generalNotificationDetails =
    NotificationDetails(android: androidDetails, iOS: iosDetails);

    await fltNotification.show(0, 'Seracker', 'Takipçi İsteği Geldi', generalNotificationDetails,
        payload: 'Notification');
  }
  void notitficationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }
}
/*class NewScreen extends StatelessWidget {
  String payload;
  NewScreen({
    @required this.payload,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(payload),
      ),
    );
  }
}*/
class NewScreen extends StatelessWidget {
  String payload;
  NewScreen({
    @required this.payload,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(payload),
      ),
    );
  }
}
