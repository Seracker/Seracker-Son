


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seracker/models/saglikModel.dart';
import 'package:seracker/utils/sagl%C4%B1kDbHelper.dart';
import 'package:seracker/viewmodel/user_model.dart';
import 'package:seracker/firestore_islemleri.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;


class HastalikListe extends StatefulWidget {
  final String gelenAd;
  const HastalikListe({Key key,this.gelenAd}):super(key: key);
  @override
  _HastalikListeState createState() => _HastalikListeState();
}

class _HastalikListeState extends State<HastalikListe> {

  List<String> hastaliklar=[
    "Tifo",
    "Kalp Yetmezliği",
    "Tiroit",
    "Guatr",
    "Endokardit Enfeksiyon",
    "Dilate kardiyomiyopat",
    "Kalp delikleri",
    "Koroner damar yetmezliği",
    "uyku apnesi"
  ];
  List<String> hastalik=[];
  String has;
 
  var formKey = GlobalKey<FormState>();
  SaglikDbHelper _databaseHelper;
  List<SaglikModel> tumSaglikListesi;
  

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
        body:  Center(
          child: ListView(
            children: [
              SizedBox(height: 20,),
              Center(
                child: Text("Hastalıklar",style: TextStyle(fontSize: 24),),
              ),
              SizedBox(height: 20,),
              ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: hastaliklar.length,
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
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      child: Text(
                                        hastaliklar[index] ,
                                        style: TextStyle(fontSize: 22,color: Colors.black),
                                        textAlign: TextAlign.left,
                                      ),
                                      width: 247,
                                    ),
                                    IconButton(icon: Icon(Icons.check,color: Colors.green,), onPressed: ()async{
                                      
                                      setState((){
                                       _saglikEkle(SaglikModel("1",hastaliklar[index]), index);
                                       final snackBar = SnackBar(
                                       content: Text(hastaliklar[index]+' Eklendi'),
                                       duration: Duration(milliseconds: 750),
                                       backgroundColor: Colors.grey,);
                                   ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                       
                                      
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
  void _saglikEkle(SaglikModel saglik,int index) async{
  await _databaseHelper.saglikEkle(saglik);
  print("index"+index.toString());
  String a=hastaliklar[index];
  hastalik.add(a);
  await veriEkleSBH();
  

   }
   
  Future<void> veriEkleSBH() async{
    final _userModel = Provider.of<UserModel>(context,listen: false);
    
    
    List<String> has=[];
    hastalik.forEach((element) {
      has.add(element);
    });


    try{
      await veriekleSBH(_userModel.users.userID,has);
      
    }catch(e){
      debugPrint("*HATA VAR**");
      debugPrint(e.toString());
    }
  }

  
  }

 
   



