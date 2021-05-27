import 'package:flutter/cupertino.dart';
import 'package:seracker/izin_page.dart';
import 'package:seracker/locator.dart';
import 'package:seracker/models/Users.dart';
import 'package:seracker/models/adim.dart';
import 'package:seracker/models/izin_db.dart';
import 'package:seracker/models/kisisel_bilgilerdb.dart';
import 'package:seracker/models/nabiz.dart';
import 'package:seracker/repository/user_repository.dart';
import 'package:seracker/services/auth_base.dart';
import 'package:seracker/services/database_base.dart';
enum ViewState {Idle,Busy}
class UserModel with ChangeNotifier implements AuthBase,DBBase {
  ViewState _state = ViewState.Idle;
  UserRepository _userRepository = locator<UserRepository>();
  Users _users;
  KBI _infos;
  IzinDb _izin;
  Adim _adim;
  Nabiz _nabiz;

  Nabiz get nabiz => _nabiz;

  set nabiz(Nabiz value) {
    _nabiz = value;
  }

  Adim get adim => _adim;

  set adim(Adim value) {
    _adim = value;
  }

  IzinDb get izin => _izin;

  set izin(IzinDb value) {
    _izin = value;
  }

  KBI get infos => _infos;

  set infos(KBI value) {
    _infos = value;
  }

  Users get users => _users;

  set users(Users value) {
    _users = value;
  }

  ViewState get state => _state;

  set state(ViewState value) {
    _state = value;
    notifyListeners();
  }
  UserModel(){
    currentUser();
  }

  @override
  Future<Users> currentUser() async {
    try {
      state = ViewState.Busy;
      _users = await _userRepository.currentUser();
      print("current user"+_users.toString());
      return _users;
    } catch (e) {
      debugPrint("Viewmodeldeki current user hata " + e.toString());
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<Users> signInAnonymously() async{
    try {
      state = ViewState.Busy;
      _users = await _userRepository.signInAnonymously();
      return _users;
    } catch (e) {
      debugPrint("Viewmodeldeki Anonim hata " + e.toString());
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }


  @override
  Future<bool> signOut() async {
    try {
      state = ViewState.Busy;
      bool sonuc = await _userRepository.signOut();
      _users = null;
      return sonuc;
    } catch (e) {
      debugPrint("Viewmodeldeki signout hata " + e.toString());
      return false;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<Users> signIn(String _email, String _password) async{
    try {
      state = ViewState.Busy;
        _users = await _userRepository.signIn(_email,_password);
        print("giriş yapıldı"+_users.toString());
    } catch (e) {
      debugPrint("Viewmodeldeki SignIn hata " + e.toString());
    } finally {
      state = ViewState.Idle;
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
  Future<Users> updateUser(Users users) async{
    try {
      await _userRepository.updateUser(users);
    } catch (e) {
      debugPrint("Viewmodeldeki update user hata " + e.toString());
      return null;
    }
  }

  @override
  Future<KBI> updateInfo(KBI infos,Users users) async{
    try {
      await _userRepository.updateInfo(infos, users);
    } catch (e) {
      debugPrint("Viewmodeldeki update info hata " + e.toString());
      return null;
    }
  }

  @override
  Future<KBI> readInfo(String userID) async {
  return await _userRepository.readInfo(userID);
  }

  @override
  Future<IzinDb> readIzin(String userID,String gelenID) async{
    return await _userRepository.readIzin(userID,gelenID);
  }

  @override
  Future<IzinDb> updateIzin(IzinDb izin, Users users,String gelenID) async{
    try {
      await _userRepository.updateIzin(izin, users,gelenID);
    } catch (e) {
      debugPrint("Viewmodeldeki update izin hata " + e.toString());
      return null;
    }
  }

  @override
  Future<Adim> readAdim(String userID,String adimTarihi) async{
    return await _userRepository.readAdim(userID,adimTarihi);
  }

  @override
  Future<Adim> updateAdim(Users users,Adim _adim,String adimTarihi) async{
    try {
      await _userRepository.updateAdim(users,_adim,adimTarihi);
    } catch (e) {
      debugPrint("Viewmodeldeki update adim hata " + e.toString());
      return null;
    }
  }

  @override
  Future<Nabiz> readNabiz(String userID, String nabizTarihi) async{
    return await _userRepository.readNabiz(userID,nabizTarihi);
  }

  @override
  Future<Nabiz> updateNabiz(Users users, Nabiz nabiz, String nabizTarihi) async{
    try {
      await _userRepository.updateNabiz(users,nabiz,nabizTarihi);
    } catch (e) {
      debugPrint("Viewmodeldeki update nabiz hata " + e.toString());
      return null;
    }
  }
}