import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:seracker/izin_page.dart';
import 'package:seracker/models/Users.dart';
import 'package:seracker/models/adim.dart';
import 'package:seracker/models/kisisel_bilgilerdb.dart';
import 'package:seracker/models/nabiz.dart';
import 'package:seracker/services/database_base.dart';
import 'package:seracker/models/izin_db.dart';
class FirestoreDBService implements DBBase{
  final FirebaseFirestore _firebaseAuth = FirebaseFirestore.instance;
  @override
  Future<bool> saveUser(Users user) async{
    await _firebaseAuth.collection("Users").doc(user.userID).set(user.toMap());
    DocumentSnapshot _okunanUser= await FirebaseFirestore.instance.doc("Users/${user.userID}").get();
    Map _okunanUserBilgileriMap = _okunanUser.data();
    Users _okunanUserBilgileriNesne = Users.fromMap(_okunanUserBilgileriMap);
    print("okunan user nesnesi : "+_okunanUserBilgileriNesne.toString());
    return true;

  }

  @override
  Future<Users> readUser(String userID) async{
    try{
      DocumentSnapshot _okunanUser= await FirebaseFirestore.instance.doc("Users/$userID").get();
    Map _okunanUserBilgileriMap = _okunanUser.data();
    Users _okunanUserBilgileriNesne = Users.fromMap(_okunanUserBilgileriMap);
    print("okunan user nesnesi : "+_okunanUserBilgileriNesne.toString());
    return _okunanUserBilgileriNesne;
    }catch(e){
      print("fdbs readUser hata verdi"+e.toString());
      return null;
    }


  }

  @override
  Future<Users> updateUser(Users users) async{
    await _firebaseAuth.collection("Users").doc(users.userID).update(users.toMap());
  }

  @override
  Future<KBI> updateInfo(KBI infos,Users users) async{
    await _firebaseAuth.collection("Users").doc(users.userID).collection("info").doc("kisiselBilgiler").set(infos.toMap());
  }

  @override
  Future<KBI> readInfo(String userID) async{
    try{
      DocumentSnapshot _okunanInfo= await FirebaseFirestore.instance.doc("Users/$userID/info/kisiselBilgiler").get();
      Map _okunanInfoBilgileriMap = _okunanInfo.data();
      KBI _okunanInfoBilgileriNesne = KBI.fromMap(_okunanInfoBilgileriMap);
      print("okunan info nesnesi : "+_okunanInfoBilgileriNesne.toString());
      return _okunanInfoBilgileriNesne;
    }catch(e){
      print("fdbs readInfo hata verdi"+e.toString());
      return null;
    }
  }

  @override
  Future<IzinDb> readIzin(String userID,String gelenID) async{
    try{
      print("Users/$userID/takipci/$gelenID");
      DocumentSnapshot _okunanIzin= await FirebaseFirestore.instance.doc("Users/$userID/takipci/$gelenID").get();
      Map _okunanIzinBilgileriMap = _okunanIzin.data();
      print("okunan izin belgeleri"+_okunanIzinBilgileriMap.toString());
      IzinDb _okunanIzinBilgileriNesne = IzinDb.fromMap(_okunanIzinBilgileriMap);
      print("okunan izin nesnesi : "+_okunanIzinBilgileriNesne.toString());
      return _okunanIzinBilgileriNesne;
    }catch(e){
      print(" fdbs readIzin hata verdi"+e.toString());
      return null;
    }
  }
  @override
  Future<IzinDb> updateIzin(IzinDb izin, Users users,String gelenID) async{
    await _firebaseAuth.collection("Users").doc(users.userID).collection("takipci").doc(gelenID).update(izin.toMap());
  }

  @override
  Future<Adim> readAdim(String userID,String adimTarihi) async{
    try{
      print("Users/$userID/adim/$adimTarihi");
      DocumentSnapshot _okunanAdim= await FirebaseFirestore.instance.doc("Users/$userID/adim/$adimTarihi").get();
      Map _okunanAdimBilgileriMap = _okunanAdim.data();
      print("okunan adim belgeleri "+_okunanAdimBilgileriMap.toString());
      Adim _okunanAdimBilgileriNesne = Adim.fromMap(_okunanAdimBilgileriMap);
      print("okunan adim nesnesi : "+_okunanAdimBilgileriNesne.toString());
      return _okunanAdimBilgileriNesne;
    }catch(e){
      print(" fdbs read Adim hata verdi "+e.toString());
      return null;
    }
  }

  @override
  Future<Adim> updateAdim(Users users, Adim adim,String adimTarihi) async{
    await _firebaseAuth.collection("Users").doc(users.userID).collection("adim").doc("$adimTarihi").update(adim.toMap());
  }

  @override
  Future<Nabiz> readNabiz(String userID, String nabizTarihi) async{
    try{
      print("Users/$userID/nabiz/$nabizTarihi");
      DocumentSnapshot _okunanNabiz= await FirebaseFirestore.instance.doc("Users/$userID/nabiz/$nabizTarihi").get();
      Map _okunanNabizBilgileriMap = _okunanNabiz.data();
      print("okunan nabiz belgeleri "+_okunanNabizBilgileriMap.toString());
      Nabiz _okunanNabizBilgileriNesne = Nabiz.fromMap(_okunanNabizBilgileriMap);
      print("okunan nabiz nesnesi : "+_okunanNabizBilgileriNesne.toString());
      return _okunanNabizBilgileriNesne;
    }catch(e){
      print(" fdbs read Nabiz hata verdi "+e.toString());
      return null;
    }
  }

  @override
  Future<Nabiz> updateNabiz(Users users, Nabiz nabiz, String nabizTarihi) async{
    print("update");
    print(nabiz.toMap());
    await _firebaseAuth.collection("Users").doc(users.userID).collection("nabiz").doc("$nabizTarihi").update(nabiz.toMap());
  }
}