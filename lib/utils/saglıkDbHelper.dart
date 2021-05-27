
import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'package:seracker/models/saglikModel.dart';
import 'package:sqflite/sqflite.dart';

class SaglikDbHelper{

static SaglikDbHelper _databaseHelper;
  static Database _database;
   String _saglikTablo = "saglik";
  String _columnID = "id";
  String _columnTur="tur";
  String _columnIsim="isim";

factory SaglikDbHelper(){

   if(_databaseHelper==null){
     _databaseHelper=SaglikDbHelper._internal();
     return _databaseHelper;
   }
   else{
     return _databaseHelper;
   }

 }
 SaglikDbHelper._internal();

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
    String dbPath=join(klasor.path,"saglik.db");
    var nabizDB=openDatabase(dbPath,version: 1,onCreate:_createDB);
    return nabizDB;
        
       }
            FutureOr<void> _createDB(Database db, int version) async{
        await db.execute("CREATE TABLE $_saglikTablo ($_columnID INTEGER PRIMARY KEY AUTOINCREMENT, $_columnTur TEXT, $_columnIsim TEXT )");
  }

 Future<int> saglikEkle(SaglikModel saglik)async{
    var db=await _getDatabase();
    var sonuc=db.insert(_saglikTablo, saglik.toMap(),nullColumnHack: "$_columnID");
    return sonuc;
  }

  Future<List<Map<String,dynamic>>> tumSaglik()async{
    var db=await _getDatabase();
    var sonuc=await db.query(_saglikTablo,orderBy: '$_columnID DESC');
    return sonuc;

  }
  Future<int> saglikGuncelle(SaglikModel saglik) async{

    var db=await _getDatabase();
    var sonuc=await db.update(_saglikTablo, saglik.toMap(),where: '$_columnID = ?',whereArgs: [saglik.id]);
    return sonuc;
  }
  Future<int> saglikSil(int id) async{
    var db=await _getDatabase();
    var sonuc=await db.delete(_saglikTablo,where: '$_columnID = ?',whereArgs: [id]);
    return sonuc;
  }

  Future<int> tumTabloyuSil()async{
    var db=await _getDatabase();
    var sonuc =await db.delete(_saglikTablo);
    return sonuc;
  }





}