class SaglikModel{

  int _id; 
  String _tur;
  String _isim;
 

  int get id=> _id;
  
  set id(int value){
    _id=value;
  }

  String get isim=> _isim;

  set isim(String value){
    _isim=value;
  }
  String get tur=> _tur;

  set tur(String value){
    _tur=value;
  }
 
 
 
 
 

 
  SaglikModel(this._tur,this._isim);
  SaglikModel.withId(this._id,this._tur,this._isim);

   Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>(); 
    map["id"] = _id;
    map["tur"] = _tur;
    map["isim"] = _isim;
   
    return map; 
  }
  SaglikModel.fromMap(Map<String, dynamic> map) {
    this._id = map["id"];
    this._tur = map["tur"];
    this._isim = map["isim"];
   
  }
  @override
  String toString(){
    return 'Hatirlatici{_id:$_id,_tur:$_tur,_isim:$_isim}';
  }


}