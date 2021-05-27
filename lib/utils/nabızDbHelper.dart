
import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:seracker/models/nab%C4%B1zModel.dart';
import 'package:sqflite/sqflite.dart';

class NabizDbHelper{

static NabizDbHelper _databaseHelper;
  static Database _database;
   String _nabizTablo = "nabiz";
  String _columnID = "id";
  String _columnDeger="deger";

factory NabizDbHelper(){

   if(_databaseHelper==null){
     _databaseHelper=NabizDbHelper._internal();
     return _databaseHelper;
   }
   else{
     return _databaseHelper;
   }

 }
 NabizDbHelper._internal();

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
    String dbPath=join(klasor.path,"nabiz.db");
    var nabizDB=openDatabase(dbPath,version: 1,onCreate:_createDB);
    return nabizDB;
        
       }
            FutureOr<void> _createDB(Database db, int version) async{
        await db.execute("CREATE TABLE $_nabizTablo ($_columnID INTEGER PRIMARY KEY AUTOINCREMENT, $_columnDeger TEXT )");
  }

 Future<int> nabizEkle(NabizModel nabiz)async{
    var db=await _getDatabase();
    var sonuc=db.insert(_nabizTablo, nabiz.toMap(),nullColumnHack: "$_columnID");
    return sonuc;
  }

  Future<List<Map<String,dynamic>>> tumNabiz()async{
    var db=await _getDatabase();
    var sonuc=await db.query(_nabizTablo,orderBy: '$_columnID DESC');
    return sonuc;

  }
  Future<int> nabizGuncelle(NabizModel nabiz) async{

    var db=await _getDatabase();
    var sonuc=await db.update(_nabizTablo, nabiz.toMap(),where: '$_columnID = ?',whereArgs: [nabiz.id]);
    return sonuc;
  }
  Future<int> nabizSil(int id) async{
    var db=await _getDatabase();
    var sonuc=await db.delete(_nabizTablo,where: '$_columnID = ?',whereArgs: [id]);
    return sonuc;
  }

  Future<int> tumTabloyuSil()async{
    var db=await _getDatabase();
    var sonuc =await db.delete(_nabizTablo);
    return sonuc;
  }





}