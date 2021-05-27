import 'dart:async';
import 'dart:io';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:seracker/models/Users.dart';
import 'package:seracker/models/kisisel_bilgilerdb.dart';
import 'package:seracker/viewmodel/user_model.dart';

class KisiselBilgiler extends StatefulWidget {
  @override
  _KisiselBilgilerState createState() => _KisiselBilgilerState();
}

class _KisiselBilgilerState extends State<KisiselBilgiler> {
  Text txt ;
  bool yukleniyor = true;
  bool _enabletf = false; /// textfield ın on tap özelliğini açıp kapatmak için .
  Users _users;
  KBI _infos;
  String birthDate = "";
  int age = 0;
  TextStyle valueTextStyle=TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 20,
  );
  TextStyle textTextStyle=TextStyle(

    fontSize: 16,
  );
  TextStyle buttonTextStyle=TextStyle(
    color: Colors.white,
    fontSize: 12,
  );
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await veriGetirKBU();
      await veriGetirKB();
      await baslatici();
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
                      "Kişisel Bilgiler",
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
                    Text(" İsim",style: TextStyle(fontSize: 22),),
                    SizedBox(
                      width: 200,
                      child: TextFormField(
                        enabled: _enabletf,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                        controller: TextEditingController()..text = _users.name,
                        textAlign: TextAlign.end,
                        onEditingComplete: ()=> falsetf(),
                        onChanged: (isim) => _users.name=isim,
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
                    Text(" Soyisim",style: TextStyle(fontSize: 22),),
                    SizedBox(
                      width: 200,
                      child: TextFormField(

                        enabled: _enabletf,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                        controller: TextEditingController()..text = _users.surname,
                        textAlign: TextAlign.end,
                        onEditingComplete: ()=> falsetf(),
                        onChanged: (soyisim) => _users.surname=soyisim,
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
                    Text(" Boy",style: TextStyle(fontSize: 22),),
                    SizedBox(
                      width: 200,
                      child: TextFormField(
                        enabled: _enabletf,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                        //initialValue:_infos==null?"0":_infos.boy.toString() ,
                        controller: TextEditingController()..text = _infos==null?"0":_infos.boy.toString(),
                        textAlign: TextAlign.end,
                        onEditingComplete: ()=> falsetf(),
                        onChanged: (boy) => _infos.boy=int.parse(boy ?? '0'),
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
                    Text(" Kan Grubu",style: TextStyle(fontSize: 22),),
                    SizedBox(
                      width: 200,
                      child: TextFormField(
                        enabled: _enabletf,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                        //initialValue:_infos==null?"":_infos.kanGrubu,
                        controller: TextEditingController()..text = _infos==null?"":_infos.kanGrubu,
                        textAlign: TextAlign.end,
                        onEditingComplete: ()=> falsetf(),
                        onChanged: (kanGrubu) => _infos.kanGrubu=kanGrubu,
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
                    Text(" T.C.K.N.",style: TextStyle(fontSize: 22),),
                    SizedBox(
                      width: 200,
                      child: TextFormField(
                        enabled: _enabletf,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                        controller: TextEditingController()..text = _users.tcNo,
                        textAlign: TextAlign.end,
                        onEditingComplete: ()=> falsetf(),
                        onChanged: (tcNo) => _users.tcNo=tcNo,
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
                    Text(" Kilo",style: TextStyle(fontSize: 22),),
                    SizedBox(
                      width: 200,
                      child: TextFormField(
                        enabled: _enabletf,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                        //initialValue:_infos==null?"0":_infos.kilo.toString() ,
                        controller: TextEditingController()..text = _infos==null?"0":_infos.kilo.toString(),
                        textAlign: TextAlign.end,
                        onEditingComplete: ()=> falsetf(),
                        onChanged: (kilo) => _infos.kilo=int.parse(kilo),
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
                child: Column(
                  children: <Widget>[
                    Text(" Cinsiyet",style: TextStyle(fontSize: 22),),
                    RadioListTile<String>(value: "kadın", groupValue: _users.cinsiyet, onChanged: (deger){
                      setState(() {
                        _users.cinsiyet = deger;
                        print("secilen deger $deger");
                      });
                    },title: Text("Kadın"),selected: false,),
                    RadioListTile<String>(value: "erkek", groupValue: _users.cinsiyet, onChanged: (deger){
                      setState(() {
                        _users.cinsiyet = deger;
                        print("secilen deger $deger");
                      });
                    },title: Text("Erkek"),selected: false,),
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    (_users == null ? 0 :_users.age > -1)
                        ? Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("Doğum Tarihi: ",style: textTextStyle,),
                              Text("${_users.dogumTarihi}",style: valueTextStyle,)///
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                      ],
                    )
                        : Text("Press button to see age"),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.white12),
                        textStyle: MaterialStateProperty.all(TextStyle(fontSize: 16)),),
                      onPressed: () async {
                        DateTime birthDate = await selectDate(context, DateTime.now(),
                            lastDate: DateTime.now());
                        final df = new DateFormat('yyyy-MM-dd');
                        this._users.dogumTarihi = df.format(birthDate);
                        this._users.age = calculateAge(birthDate);
                        print("${_users.age}");
                        setState(() {
                        });
                      },

                      child: Container(
                          padding: EdgeInsets.all(16),
                          child: Text("Tarih Seç".toUpperCase(),style: buttonTextStyle,)),
                    )
                  ],
                )
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
                      onPressed: (){
                    veriGuncelleKB();
                    veriGuncelleKBU();
                  },
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
  Future<void> veriGetirKBU() async{
    final _userModel = Provider.of<UserModel>(context,listen: false);
    setState(() {
      _users = _userModel.users;
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
  Future<void> veriGuncelleKB() async{
    final _userModel = Provider.of<UserModel>(context,listen: false);
    setState(() {
      _userModel.infos=_infos;
    });
    print("infosss = $_infos");
    await _userModel.updateInfo(_infos,_users);
  }
  Future<void> veriGuncelleKBU() async{
    final _userModel = Provider.of<UserModel>(context,listen: false);
    setState(() {
      _userModel.users=_users;
    });
    await _userModel.updateUser(_users);
  }
  void baslatici() async{

    final df = new DateFormat('dd-MMM-yyyy');

  }
  calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }
  selectDate(BuildContext context, DateTime initialDateTime,
      {DateTime lastDate}) async {
    Completer completer = Completer();
    String _selectedDateInString;
    if (Platform.isAndroid)
      showDatePicker(
          context: context,
          initialDate: initialDateTime,
          firstDate: DateTime(1970),
          lastDate: lastDate == null
              ? DateTime(initialDateTime.year + 10)
              : lastDate)
          .then((temp) {
        if (temp == null) return null;
        completer.complete(temp);
        setState(() {});
      });
    else
      DatePicker.showDatePicker(
        context,
        dateFormat: 'yyyy-mm-dd',
        locale: DateTimePickerLocale.tr,
        onConfirm: (temp, selectedIndex) {
          if (temp == null) return null;
          completer.complete(temp);

          setState(() {});
        },
      );
    return completer.future;
  }
}
