import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:seracker/models/hatirlaticiModel.dart';
import 'package:seracker/utils/sql_dbHelper.dart';

class Ilac extends StatefulWidget {
  @override
  _IlacState createState() => _IlacState();
}

class _IlacState extends State<Ilac> {

  String hatirlaticiIgne;
  DateTime secilenTarih = DateTime.now();
  TimeOfDay secilenSaat = TimeOfDay.fromDateTime(DateTime.now());
 
  DatabaseHelper _databaseHelper;
  List<Hatirlatici> tumHatirlaticiListesi;
  var _controller = TextEditingController();
   var _scaffoldKey = GlobalKey<ScaffoldState>();
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
      
  Future onSelectNotification(String payload) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return NewScreen(
        payload: payload,
      );
    }));}

  var formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   
    tumHatirlaticiListesi = List<Hatirlatici>();
    _databaseHelper = DatabaseHelper();
     _databaseHelper.tumHatirlaticilar().then((map){
        for(Map okunanMap in map){
          Hatirlatici a=Hatirlatici.fromMap(okunanMap);
          if(a.tur=="1"){
              tumHatirlaticiListesi.add(a);
          }
          
        }
       setState(() {

       });
     }).catchError((hata)=>print("hata:"+hata));
     var initializationSettingsAndroid =
        AndroidInitializationSettings('kalpmin');
   
    var initSetttings = InitializationSettings(
       android: initializationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initSetttings,
        onSelectNotification: onSelectNotification);
        zamanHesapla();
  
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
      print("yeni g??n:"+ygun.toString()+"yeni saat:"+ysaat.toString()+"yeni dk"+ydk.toString());
      
      if(ysaat>=0&&ygun>=0&&ydk>=1){
          sureBildirim(ygun, ysaat, ydk,tumHatirlaticiListesi[i].isim);
      }
      if(ysaat<=0&&ygun<=0&&ydk<=0){
        _hatirlaticiSil(tumHatirlaticiListesi[i].id);
        
      }
      
    }}
    Future<void> sureBildirim(int gun ,int saat,int dk,String isim) async {
    var scheduledNotificationDateTime =
        DateTime.now().add(Duration(days: gun,hours: saat,minutes: dk));
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      '$saat:$dk',
      '$isim',
      'Alarm',
      icon: 'kalpmin',
      largeIcon: DrawableResourceAndroidBitmap('kalpmin'),
    );
    
    var platformChannelSpecifics = NotificationDetails(
       android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
        0,
        '$isim',
        'Alarm',
        scheduledNotificationDateTime,
        platformChannelSpecifics);
        
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
        key : _scaffoldKey,
        body: HatirlaticiGovde(),
      ),
    );
  }

  Widget HatirlaticiGovde() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            color: Colors.grey.shade600,
            child: Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                      labelStyle: TextStyle(color: Colors.white),
                      hintStyle: TextStyle(color: Colors.black),
                      labelText: "Hat??rlat??lacak ilac?? giriniz",
                      hintText: "Hat??rlat??lacak ilac?? giriniz",
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 2,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        borderSide: BorderSide(color: Colors.white, width: 2),
                      ),
                    ),
                    validator: (girilenDeger) {
                      if (girilenDeger.length > 0) {
                        return null;
                      } else {
                        return "??la?? Ad?? Bo?? Olamaz";
                      }
                    },
                    onSaved: (kaydedilecekDeger) {
                      hatirlaticiIgne = kaydedilecekDeger;
                      setState(
                        () {
                          String sct=secilenTarih.toString();
                          String scs=secilenSaat.toString();
                        _hatirlaticiEkle(Hatirlatici("1",hatirlaticiIgne, sct.substring(0,10),scs.substring(10,15)));
                        },
                      );
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Card(
                        color: Colors.grey.shade700,
                        child: FlatButton(
                          child: Text("Tarihi ve saati se??"),
                          onPressed: () async {
                            secilenTarih = await tarihSec(context);

                            if (secilenTarih != null) {
                              secilenSaat = await saatSec(context);
                            }

                            if (secilenTarih != null && secilenSaat != null) {
                              setState(() {
                                if (formKey.currentState.validate()) {
                                  formKey.currentState.save();
                                }
                                //Durumu g??ncelleyelim ki se??ilen tarihler g??z??ks??n
                              });
                            }
                          },
                        ),
                      ),
                      Card(
                        color: Colors.grey.shade700,
                        child: TextButton(
                          child: Text("Hat??rlat??c?? Olu??tur",style: TextStyle(color: Colors.white),),
                          onPressed: () {
                            if (formKey.currentState.validate()) {
                              formKey.currentState.save();
                              
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.grey.shade700,
              child: ListView.builder(
                shrinkWrap: true,
                itemBuilder: _listeElemanlariniOlustur,
                itemCount: tumHatirlaticiListesi.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
  void _hatirlaticiEkle(Hatirlatici hatirlatici) async{
   var id=await _databaseHelper.hatirlaticiEkle(hatirlatici);
   hatirlatici.id=id;
   if(id>0){
     setState(() {
       tumHatirlaticiListesi.insert(0, hatirlatici);
     });

   }
  }
  void _hatirlaticiSil(int dbdenSilmeyeYarayacakID) async{

    await _databaseHelper.hatirlaticiSil(dbdenSilmeyeYarayacakID);
    
   // tiklanilanOgrenciIDsi = null;
  }

  Future<TimeOfDay> saatSec(BuildContext context) {
    return showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
  }

  Future<DateTime> tarihSec(BuildContext context) {
    return showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      initialDate: DateTime.now(),
      lastDate: DateTime(2023),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.dark(),
          child: child,
        );
      },
    );
  }

  Widget _listeElemanlariniOlustur(BuildContext context, int index) {
    zamanHesapla();
    return Dismissible(
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          final bool res = await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Text(
                      "Bu Hat??rlat??c??y?? Silmek ??stedi??inize Emin misiniz ?:  '${tumHatirlaticiListesi[index].isim}'"),
                  actions: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Card(
                          color: Colors.grey.shade600,
                          child: FlatButton(
                            child: Text(
                              "??ptal",
                              style: TextStyle(color: Colors.black),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                        Card(
                          color: Colors.grey.shade600,
                          child: FlatButton(
                            child: Text(
                              "Sil",
                              style: TextStyle(color: Colors.red),
                            ),
                            onPressed: () {
                              // TODO: Delete the item from DB etc..
                              setState(() {
                                _hatirlaticiSil(tumHatirlaticiListesi[index].id);
                                tumHatirlaticiListesi.removeAt(index);
                                 
                              });
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                );
              });
          return res;
        } else {
          return null;
        }
      },
      onDismissed: (silme) {
        setState(() {
          
          tumHatirlaticiListesi.removeAt(index);
        });
      },
      key: UniqueKey(),
      background: sagaKaydir(),
      secondaryBackground: solaKaydir(),
      child: Card(
         child: ListTile(
          title: Text(tumHatirlaticiListesi[index].isim),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                     (tumHatirlaticiListesi[index].tarih) +
                  " Saat " +
                  tumHatirlaticiListesi[index].saat 
                  
            ),
              Icon(Icons.access_alarm_rounded),
            ],
          ),
        ),
      ),
    );
  }
}


Widget solaKaydir() {
  return Container(
    color: Colors.red,
    child: Align(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Center(
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          Text(
            " Sil",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.right,
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
      alignment: Alignment.centerRight,
    ),
  );
}
Widget sagaKaydir() {
  return Container(
    color: Colors.green,
    child: Align(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Image.asset("img/calendar_edit.png",scale: 4,color: Colors.white,),
          Text(
            "   D??zenle",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.left,
          ),
        ],
      ),
      alignment: Alignment.centerLeft,
    ),
  );
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
