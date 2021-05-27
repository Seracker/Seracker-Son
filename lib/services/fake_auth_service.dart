import 'package:seracker/models/Users.dart';
import 'package:seracker/services/auth_base.dart';

class FakeAuthenticationServise implements AuthBase{
  @override
  Future<Users> currentUser() {
    // TODO: implement currentUser
    throw UnimplementedError();
  }

  @override
  Future<Users> signInAnonymously() {
    // TODO: implement signInAnonymously
    throw UnimplementedError();
  }

  @override
  Future<bool> signOut() {
    // TODO: implement singOut
    throw UnimplementedError();
  }

  @override
  Future<Users> signIn(String _ePosta, String _sifre) {
    // TODO: implement signIn
    throw UnimplementedError();
  }

}