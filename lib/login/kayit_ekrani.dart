import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seracker/firestore_islemleri.dart';
import 'package:seracker/models/Users.dart';
import 'package:seracker/models/kisisel_bilgilerdb.dart';
import 'package:seracker/viewmodel/user_model.dart';
FirebaseAuth _auth = FirebaseAuth.instance;
class KayitEkrani extends StatefulWidget {
  @override
  _KayitEkraniState createState() => _KayitEkraniState();
}

class _KayitEkraniState extends State<KayitEkrani> {
  String _name,_surname,_email,_tel,_tcNo,_password,_sifreTekrar,_cinsiyet="",_dogumTarihi="",_adim="0",adimTarihi;
  int _age=0;
  String ek;
  String _textIsim = "", _textSoyisim = "",_textEPosta = "",_textTelefonNo="",_textTCNo="",
  _textSifre="",_textSifreTekrar="";
  String  _kanGrubu,_boy, _kilo;
  Users _users;
  var _UID;
  KBI _infos;
  //Timestamp adimTarihi = Timestamp.now();
  DateTime today = new DateTime.now();

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
    });
  }
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    adimTarihi ="${today.year.toString()}-${today.month.toString().padLeft(2,'0')}-${today.day.toString().padLeft(2,'0')}";
    print(adimTarihi);
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
        body: Padding(
          padding: EdgeInsets.all(10),
          child: Form(
            key: formKey,
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                  child: TextFormField(
                    autovalidate: true,
                    decoration: InputDecoration(

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        gapPadding: 10,
                      ),
                      labelText: "İsminiz",
                      labelStyle: TextStyle(height: 1),
                      hintText: "İsim",
                      filled: true,
                      fillColor: Colors.grey.shade800,
                    ),
                    validator: (value) {
                      if (value.length<2)
                        return 'İsim alanı en az 2 karakter olmalıdır';
                      return null;
                      },
                    onSaved: (data) => _name=data,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                  child: TextFormField(
                    autovalidate: true,
                    decoration: InputDecoration(

                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                      labelText: "Soyisminiz",
                      labelStyle: TextStyle(height: 1),
                      hintText: "Soyisim",
                      filled: true,
                      fillColor: Colors.grey.shade800,
                    ),
                    validator: (value) {
                      if (value.length<2)
                        return 'Soyisim alanı en az 2 karakter olmalıdır';
                      return null;
                    },
                    onSaved: (data) => _surname=data,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                  child: TextFormField(
                    autovalidate: true,
                    keyboardType: TextInputType.number,
                    maxLength: 11,
                    onFieldSubmitted: (String tc) => debugPrint("tc = $tc"),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                      labelText: "T.C. Kimlik Numarası",
                      labelStyle: TextStyle(height: 1),
                      hintText: "T.C. Kimlik Numarası",
                      filled: true,
                      fillColor: Colors.grey.shade800,
                    ),
                    validator: (String girilenVeri) {
                      if (girilenVeri.length < 11)
                        return "Lütfen Geçerli Bir T.C. Kimlik Numarası Giriniz";
                      return null;
                    },
                    onSaved: (data)=> _tcNo= data,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                  child: TextFormField(
                    autovalidate: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                      labelText: "E-Posta",
                      labelStyle: TextStyle(height: 1),
                      hintText: "E-Posta",
                      filled: true,
                      fillColor: Colors.grey.shade800,
                    ),
                    validator: (value) {
                      if (!value.contains('@') || !value.contains('.com'))
                        return "Geçerli bir eposta adresi giriniz";
                      return null;
                    },
                    onSaved: (data) => _email = data,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                  child: TextFormField(
                    autovalidate: true,
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                      labelText: "Telefon",
                      labelStyle: TextStyle(height: 1),
                      hintText: "Telefon",
                      filled: true,
                      fillColor: Colors.grey.shade800,
                    ),
                    onSaved: (data) => _tel=data,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                  child: TextFormField(
                    autovalidate: true,
                    obscureText: true,
                    keyboardType: TextInputType.number,

                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                      labelText: "Şifre",
                      labelStyle: TextStyle(height: 1),
                      hintText: "Şifre",
                      filled: true,
                      fillColor: Colors.grey.shade800,
                    ),
                    validator: (value) {
                      if (value.length<6)
                        return 'Şifreniz 6 karakterden uzun olmalıdır';
                      return null;
                    },
                    onSaved: (data) => _password=data,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 2,
                      child: ElevatedButton.icon(
                        style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all(Colors.white),
                          backgroundColor: MaterialStateProperty.all(Colors.white12),
                        ),
                        onPressed: () {
                          _saveFormData();
                          kontrol();
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.check),
                        label: Text("Kaydet",style: TextStyle(color: Colors.white),),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  void kontrol()async{
    final _userModel = Provider.of<UserModel>(context,listen: false);
    var db= await FirebaseFirestore.instance.collection("Users").where("email",isEqualTo: _email).get();
    db.docs.forEach((element) {
      ek=element["email"];
    });
    if(ek==null){
      ePostaSifreKullaniciOlustur();
    }else{
      final snackBar = SnackBar(
        backgroundColor: Colors.grey.shade600,
        content: Text('Bu email adresine sahip bir kullanıcı zaten var!'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
  void ePostaSifreKullaniciOlustur () async{
    //final _userModel = Provider.of<UserModel>(context);
    try{
      UserCredential _credential = await _auth.createUserWithEmailAndPassword(email: _email, password: _password);
      User _yeniUser = _credential.user;
      await _yeniUser.sendEmailVerification();
      await veriekle(_yeniUser.uid, _name, _surname, _tcNo, _email, _tel, _password,_cinsiyet,_dogumTarihi,_age);
      await veriekleKB(_yeniUser.uid, _boy, _kilo, _kanGrubu);
      await veriekleAdim(_yeniUser.uid, _adim,adimTarihi);
      if(_auth.currentUser != null){
        debugPrint("Size bir mail gönderdik lütfen onaylayın!");
        await _auth.signOut();
        debugPrint("Kullanıcı sistemden atıldı");
      }
      debugPrint(_yeniUser.toString());
    }catch(e){
      debugPrint("*************HATA VAR****************");
      debugPrint(e.toString());
    }
  }
  _saveFormData() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();

      setState(() {
        _textIsim = _name;
        _textEPosta = _email;
        _textTCNo= _tcNo;
        _textSifre= _password;
        _textSoyisim= _surname;
        _textTelefonNo= _tel;
      });
    }
  }
}
