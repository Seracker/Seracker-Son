import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seracker/izin_page.dart';
import 'package:seracker/models/Users.dart';
import 'package:seracker/models/izin_db.dart';
import 'package:seracker/viewmodel/user_model.dart';

class BildirimKisi extends StatefulWidget {
  final String gelenAd;
  const BildirimKisi({Key key,this.gelenAd}):super(key: key);
  @override
  _BildirimKisiState createState() => _BildirimKisiState();
}

class _BildirimKisiState extends State<BildirimKisi> {
  Users _users;
  int secilenTur = 0;
  bool yukleniyor = true;

  IzinDb _izin;
  String takipciID,takipciAd,takipciSoyad;
  List<String> tad=[];
  List<String> tsad = [];
  List<String> tid = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      await durumSorgu();
      await veriGetirB();
      await veriGetirBI(takipciID);

      setState(() {
        yukleniyor =false;
      });
    });

  }
  @override
  Widget build(BuildContext context) {
    final _userModel = Provider.of<UserModel>(context,listen: false);
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
          child: ListView(
            children: [
              SizedBox(height: 20,),
              Center(
                child: Text("Takipçi İstekleri",style: TextStyle(fontSize: 24),),
              ),
              SizedBox(height: 20,),
              ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: tad.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(10, 2, 2, 2),
                      // ignore: missing_required_param
                      child: TextButton(
                        style: ButtonStyle(
                          alignment: Alignment.topLeft,
                        ),
                        child: Container(
                          height: 60,
                            width: double.infinity,
                            child: Card(
                              elevation: 10,
                              color: Colors.white24,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(10, 0, 3, 0),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      child: Text(
                                        " "+tad[index] + " " + tsad[index],
                                        style: TextStyle(fontSize: 22,color: Colors.black),
                                        textAlign: TextAlign.left,
                                      ),
                                      width: 247,
                                    ),
                                    IconButton(icon: Icon(Icons.check,color: Colors.green,), onPressed: ()async{
                                      await FirebaseFirestore.instance
                                            .collection("Users").doc(_userModel.users.userID).collection("takipci")
                                            .doc(tid[index]).update({'durum' : 1});
                                      setState(() {
                                        tad.removeAt(index);
                                      });
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => Izin(gelenID: tid[index],),),);

                                    }),
                                    IconButton(icon: Icon(Icons.clear,color: Colors.red,), onPressed: ()async{
                                      await FirebaseFirestore.instance
                                            .collection("Users").doc(_userModel.users.userID).collection("takipci")
                                            .doc(tid[index]).update({'durum' : 2});
                                      setState(() {
                                        tad.removeAt(index);
                                      });
                                    }),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
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
  Future<void> veriGetirB() async{
    final _userModel = Provider.of<UserModel>(context,listen: false);
    setState(() {
      _users = _userModel.users;
    });

  }
  Future<void> veriGetirBI(String gelenID) async{
    final _userModel = Provider.of<UserModel>(context,listen: false);
    _userModel.readIzin(_userModel.users.userID,gelenID).then((value) {
      setState(() {
        _izin=value;
      });
    });
  }
  Future<void> veriGuncelleB() async{
    final _userModel = Provider.of<UserModel>(context,listen: false);
    setState(() {
      _userModel.izin=_izin;
    });
    print("izin = $_izin");
    await _userModel.updateIzin(_izin,_users,takipciID);
  }

  Future<void> durumSorgu() async {
    final _userModel = Provider.of<UserModel>(context,listen: false);
    var db= await FirebaseFirestore.instance
        .collection("Users").doc(_userModel.users.userID).collection("takipci").where("durum",isEqualTo: 0).get();
    db.docs.forEach((element) {
      adSoyadfromMap(element.data());
    });
    print("durumSorgu");

  }
  adSoyadfromMap(Map<String,dynamic> map){
    setState(() {
      tad.add(map["name"]);
      tsad.add(map["surname"]);
      tid.add(map["userID"]);
    });
    print(tad);
    print(tsad);
    print(tid);
  }

  istekYazdirma() {
    int i=0;
    for(i;i<tad.length;i++){
      return Card(
        child: Center(
          child: Text(
            tad[i] + " " + tsad[i],
            style: TextStyle(fontSize: 20,color: Colors.white),
      ),
        ),
      );
    };
  }

}

