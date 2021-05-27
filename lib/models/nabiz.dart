class Nabiz{
  List<String> _nabiz;
  String _nabizTarihi;
  String _nabizZaman;

  List<String> get nabiz => _nabiz;

  set nabiz(List<String> value) {
    _nabiz = value;
  }
  String get nabizZaman => _nabizZaman;

  set nabizZaman(String value) {
    _nabizZaman = value;
  }
  String get nabizTarihi => _nabizTarihi;

  set nabizTarihi(String value) {
    _nabizTarihi = value;
  }
  Nabiz(this._nabiz,this._nabizTarihi,this._nabizZaman);

  Map <String , dynamic> toMap(){///toMap= database e yazmak için map e çeviriyor
    var map= Map<String,dynamic>();

    if (this._nabiz != null) {
      map['nabiz'] = this._nabiz.map((e) => e).toList();
    }
    //map['nabiz']=_nabiz;
    //map['nabizTarihi']=_nabizTarihi;
    //map['nabizZaman']=_nabizZaman;
    return map;
  }
  Nabiz.fromMap(Map<String,dynamic> map){///fromMap= database den okuduğun map i objeye dönüştürüyor
    if (map['nabiz'] != null) {
      _nabiz = new List<String>();
      map['nabiz'].forEach((v) {
        _nabiz.add(v);
      });
    }
    //this._nabiz=map['nabiz'];
    this._nabizTarihi=map['nabizTarihi'];
    this._nabizZaman=map['nabizZaman'];
  }
  @override
  String toString() {
    return 'Users{_nabiz: $_nabiz,_nabizTarihi: $_nabizTarihi';
  }
}