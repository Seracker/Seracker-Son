import 'dart:async';
import 'dart:io';
import 'package:seracker/models/Users.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
class DatabaseHelper{
  static DatabaseHelper _databaseHelper;
  static Database _database;
  String _userTablo ="kullanıcı";
  String _columnId = "id";
  String _columnIsim = "isim";
  String _columnSoyisim = "soyisim";
  String _columnEmail = "email";
  String _columnTcNo= "tcNo";
  String _columnTel = "tel";
  String _columnPassword = "password";
  factory DatabaseHelper(){
    if(_databaseHelper == null){
      _databaseHelper = DatabaseHelper._internal();
      print("DBHelper null di oluşturuldu");
      return _databaseHelper;
    }else{
      print("DBHelper null değildi varolan kullanildi ");
      return _databaseHelper;
    }
  }
  DatabaseHelper._internal();
  Future<Database> _getDatabase()async{
    if(_database == null){
      print("DB null di oluşturulacak");
      _database = await _initializeDatabase();
          return _database;
    }else{
      print("DB null değildi varolan kullanılacak");
      return _database;
    }
  }

  _initializeDatabase() async{
    Directory klasor = await getApplicationDocumentsDirectory();/// user/serkan
    String dbPath = join(klasor.path, "Seracker.db");/// user/serkan/Seracker.db
    print("DB path "+dbPath);
    var usersDB = openDatabase(dbPath,version: 1, onCreate: _createDB);
    return usersDB;
  }

  FutureOr<void> _createDB(Database db, int version) async{
    print("create metodu çalıştı tablo oluşturulacak");
    await db.execute("CREATE TABLE $_userTablo "
        "($_columnId INTEGER PRIMARY KEY AUTOINCREMENT, $_columnIsim TEXT ,$_columnSoyisim TEXT, $_columnTcNo INTEGER,$_columnTel INTEGER,$_columnEmail TEXT,$_columnPassword INTEGER )");
  }
  Future<int>kullaniciEkle(Users user) async{
    var db = await _getDatabase();
    var sonuc = await db.insert(_userTablo,user.toMap(),nullColumnHack: "$_columnId");
    return sonuc;
  }
  Future<List<Map<String,dynamic>>> tumKullanicilar() async{
    var db = await _getDatabase();
    var sonuc = await db.query(_userTablo,orderBy: '$_columnId DESC');
    return sonuc;
  }
  Future kullaniciGuncelle(Users user) async{
    var db = await _getDatabase();
    var sonuc = await db.update(_userTablo, user.toMap(),where: '$_columnId = ?',whereArgs: [user.userID]);
    return sonuc;
  }
  Future<int> kullaniciSil(int id) async{
    var db = await _getDatabase();
    var sonuc = await db.delete(_userTablo,where: '$_columnId = ?',whereArgs: [id]);
    return sonuc;
  }
  Future<int> tumTabloyuSil(int id) async{
    var db = await _getDatabase();
    var sonuc = await db.delete(_userTablo);
    return sonuc;
  }
}