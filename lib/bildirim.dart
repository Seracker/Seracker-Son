import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:seracker/models/hatirlaticiModel.dart';
import 'package:seracker/utils/sql_dbHelper.dart';


class Bildirim extends StatefulWidget {
  @override
  _BildirimState createState() => _BildirimState();
}

class _BildirimState extends State<Bildirim> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
      DatabaseHelper _databaseHelper;
  List<Hatirlatici> tumHatirlaticiListesi;

  @override
  void initState() {
    super.initState();
    var initializationSettingsAndroid =
        AndroidInitializationSettings('kalpmin');
   
    var initSetttings = InitializationSettings(
       android: initializationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initSetttings,
        onSelectNotification: onSelectNotification);
        tumHatirlaticiListesi = List<Hatirlatici>();
    _databaseHelper = DatabaseHelper();
     _databaseHelper.tumHatirlaticilar().then((map){
        for(Map okunanMap in map){
          Hatirlatici a=Hatirlatici.fromMap(okunanMap);
              tumHatirlaticiListesi.add(a);
        }
       setState(() {

       });
     }).catchError((hata)=>print("hata:"+hata));
  }

  Future onSelectNotification(String payload) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return NewScreen(
        payload: payload,
      );
    }));
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
    
        title: new Text('Bildirim Ekranı'),
      ),
      body: new Center(
        child: Column(
          children: <Widget>[
            RaisedButton(
              onPressed: bildirimGoster,
              child: new Text(
                'Direk Bildirm Göster',
              ),
            ),
            RaisedButton(
              onPressed: iptalBildirim,
              child: new Text(
                'Bildirimleri İptal et',
              ),
            ),
            RaisedButton(
              onPressed: sureBildirim,
              child: new Text(
                'Süre ile Bildirim Göster',
              ),
            ),
            RaisedButton(
              onPressed: buyukBildirim,
              child: new Text(
                'Büyük Bildirim Göster',
              ),
            ),
            RaisedButton(
              onPressed: resimliBildirim,
              child: new Text(
                'Resimli Bildirim Göster',
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Future<void> resimliBildirim() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'media channel id',
      'media channel name',
      'media channel description',
      color: Colors.red,
      enableLights: true,
      largeIcon: DrawableResourceAndroidBitmap("kalpmin"),
      styleInformation: MediaStyleInformation(),
    );
    var platformChannelSpecifics =
        NotificationDetails(android:androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'Bildirim Başlık', 'Bildirm  İçerik', platformChannelSpecifics);
  }

  Future<void> buyukBildirim() async {
    var bigPictureStyleInformation = BigPictureStyleInformation(
        DrawableResourceAndroidBitmap("kalpmin"),
        largeIcon: DrawableResourceAndroidBitmap("kalpmin"),
        contentTitle: 'Başlık',
        htmlFormatContentTitle: true,
        summaryText: 'İçerik',
        htmlFormatSummaryText: true);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'big text channel id',
        'big text channel name',
        'big text channel description',
        styleInformation: bigPictureStyleInformation);
    var platformChannelSpecifics =
        NotificationDetails(android:androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'big text title', 'silent body', platformChannelSpecifics,
        payload: "big image notifications");
  }

  Future<void> sureBildirim() async {
    var scheduledNotificationDateTime =
        DateTime.now().add(Duration(minutes: 1));
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      '12:30',
      'İlaç saati',
      'Aspirin',
      icon: 'kalpmin',
      largeIcon: DrawableResourceAndroidBitmap('kalpmin'),
    );
    
    var platformChannelSpecifics = NotificationDetails(
       android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
        0,
        'İlaç saati',
        'Aspirin',
        scheduledNotificationDateTime,
        platformChannelSpecifics);
  }

  Future<void> iptalBildirim() async {
    await flutterLocalNotificationsPlugin.cancel(0);
  }

  bildirimGoster() async {
    var android = new AndroidNotificationDetails(
        'id', 'channel ', 'description',
        priority: Priority.high, importance: Importance.max);
    
    var platform = new NotificationDetails(android:android,);
    await flutterLocalNotificationsPlugin.show(
        0, 'Başlık', 'içerik', platform,
        payload: 'yönlendirme başlık ');
  }
}

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





/*import 'package:flutter/material.dart';
import 'package:scheduled_notifications/scheduled_notifications.dart';



class Bildirim extends StatefulWidget {
  

  @override
  _BildirimState createState() => new _BildirimState();
}

class _BildirimState extends State<Bildirim> {
  @override
  initState() {
    super.initState();
  }

  _bildirim() async {

    int notificationId = await ScheduledNotifications.scheduleNotification(
         DateTime.now().add( Duration(seconds: 5)).millisecondsSinceEpoch,
        "12:30",
        "İalç kullanım Saati!",
        "Aspirin");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(


        appBar: AppBar(
          title: Text('Bildirim Uygulaması'),
          
        ),
        body: Center(

            child: RaisedButton(

              color: Colors.deepOrange,
              onPressed: _bildirim,

              child: Text('Bildirim gönder'),
            )
        )
    );
  }
} */