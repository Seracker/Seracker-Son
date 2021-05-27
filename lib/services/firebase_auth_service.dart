import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seracker/models/Users.dart';
import 'package:seracker/models/kisisel_bilgilerdb.dart';
import 'package:seracker/services/auth_base.dart';
import 'package:seracker/services/firestore_db_service.dart';

class FirebaseAuthService implements AuthBase {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<Users> currentUser() async {
    try {
      User user = await _firebaseAuth.currentUser;
      return _userFromFirebase(user);
    } catch (e) {
      print("Hata CURRENT USER" + e.toString());
      return null;
    }
  }
  /*@override
  Future<KBI> currentUserInfo() async {
    try {
      User user = await _firebaseAuth.currentUser;
      KBI info = user;
      return _infoFromFirebase(info);
    } catch (e) {
      print("Hata CURRENT USER" + e.toString());
      return null;
    }
  }*/

  ///burası çokomelli
  Future<Users> _userFromFirebase(User users) async{
    FirestoreDBService _firestoreDBService = FirestoreDBService();
    if (users == null) return null;
    return await _firestoreDBService.readUser(users.uid);
  }
  Future<KBI> _infoFromFirebase(KBI infos) async{
    FirestoreDBService _firestoreDBService = FirestoreDBService();
    if (infos == null) return null;
    return await _firestoreDBService.readInfo(infos.userID);
  }

  @override
  Future<Users> signInAnonymously() async {
    try {
      var sonuc = await _firebaseAuth.signInAnonymously();
      return _userFromFirebase(sonuc.user);
    } catch (e) {
      print("Anonim giriş hata:" + e.toString());
      return null;
    }
  }

  @override
  Future<bool> signOut() async {
    try {
      await _firebaseAuth.signOut();
      return true;
    } catch (e) {
      print("sign out hata:" + e.toString());
      return false;
    }
  }

  @override
  Future<Users> signIn(String _email, String _password) async {
    try {
      if (_firebaseAuth.currentUser == null) {
        User _oturumAcanUser = (await _firebaseAuth.signInWithEmailAndPassword(
                email: _email, password: _password))
            .user;

        if (_oturumAcanUser.emailVerified) {
          debugPrint("Mail onaylı");
        } else {
          debugPrint("Lütfen mailinizi onaylayın ve sonra tekrar giriş yapın");
          _firebaseAuth.signOut();
        }
        return await _userFromFirebase(_oturumAcanUser);
      } else {
        debugPrint("Zaten bir oturum açılmış durumda");
        return null;
      }
    } catch (e) {
      debugPrint("*************HATA (fbauthsignin) VAR****************");
      debugPrint(e.toString());
      return null;
    }
  }
}
