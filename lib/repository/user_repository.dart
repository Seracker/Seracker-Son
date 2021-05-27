import 'package:seracker/izin_page.dart';
import 'package:seracker/locator.dart';
import 'package:seracker/models/Users.dart';
import 'package:seracker/models/adim.dart';
import 'package:seracker/models/izin_db.dart';
import 'package:seracker/models/kisisel_bilgilerdb.dart';
import 'package:seracker/models/nabiz.dart';
import 'package:seracker/services/auth_base.dart';
import 'package:seracker/services/database_base.dart';
import 'package:seracker/services/fake_auth_service.dart';
import 'package:seracker/services/firebase_auth_service.dart';
import 'package:seracker/services/firestore_db_service.dart';
enum AppMode{DEBUG,RELEASE}
class UserRepository implements AuthBase,DBBase{
  FirebaseAuthService _firebaseAuthService = locator<FirebaseAuthService>();
  FakeAuthenticationServise _fakeAuthenticationService = locator<FakeAuthenticationServise>();
  FirestoreDBService _firestoreDBService = locator<FirestoreDBService>();
  AppMode appMode = AppMode.RELEASE;
  @override
  Future<Users> currentUser() async {

    if(appMode == AppMode.DEBUG){
      return await _fakeAuthenticationService.currentUser();
    }else{
      return await _firebaseAuthService.currentUser();
    }
  }

  @override
  Future<Users> signInAnonymously() async{
    if(appMode == AppMode.DEBUG){
      return await _fakeAuthenticationService.signInAnonymously();
    }else{
      return await _firebaseAuthService.signInAnonymously();
    }
  }

  @override
  Future<bool> signOut() async{
    if(appMode == AppMode.DEBUG){
      return await _fakeAuthenticationService.signOut();
    }else{
      return await _firebaseAuthService.signOut();
    }
  }

  @override
  Future<Users> signIn(String _email, String _password) async{
    if(appMode == AppMode.DEBUG){
      return await _fakeAuthenticationService.signIn(_email,_password);
    }else{
      return await _firebaseAuthService.signIn(_email,_password);
    }

  }

  @override
  Future<Users> readUser(String userID) {
    // TODO: implement readUser
    throw UnimplementedError();
  }

  @override
  Future<bool> saveUser(Users user) {
    // TODO: implement saveUser
    throw UnimplementedError();
  }

  @override
  Future<Users> updateUser(Users users) {
    return _firestoreDBService.updateUser(users);
  }
  @override
  Future<KBI> updateInfo(KBI infos,Users users) {
    return _firestoreDBService.updateInfo(infos,users);
  }

  @override
  Future<KBI> readInfo(String userID)async {
    return await _firestoreDBService.readInfo(userID);

  }

  @override
  Future<IzinDb> readIzin(String userID,String gelenID) async{
    return await _firestoreDBService.readIzin(userID,gelenID);
  }

  @override
  Future<IzinDb> updateIzin(IzinDb izin, Users users,String gelenID) {
    return _firestoreDBService.updateIzin(izin,users,gelenID);
  }

  @override
  Future<Adim> readAdim(String userID,String adimTarihi) async{
    return await _firestoreDBService.readAdim(userID,adimTarihi);
  }

  @override
  Future<Adim> updateAdim(Users users, Adim adim,String adimTarihi) {
    return _firestoreDBService.updateAdim(users,adim,adimTarihi);
  }

  @override
  Future<Nabiz> readNabiz(String userID, String nabizTarihi) async{
    return await _firestoreDBService.readNabiz(userID,nabizTarihi);
  }

  @override
  Future<Nabiz> updateNabiz(Users users, Nabiz nabiz, String nabizTarihi) {
    return _firestoreDBService.updateNabiz(users,nabiz,nabizTarihi);
  }
}