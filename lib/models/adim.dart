import 'package:cloud_firestore/cloud_firestore.dart';

class Adim{
  String _adim;
  String _adimTarihi;

  String get adimTarihi => _adimTarihi;

  set adimTarihi(String value) {
    _adimTarihi = value;
  }

  String get adim => _adim;

  set adim(String value) {
    _adim = value;
  }
  Adim(this._adim);
  Map <String , dynamic> toMap(){///toMap= database e yazmak için map e çeviriyor
    var map= Map<String,dynamic>();
    map['adim']=_adim;
    map['adimTarihi']=_adimTarihi;

    return map;
  }
  Adim.fromMap(Map<String,dynamic> map){///fromMap= database den okuduğun map i objeye dönüştürüyor
    this._adim=map['adim'];
    this._adimTarihi=map['adimTarihi'];
  }
  @override
  String toString() {
    return 'Users{_adim: $_adim,_adimTarihi: $_adimTarihi';
  }
}