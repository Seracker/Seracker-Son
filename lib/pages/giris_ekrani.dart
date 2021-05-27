import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:seracker/landing_page.dart';
import 'package:seracker/login/sifremi_unuttum.dart';
import 'package:seracker/models/Users.dart';
import 'package:seracker/models/kontrolModel.dart';
import 'package:seracker/utils/kontrolDbHelper.dart';
import 'package:seracker/utils/sql_dbHelper.dart';

import 'package:seracker/viewmodel/user_model.dart';
import 'package:seracker/yukleme_ekrani.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../login/kayit_ekrani.dart';
import 'package:firebase_auth/firebase_auth.dart';



FirebaseAuth _auth = FirebaseAuth.instance;
class GirisEkrani extends StatefulWidget {
  @override
  _GirisEkraniState createState() => _GirisEkraniState();
}

class _GirisEkraniState extends State<GirisEkrani> {
  bool switchState = false;
  bool otomatikKontrol = false;
  KontrolDbHelper _databaseHelper;
  String _ePosta,_sifre ;
  var formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _databaseHelper = KontrolDbHelper();
    
    _sifre;
    _ePosta;
    _auth
        .authStateChanges()
        .listen((User user) {
      if (user == null) {
        print('Kullanıcı oturumu kapattı!');
      } else {
        print('Kullanıcı oturum açtı!');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final _userModel = Provider.of<UserModel>(context,listen: false);
    return Theme(
      data: Theme.of(context).copyWith(
        accentColor: Colors.green,
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
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(90, 30, 90, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          "img/kalp.png",
                          width: 180,
                          height: 180,
                          alignment: Alignment.center,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(50))),
                        labelText: "e-Posta",
                        labelStyle: TextStyle(height: 1),
                        hintText: "e-Posta",
                        filled: true,
                        fillColor: Colors.grey.shade800,
                      ),
                      validator: (value) {
                        if (!value.contains('@') || !value.contains('.com'))
                          return "Geçerli bir eposta adresi giriniz";
                        return null;
                      },
                      onSaved: (deger) {
                        _ePosta = deger;
                      } ,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                    child: TextFormField(
                      validator: (String girilenVeri) {
                        if (girilenVeri.length < 6) {
                          return "En az 6 karakter gereki";
                        }else{
                          return null;
                        }
                      },
                      onSaved: (deger)=> _sifre=deger,
                      keyboardType: TextInputType.number,
                      onFieldSubmitted: (String sifre) =>
                          debugPrint("Şifre = $sifre"),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(50))),
                        labelText: "Şifre",
                        labelStyle: TextStyle(height: 1),
                        hintText: "Şifre",
                        filled: true,
                        fillColor: Colors.grey.shade800,

                      ),
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Center(
                            child: RaisedButton(
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                "Giriş",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              color: Colors.green,
                              onPressed: (){
                                _girisBilgileriniOnayla();
                                ePostaSifreKullaniciGirisYap();
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> LandingPage()));
                              },
                                ///database kayıt = veriekle
                                ///kullanıcı Authentication giriş = ePostaSifreKullaniciGirisYap
                                ///kullanıcı Authentication kayıt = ePostaSifreKullaniciOlustur
                            ),
                          ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SifremiUnuttum(),
                          ),
                        );
                      },
                      child: Text(
                        "Şifremi Unuttum",
                        style: TextStyle(color: Colors.teal),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => KayitEkrani(),
                          ),
                        );
                      },
                      child: Text(
                        "Seracker Hesabım Yok",
                        style: TextStyle(color: Colors.teal),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  void _girisBilgileriniOnayla() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
    } else {
      final snackBar = SnackBar(
        backgroundColor: Colors.grey.shade600,
        content: Text('Kullanıcı Adı Veya Şifre Yanlış'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      setState(() {
        otomatikKontrol = true;
      });
    }
  }



  void ePostaSifreKullaniciGirisYap () async{
    final _userModel = Provider.of<UserModel>(context,listen: false);
    _userModel.signIn(_ePosta, _sifre);
  }
}
void sifreKurtarma(String _email) async{
  print(_email);
  try{
    await _auth.sendPasswordResetEmail(email: _email);
    debugPrint("Sıfırlama linki mailinize gönderildi");
  }catch(e){
    debugPrint("Şifre sıfırlanırken hata oluştu $e");
  }
}



