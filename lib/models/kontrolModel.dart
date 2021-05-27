class Kontrol{

  int _id; 
  String _durum;


  int get id=> _id;
  
  set id(int value){
    _id=value;
  }

  String get durum=> _durum;
  
  set durum(String value){
    _durum=value;
  }
 
  
 
 
  
 
  Kontrol(this._durum);
  Kontrol.withId(this._id,this._durum);

   Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>(); 
    map["id"] = _id;
    map["durum"] = _durum;
    return map; 
  }
  Kontrol.fromMap(Map<String, dynamic> map) {
    this._id = map["id"];
    this._durum = map["durum"];
    
  }
  @override
  String toString(){
    return 'Hatirlatici{_id:$_id,_durum:$_durum}';
  }


}