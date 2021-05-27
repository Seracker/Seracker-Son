import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seracker/models/Users.dart';
import 'package:seracker/viewmodel/user_model.dart';

class HesapAyrintilari extends StatefulWidget {
  @override
  _HesapAyrintilariState createState() => _HesapAyrintilariState();
}

class _HesapAyrintilariState extends State<HesapAyrintilari> {
  bool yukleniyor = true;
  bool _enabletf = false; /// textfield ın on tap özelliğini açıp kapatmak için .
  Users _users;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await veriGetirHA();
      setState(() {
        yukleniyor = false;
      });
    });
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
                   IconButton(
                     icon: Icon(Icons.edit),
                     onPressed: (){
                       setState(() {
                         _enabletf = true;
                       });
                     },
                   ),
                 ],
              ),
            ),
            backgroundColor: Colors.grey.shade900,
          ),
          body: yukleniyor ? Center(child: CircularProgressIndicator(),)
          : Center(
            child: ListView(
              padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
              children: [
                SizedBox(
                  height: 40,
                  child: Center(
                      child: Text(
                        "Hesap Ayrıntıları",
                        style: TextStyle(color: Colors.white,fontSize: 20,),
                      )),
                ),
                Divider(
                  color: Colors.black,
                  height: 20,
                  //indent: 20,
                ),
                Card(
                  color: Colors.white10,
                  elevation: 10,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      Text(" Kullanıcı ID",style: TextStyle(fontSize: 22),),
                      SizedBox(
                        width: 200,
                        child: TextFormField(
                          style: TextStyle(fontSize: 12),
                          enabled: _enabletf,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                          initialValue: _users.userID,
                          //controller: TextEditingController()..text = _users.userID,
                          textAlign: TextAlign.end,
                          onEditingComplete: ()=> falsetf(),

                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: Colors.black,
                  height: 20,
                        //indent: 20,
                ),
                Card(
                  color: Colors.white10,
                  elevation: 10,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(" e-Posta",style: TextStyle(fontSize: 22),),
                      SizedBox(
                        width: 200,
                        child: TextField(

                          enabled: _enabletf,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                          controller: TextEditingController()..text = _users.email,
                          onChanged: (ePosta) => _users.email=ePosta,
                          textAlign: TextAlign.end,
                          onEditingComplete: ()=> falsetf(),

                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: Colors.black,
                  height: 20,
                        //indent: 20,
                ),
                Card(
                  color: Colors.white10,
                  elevation: 10,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      Text(" Telefon",style: TextStyle(fontSize: 22),),
                      SizedBox(
                        width: 200,
                          child: TextField(
                            enabled: _enabletf,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                            controller: TextEditingController()..text = _users.tel,
                            onChanged: (telefon) => _users.tel=telefon,
                            textAlign: TextAlign.end,
                            onEditingComplete: ()=> falsetf(),

                      ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: Colors.black,
                  height: 20,
                  //indent: 20,
                ),
                Card(
                  color: Colors.white10,
                  elevation: 10,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      Text(" Şifre",style: TextStyle(fontSize: 22),),
                      SizedBox(
                        width: 200,
                        child: TextField(
                          enabled: _enabletf,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                          controller: TextEditingController()..text = _users.password,
                          onChanged: (sifre) => _users.password=sifre,
                          textAlign: TextAlign.end,
                          onEditingComplete: ()=> falsetf(),

                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: Colors.black,
                  height: 20,
                  //indent: 20,
                ),
                Center(
                  child: ElevatedButton(
                    child: Text("Degişiklikleri Onayla"),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white12),
                      padding: MaterialStateProperty.all(EdgeInsets.all(10)),
                      textStyle: MaterialStateProperty.all(TextStyle(fontSize: 16)),),
                    onPressed: veriGuncelleHA,
                  ),
                ),
              ],
                  ),
            ),
        ),
    );
  }

  void falsetf() { /// güncellemeyi tamamladıktan sonra on tap özelliğini kapatmak için kullanıyoruz
    setState(() {
      _enabletf = false;
    });
  }
  Future<void> veriGetirHA() async{
    final _userModel = Provider.of<UserModel>(context,listen: false);
    setState(() {
      _users = _userModel.users;
    });

  }
  Future<void> veriGuncelleHA() async{
    final _userModel = Provider.of<UserModel>(context,listen: false);
    setState(() {
      _userModel.users=_users;

    });
    await _userModel.updateUser(_users);
  }

}
