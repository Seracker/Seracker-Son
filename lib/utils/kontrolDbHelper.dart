
import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:seracker/models/kontrolModel.dart';
import 'package:sqflite/sqflite.dart';

class KontrolDbHelper{

static KontrolDbHelper _databaseHelper;
  static Database _database;
   String _kontrolTablo = "kontrol";
  String _columnID = "id";
  String _columnDurum="durum";

factory KontrolDbHelper(){

   if(_databaseHelper==null){
     _databaseHelper=KontrolDbHelper._internal();
     return _databaseHelper;
   }
   else{
     return _databaseHelper;
   }

 }
 KontrolDbHelper._internal();

  Future<Database> _getDatabase() async{

    if(_database==null){
      _database=await _initializeDatabase();
            kontrolEkle(Kontrol("0"));
            return _database;
           
          }
          else{
            return _database;
          }
          
        }
    _initializeDatabase() async {

    Directory klasor=await  getApplicationDocumentsDirectory();
    String dbPath=join(klasor.path,"kontrol.db");
    var nabizDB=openDatabase(dbPath,version: 1,onCreate:_createDB);
    return nabizDB;
        
       }
            FutureOr<void> _createDB(Database db, int version) async{
        await db.execute("CREATE TABLE $_kontrolTablo ($_columnID INTEGER PRIMARY KEY AUTOINCREMENT, $_columnDurum TEXT )");
  }

 Future<int> kontrolEkle(Kontrol kontrol)async{
    var db=await _getDatabase();
    var sonuc=db.insert(_kontrolTablo, kontrol.toMap(),nullColumnHack: "$_columnID");
    return sonuc;
  }

  Future<List<Map<String,dynamic>>> tumKontrol()async{
    var db=await _getDatabase();
    var sonuc=await db.query(_kontrolTablo,orderBy: '$_columnID DESC');
    
    return sonuc;

  }
  Future<int> kontrolGuncelle(Kontrol kontrol) async{

    var db=await _getDatabase();
    var sonuc=await db.update(_kontrolTablo, kontrol.toMap(),where: '$_columnID = ?',whereArgs: [kontrol.id]);
    return sonuc;
  }
  Future<int> kontrolSil(int id) async{
    var db=await _getDatabase();
    var sonuc=await db.delete(_kontrolTablo,where: '$_columnID = ?',whereArgs: [id]);
    return sonuc;
  }

  Future<int> tumTabloyuSil()async{
    var db=await _getDatabase();
    var sonuc =await db.delete(_kontrolTablo);
    return sonuc;
  }





}