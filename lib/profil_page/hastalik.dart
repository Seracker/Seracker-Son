import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seracker/firestore_islemleri.dart';
import 'package:seracker/models/saglikModel.dart';
import 'package:seracker/utils/sagl%C4%B1kDbHelper.dart';
import 'package:seracker/viewmodel/user_model.dart';
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class SaglikBilgileriHastalik extends StatefulWidget {
  @override
  _SaglikBilgileriHastalikState createState() => _SaglikBilgileriHastalikState();
}

class _SaglikBilgileriHastalikState extends State<SaglikBilgileriHastalik> {
  String hastaliklar;
 
  var formKey = GlobalKey<FormState>();
  SaglikDbHelper _databaseHelper;
  List<SaglikModel> tumSaglikListesi;


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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Image.asset(
                  "img/seracker.png",
                  scale: 10,
                ),
              ],
            ),
          ),
          backgroundColor: Colors.grey.shade900,
        ),
        body: HastalikGovde(),
      ),
    );
    
  }
  
  Widget HastalikGovde() {
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
                      labelText: "Hastalığınızın Adını Giriniz",
                      hintText: "Hastalık",
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
                        return "Hastalığınızın adını boş bırakamazsınız!";
                      }
                    },
                    onSaved: (kaydedilecekDeger) {
                      
                      setState(
                            () {
                          hastaliklar = kaydedilecekDeger;
                        _saglikEkle(SaglikModel("1",hastaliklar));
                        
                        },
                      );
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Card(
                        color: Colors.grey.shade700,
                        child: TextButton(
                          child: Text("Hastalığı Kaydet",style: TextStyle(color: Colors.white),),
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
                itemCount: tumSaglikListesi.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
  void _saglikEkle(SaglikModel saglik) async{
   var id=await _databaseHelper.saglikEkle(saglik);
   saglik.id=id;
   if(id>0){
     setState(() {
       tumSaglikListesi.insert(0, saglik);
     });

   }
   await veriEkleSBH();
  }
  void _veriSil(){
    final _userModel = Provider.of<UserModel>(context,listen: false);
    setState(() {
      //dynamic val = FieldValue.arrayRemove([hastaliklar]);
    });
    List<String> hastaliklar=[];
    print("veri sil"+tumSaglikListesi.toString());
    tumSaglikListesi.forEach((element) {
      hastaliklar.add(element.isim);
    });
    _firestore.doc("Users/${_userModel.users.userID}/saglikBilgileri/hastalikAdi")
        .update({'hastalik': hastaliklar}).then((aa) {
      debugPrint("hastalik bilgisi silindi");
    }).catchError((e) => debugPrint("Silerken hata cıktı" + e.toString()));
  }

  void _saglikSil(int dbdenSilmeyeYarayacakID) async{

     await _databaseHelper.saglikSil(dbdenSilmeyeYarayacakID);
    await _veriSil();
   // tiklanilanOgrenciIDsi = null;
  }
  Widget _listeElemanlariniOlustur(BuildContext context, int index) {
   
    return Dismissible(
      onDismissed: (silme) {
        setState(() {
          _saglikSil(tumSaglikListesi[index].id);
          tumSaglikListesi.removeAt(index);
        });
      },
      key: UniqueKey(),
      background: Container(
        color: Colors.red,
        child: Icon(
          Icons.delete_forever_outlined,
          color: Colors.white,
        ),
      ),
      
      child: Card(
        child: ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(tumSaglikListesi[index].isim),
              Icon(Icons.medical_services),
            ],
          ),
        ),
      ),
      
    );
    
  }
  Future<void> veriEkleSBH() async{
    final _userModel = Provider.of<UserModel>(context,listen: false);
    int index;
    print(tumSaglikListesi.length.toString());
    List<String> hastaliklar=[];
    tumSaglikListesi.forEach((element) {
      hastaliklar.add(element.isim);
    });


    try{
      await veriekleSBH(_userModel.users.userID,hastaliklar);
    }catch(e){
      debugPrint("*HATA VAR**");
      debugPrint(e.toString());
    }
  }
}

