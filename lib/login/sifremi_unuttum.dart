import 'package:flutter/material.dart';
import 'package:seracker/pages/giris_ekrani.dart';

class SifremiUnuttum extends StatefulWidget {
  @override
  _SifremiUnuttumState createState() => _SifremiUnuttumState();
}

class _SifremiUnuttumState extends State<SifremiUnuttum> {
  bool otomatikKontrol = false;
  var formKey = GlobalKey<FormState>();
  String _email;
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
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Form(
              key: formKey,
              child: Column(
                children: <Widget>[
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
                        _email = deger;
                      } ,
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
                            //_girisBilgileriniOnayla();
                            sifreKurtarma(_email);
                            },
                        ),
                      ),
                    ],
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
      setState(() {
        otomatikKontrol = true;
      });
    }
  }
}
