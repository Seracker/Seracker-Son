class Hatirlatici{

  int _id; 
  String _tur;
  String _isim;
  String _tarih;
  String _saat;

  int get id=> _id;
  
  set id(int value){
    _id=value;
  }

  String get tur=> _tur;

  set tur(String value){
    _tur=value;
  }
 
  String get isim=> _isim;

  set isim(String value){
    _isim=value;
  }
 
  String get tarih=> _tarih;

  set tarih(String value){
    _tarih=value;
  }
 
  String get saat=> _saat;

  set saat(String value){
    _saat=value;
  }
 
  Hatirlatici(this._tur,this._isim,this._tarih,this._saat);
  Hatirlatici.withId(this._id,this._tur,this._isim,this._tarih,this._saat);

   Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>(); 
    map["id"] = _id;
    map["tur"] = _tur;
    map["isim"] = _isim;
    map["tarih"] = _tarih;
    map["saat"] = _saat;
    return map; 
  }
  Hatirlatici.fromMap(Map<String, dynamic> map) {
    this._id = map["id"];
    this._tur = map["tur"];
    this._isim = map["isim"];
    this._tarih = map["tarih"];
    this._saat = map["saat"];
  }
  @override
  String toString(){
    return 'Hatirlatici{_id:$_id,_tur:$_tur,_isim:$_isim,_tarih:$_tarih,_saat:$_saat}';
  }


}