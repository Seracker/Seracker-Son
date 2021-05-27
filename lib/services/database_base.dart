import 'package:seracker/izin_page.dart';
import 'package:seracker/models/Users.dart';
import 'package:seracker/models/adim.dart';
import 'package:seracker/models/izin_db.dart';
import 'package:seracker/models/kisisel_bilgilerdb.dart';
import 'package:seracker/models/nabiz.dart';

abstract class DBBase {
  Future<bool> saveUser(Users user);
  Future<Users> readUser(String userID);
  Future<KBI> readInfo(String userID);
  Future<Users> updateUser(Users users);
  Future<KBI> updateInfo(KBI infos,Users users);
  Future<IzinDb> updateIzin(IzinDb izin, Users users,String gelenID);
  Future<IzinDb> readIzin(String userID,String gelenID);
  Future<Adim> updateAdim(Users users,Adim adim,String adimTarihi);
  Future<Adim> readAdim(String userID,String adimTarihi);
  Future<Nabiz> updateNabiz(Users users,Nabiz nabiz,String nabizTarihi);
  Future<Nabiz> readNabiz(String userID,String nabizTarihi);
}