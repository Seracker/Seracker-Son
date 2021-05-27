class KBI{///Kişisel Bilgiler İnfo

  int _boy,_kilo;
  String _kanGrubu;
  String _userID;


  String get userID => _userID;

  set userID(String value) {
    _userID = value;
  }

  int get boy => _boy;

  set boy(int value) {
    _boy = value;
  }
  get kilo => _kilo;

  set kilo(value) {
    _kilo = value;
  }

  String get kanGrubu => _kanGrubu;

  set kanGrubu(String value) {
    _kanGrubu = value;
  }
  KBI(this._boy,this._kilo,this._kanGrubu);

  Map<String,dynamic> toMap(){
    var map=Map<String,dynamic>();
    map['boy']=_boy ?? 0;
    map['kilo']=_kilo ?? 0;
    map['kanGrubu']=_kanGrubu ?? '';
    //map['kilo']=_kilo ?? '';
    //map['boy']=_boy ?? '';
    //map['kanGrubu']=_kanGrubu ?? '';
    return map;
  }

  KBI.fromMap(Map<String,dynamic> map){
    this._boy = map['boy'] ?? 0;
    this._kilo = map['kilo'] ?? 0;
    this._kanGrubu = map['kanGrubu'] ?? '';
    //this._boy=map['boy'] ?? 0;
    //this._kilo=map['kilo'] ?? 0;
    //this._kanGrubu=map['kanGrubu'];
  }
  @override
  String toString() {
    return 'KBI{_boy: $_boy,_kilo: $_kilo,_kanGrubu: $_kanGrubu}';
  }


}