import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seracker/pages/giris_ekrani.dart';
import 'package:seracker/viewmodel/user_model.dart';
import 'package:seracker/yukleme_ekrani.dart';

class LandingPage extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    final _userModel = Provider.of<UserModel>(context);
    if(_userModel.state == ViewState.Idle){
      if(_userModel.users == null){
        return GirisEkrani();
      }else{
        return YuklemeEkrani(users: _userModel.users);
      }
    }else{
      return Scaffold(
        body: Center(child: CircularProgressIndicator(),),
      );
    }
  }
}
