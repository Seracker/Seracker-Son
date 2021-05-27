import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:seracker/firestore_islemleri.dart';
import 'package:seracker/models/Users.dart';
import 'package:seracker/models/adim.dart';
import 'package:seracker/models/kisisel_bilgilerdb.dart';
import 'package:seracker/pages/bildirim_izin.dart';
import 'package:seracker/pages/bildirim_kisi.dart';
import 'package:seracker/pages/hatirlaticilar.dart';
import 'package:seracker/qr.dart';
import 'dart:async';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:seracker/seracker.dart';
import 'package:seracker/testt.dart';
import 'package:seracker/viewmodel/user_model.dart';
import '../CircleProgress.dart';
import 'package:pedometer/pedometer.dart';




class AnaSayfa extends StatefulWidget {
  final BluetoothDevice server;
  final bool bluetoothDurum;
  const AnaSayfa({Key key,this.server,this.bluetoothDurum}):super(key: key);
  @override
  _AnaSayfaState createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> with SingleTickerProviderStateMixin {

  AnimationController progressController;
  Animation<double> animation;
  Users _users;
  KBI _infos;
  Adim _adim;
  bool yukleniyor=true;
  String adimTarihi,at,ts,adimt,as;
  String son;
  DateTime today = new DateTime.now();
  Stream<StepCount> _stepCountStream;
 Stream<PedestrianStatus> _pedestrianStatusStream;
  String _status = '?', _steps = '0';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     initPlatformState();
    var animationController = AnimationController(vsync: this,duration: Duration(milliseconds: 1000));
    progressController = animationController;
    animation = Tween<double>(begin: 0,end: 80).animate(progressController)..addListener((){
    });
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      adimTarihi ="${today.year.toString()}-${today.month.toString().padLeft(2,'0')}-${today.day.toString().padLeft(2,'0')}";
      await veriGetir();
      await veriGetirKB();
      await veriGetirAdim();
      await siralama();
      await tarihSorgu();

      setState(() {
        yukleniyor = false;
      });
    });

  }
  void onStepCount(StepCount event) {
    print(event);
    setState(() {
      _steps = event.steps.toString();
      adimHesapla(_steps);
    });
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    print(event);
    setState(() {
      _status = event.status;
    });
  }
  void onPedestrianStatusError(error) {
    print('onPedestrianStatusError: $error');
    setState(() {
      _status = 'Pedestrian Status not available';
    });
    print(_status);
  }
  void onStepCountError(error) {
    print('onStepCountError: $error');
    setState(() {
      _steps = 'Null';
    });
  }
  void initPlatformState() {
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _pedestrianStatusStream
        .listen(onPedestrianStatusChanged)
        .onError(onPedestrianStatusError);

    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);

    if (!mounted) return;
  }
  final Stream<String> _bids = (() async* {
    
  })();
  @override
  Widget build(BuildContext context) {
    final _userModel = Provider.of<UserModel>(context,listen: false);
    return yukleniyor ? Center(child: CircularProgressIndicator(),)
        : StreamBuilder<String>(
      stream:_bids,
      builder: (context, snapshot) {
        return Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                  child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      height: 128,
                      width: 128,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(200),
                        border: Border.all(
                          color: Colors.black,
                          width: 9,
                        ),
                      ),
                      child: widget.bluetoothDurum  ? Container(
                        
                        
                          child:
                           ChatPage(server: widget.server,),

                        
                      ) :Column(
                        children: [
                           SizedBox(height: 35,),
                          Center(
                            child: Text("  Seracker'a \n  bağlı değil",style: TextStyle(
                            fontSize: 15, ),),
                          ),
                        ],
                      )
                      
                    ),
                    Container(
                      height: 135,
                      width: 135,
                      
                      child: Center(
              child: CustomPaint(

              foregroundPainter: CircleProgress(animation.value), 
              child: Container(
                width: 200,
                height: 200,
                
                child: GestureDetector(
                  
                    onTap: (){
                      if(animation.value == 80){
                        progressController.reverse();
                      }else {
                        progressController.forward();
                      }
                    },
                    child: Column(
                      children: [
                        SizedBox(height: 30,),
                          
                         Image.asset( "img/run.png", height: 35, width: 35,),
                         SizedBox(height: 5,),
                       Text("$_steps ",style: TextStyle(
                          fontSize: 20, ),),


                      ],
                    )),
              ),
            ),

          ),
                    ),
                  ],
                ),
              )),
              Expanded(
                  child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Text(
                        _userModel.users.name+" "+_userModel.users.surname,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Card(
                      elevation: 2,
                      color: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Container(
                        width: 300,
                        height: 140,
                        child: Column(
                           crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              
                              children: [
                              
                              
                              Image.asset( "img/weight.png", height: 40, width: 40,),
                              Text(_infos==null?"0":_infos.kilo.toString()+" kg",style: TextStyle(fontSize: 20),),
                              SizedBox(width: 25,),
                              Image.asset( "img/calendar2x.png", height: 40, width: 40,),
                              Text(_userModel.users==null?"0":_userModel.users.age.toString()+" yaş",style: TextStyle(fontSize: 20),),

                            ],),
                            SizedBox(height: 30,),

                             Row(
                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                               children: [
                               Image.asset( "img/measuring.png", height: 40, width: 40,),
                              Text(_infos==null?"0":_infos.boy.toString()+" cm",style: TextStyle(fontSize: 20),),
                              SizedBox(width: 25,),
                              Image.asset( "img/drop.png", height: 40, width: 40,),
                              Text(_infos==null?"yok":_infos.kanGrubu+"       ",style: TextStyle(fontSize: 20),),

                             ],),
                          ],
                        ),
                      ),
                    ),
                    /*   Container(decoration: BoxDecoration(

                          border: Border.all(
                            color: Colors.white,
                            width: 50,
                          ),
                          borderRadius: BorderRadius.circular(25),

                        ),
                          child:Text("Bilgiler"),)*/
                  ],
                ),
              )),
              Container(
                  child: Container(
                height: 150,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    FlatButton(
                      onPressed: () {
                       Navigator.push(
                          context,
                          MaterialPageRoute(
                           builder: (context) => QRViewExample(),
                          ),
                        );
                      },
                      child: Image.asset(
                        "img/qr-code.png",
                        height: 100,
                        width: 100,
                      ),
                      height: 100,
                      minWidth: 100,
                    ),
                    FlatButton(
                      onPressed: () {
                       Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Hatirlaticilar()));
                       },
                      child: Image.asset(
                        "img/reminders.png",
                        height: 100,
                        width: 100,
                      ),
                      //color: Colors.white,
                      height: 100,
                      minWidth: 100,
                    ),
                  ],
                ),
              )),
            ],
          ),
        );
      }
    );
  }

  Future<void> veriGetir() async{
    final _userModel = Provider.of<UserModel>(context,listen: false);
    setState(() {
      Users _users = _userModel.users;
    });
  }
  Future<void> veriGetirKB() async{
    final _userModel = Provider.of<UserModel>(context,listen: false);

    _userModel.readInfo(_userModel.users.userID).then((value) {
      setState(() {
        _infos=value;
      });
    });
  }
  Future<void> veriGuncelleAdim() async{
    final _userModel = Provider.of<UserModel>(context,listen: false);
    setState(() {
      _userModel.adim=_adim;
    });
    print("adim = $_adim");
    await _userModel.updateAdim(_userModel.users,_adim,adimTarihi);
  }
  Future<void> veriGetirAdim() async{
    final _userModel = Provider.of<UserModel>(context,listen: false);
    _userModel.readAdim(_userModel.users.userID,adimTarihi).then((value) {
      setState(() {
        _adim=value;
      });
    });
  }
  void adimHesapla(String yeniAdim)async{
    print("yeni adim $yeniAdim");
    var ad= _adim==null?"0":_adim.adim;
      print("adim hesapla "+_adim.adim);
      print("adim if dışı ${_adim.adim}");
    if(int.parse(yeniAdim)>int.parse(ad)){
      _adim.adim=yeniAdim;
      print("adim if içi ${_adim.adim}");
      //_adim.adimTarihi=Timestamp.now();
      await veriGuncelleAdim();
    }
  }
  Future<void>siralama()async{
    final _userModel = Provider.of<UserModel>(context,listen: false);
    var db = await FirebaseFirestore.instance
    .collection("Users").doc(_userModel.users.userID).collection("adim").orderBy("adimTarihi").limitToLast(1).get();
    db.docs.forEach((element) {
      son=element["adimTarihi"];
    });
  }

  void tarihHesapla(String eskiTarih)async{
    var ad= _adim==null?"0":_adim.adim;
    final _userModel = Provider.of<UserModel>(context,listen: false);
    String yeniTarih ="${today.year.toString()}-${today.month.toString().padLeft(2,'0')}-${today.day.toString().padLeft(2,'0')}";
    if(eskiTarih != yeniTarih){
      veriekleAdim(_userModel.users.userID, ad, yeniTarih);///yeniTarih olacak
      print("if içi");
    }
  }
  Future<void> tarihSorgu()async{
    final _userModel = Provider.of<UserModel>(context,listen: false);
    var db = await FirebaseFirestore.instance
        .collection("Users").doc(_userModel.users.userID).collection("adim").where("adimTarihi",isEqualTo: son).get();
    db.docs.forEach((element) {
      ts=element['adimTarihi'];
    });
    print("tarih sorgu");
    tarihHesapla(ts);
  }
}
