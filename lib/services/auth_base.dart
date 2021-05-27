import 'package:seracker/models/Users.dart';

abstract class AuthBase{
  Future<Users> currentUser();
  Future<Users> signInAnonymously();
  Future<bool> signOut();
  Future<Users> signIn(String _email ,String _password);
}