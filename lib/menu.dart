import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seracker/ayarlar.dart';



import 'package:seracker/hastane.dart';
import 'package:seracker/models/Users.dart';
import 'package:seracker/pages/giris_ekrani.dart';
import 'package:seracker/pages/hastal%C4%B1kListe.dart';
import 'package:seracker/viewmodel/user_model.dart';


import 'bluetooth.dart';
import 'models/kontrolModel.dart';
import 'utils/kontrolDbHelper.dart';
FirebaseAuth _auth = FirebaseAuth.instance;

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  bool yukleniyor= true;
   KontrolDbHelper _databaseHelper;
  List<Kontrol> kontrolDeger;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    kontrolDeger = List<Kontrol>();
    _databaseHelper = KontrolDbHelper();
    _databaseHelper.tumKontrol().then((map){
        for(Map okunanMap in map){
          Kontrol a=Kontrol.fromMap(okunanMap);
        
              kontrolDeger.add(a);
              
          
          
        }
       
     }).catchError((hata)=>print("hata:"+hata));
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await veriGetir();
      setState(() {
        yukleniyor =false;
      });
    });

  }
  @override
  Widget build(BuildContext context) {
    final _userModel = Provider.of<UserModel>(context,listen: false);
    return yukleniyor ? Center(child: CircularProgressIndicator(),)
        : Drawer(
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountEmail:  Text(""),
            accountName: Text(_userModel.users.name+" "+_userModel.users.surname,
              style: TextStyle(fontSize: 20),),
            currentAccountPicture: Image.asset(
              "img/user.png",
              height: 100,
              width: 100,
            ),
          ),
          Expanded(
            child: ListView(
              children: <Widget>[
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Hastane()));
                  },
                  splashColor: Colors.cyan,
                  child: ListTile(
                    leading: Icon(Icons.medical_services),
                    title: Text("Ezcaneler"),
                  ),
                ),
                InkWell(
                  onTap: () {
                    print(kontrolDeger[0].durum);
                   if(kontrolDeger[0].durum=="0"){
                     
                        allert();
                    }
                    else{
                      Navigator.push(context,
                       MaterialPageRoute(builder: (context) => Bluetooth()));
                   
                    }
                    
           
                  },
                  splashColor: Colors.cyan,
                  child: ListTile(
                    leading: Icon(Icons.bluetooth_connected),
                    title: Text("Seracker'a Ba??lan"),
                  ),
                ),
                
                InkWell(
                  onTap: () {
                    _cikisYap();
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>GirisEkrani()));
                  },
                  splashColor: Colors.cyan,
                  child: ListTile(
                    leading: Icon(Icons.exit_to_app_sharp),
                    title: Text("????k????"),
                    ///????k???? i??lemi
                    ///   Future<void> signOut() async {
                    //     await firebaseAuth.signOut();
                    //   }
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
 
  Future <void> durumGuncelle(Kontrol kontrol)async{
    print("durum g??ncellendi");
    await _databaseHelper.kontrolGuncelle(kontrol);
    kontrolDeger[0].durum="1";

  }
  void allert(){
    showDialog(context: context,
    barrierDismissible: false,
     builder: (BuildContext context){
       return AlertDialog(

          title: Text("Uyar??!"),
          content: Text("Nab??z uyar?? sistemlerinin daha iyi ??al????abilmesi i??in l??tfen HASTALIK Ekleyiniz!"),
          
          actions: [
            MaterialButton(
              child: Text("TAMAM"),
              shape: StadiumBorder(),
              minWidth: 100,
              color: Colors.green.shade600,
              onPressed: ()async{
                await durumGuncelle(Kontrol.withId(kontrolDeger[0].id, "1"));
                Navigator.of(context).pop();
                Navigator.push(context,
                       MaterialPageRoute(builder: (context) => HastalikListe()));
                
            }),
            MaterialButton(
              child: Text("??ptal"),
              shape: StadiumBorder(),
              minWidth: 100,
              onPressed: (){
                Navigator.of(context).pop();
                      

            })
            
          ],



       );

     });
  }
  void _cikisYap() async {
    if (_auth.currentUser != null) {
      await _auth.signOut();
    } else {
      debugPrint("Zaten oturum a??m???? bir kullan??c?? yok");
    }
  }
  Future<void> veriGetir() async{
    final _userModel = Provider.of<UserModel>(context,listen: false);
    setState(() {
      Users _users = _userModel.users;
    });
  }
}
