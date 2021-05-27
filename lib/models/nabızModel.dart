class NabizModel{

  int _id; 
  String _deger;
 

  int get id=> _id;
  
  set id(int value){
    _id=value;
  }

  String get deger=> _deger;

  set deger(String value){
    _deger=value;
  }
 
 
 
 

 
  NabizModel(this._deger);
  NabizModel.withId(this._id,this._deger);

   Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>(); 
    map["id"] = _id;
    map["deger"] = _deger;
   
    return map; 
  }
  NabizModel.fromMap(Map<String, dynamic> map) {
    this._id = map["id"];
    this._deger = map["deger"];
   
  }
  @override
  String toString(){
    return 'Hatirlatici{_id:$_id,_deger:$_deger}';
  }


}