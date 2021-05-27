import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:seracker/models/hatirlaticiModel.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  

  static DatabaseHelper _databaseHelper;
  static Database _database;
   String _hatirlaticiTablo = "hatirlatici";
  String _columnID = "id";
  String _columnTur="tur";
  String _columnIsim="isim";
  String _columnTarih="tarih";
  String _columnSaat="saat";

 factory DatabaseHelper(){

   if(_databaseHelper==null){
     _databaseHelper=DatabaseHelper._internal();
     return _databaseHelper;
   }
   else{
     return _databaseHelper;
   }

 }

 DatabaseHelper._internal();

  Future<Database> _getDatabase() async{

    if(_database==null){
      _database=await _initializeDatabase();
            return _database;
          }
          else{
            return _database;
          }
          
        }
      
   _initializeDatabase() async {

    Directory klasor=await  getApplicationDocumentsDirectory();
    String dbPath=join(klasor.path,"seracker.db");
    var hatirlaticiDB=openDatabase(dbPath,version: 1,onCreate:_createDB);
    return hatirlaticiDB;
        
       }
    
    
      FutureOr<void> _createDB(Database db, int version) async{
        await db.execute("CREATE TABLE $_hatirlaticiTablo ($_columnID INTEGER PRIMARY KEY AUTOINCREMENT, $_columnTur TEXT, $_columnIsim TEXT, $_columnTarih TEXT, $_columnSaat TEXT )");
  }

  Future<int> hatirlaticiEkle(Hatirlatici hatirlatici)async{
    var db=await _getDatabase();
    var sonuc=db.insert(_hatirlaticiTablo, hatirlatici.toMap(),nullColumnHack: "$_columnID");
    return sonuc;
  }

  Future<List<Map<String,dynamic>>> tumHatirlaticilar()async{
    var db=await _getDatabase();
    var sonuc=await db.query(_hatirlaticiTablo,orderBy: '$_columnID DESC');
    return sonuc;

  }
  Future<int> hatirlaticiGuncelle(Hatirlatici hatirlatici) async{

    var db=await _getDatabase();
    var sonuc=await db.update(_hatirlaticiTablo, hatirlatici.toMap(),where: '$_columnID = ?',whereArgs: [hatirlatici.id]);
    return sonuc;
  }
  Future<int> hatirlaticiSil(int id) async{
    var db=await _getDatabase();
    var sonuc=await db.delete(_hatirlaticiTablo,where: '$_columnID = ?',whereArgs: [id]);
    return sonuc;
  }

  Future<int> tumTabloyuSil()async{
    var db=await _getDatabase();
    var sonuc =await db.delete(_hatirlaticiTablo);
    return sonuc;
  }
}

