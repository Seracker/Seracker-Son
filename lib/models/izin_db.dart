class IzinDb{
  bool _adim,_nabiz,_hastaliklar;
  String _userID;
  int _secilenTur,_durum;

  get durum => _durum;

  set durum(value) {
    _durum = value;
  }

  int get secilenTur => _secilenTur;

  set secilenTur(int value) {
    _secilenTur = value;
  }

  bool get adim => _adim;
  set adim(bool value) {
    _adim = value;
  }
  get nabiz => _nabiz;
  set nabiz(value) {
    _nabiz = value;
  }
  String get userID => _userID;
  set userID(String value) {
    _userID = value;
  }
  get hastaliklar => _hastaliklar;
  set hastaliklar(value) {
    _hastaliklar = value;
  }
  IzinDb(this._adim,this._nabiz,this._hastaliklar);
  Map<String,dynamic> toMap(){
    var map=Map<String,dynamic>();
    map['adim']=_adim ?? false;
    map['nabiz']=_nabiz ?? false;
    map['hastaliklar']=_hastaliklar ?? false;
    map['secilenTur']=_secilenTur ?? 0;
    map['durum']=_durum ?? 0;
    return map;
  }

  IzinDb.fromMap(Map<String,dynamic> map){
    this._adim = map['adim'] ?? false;
    this._nabiz = map['nabiz'] ?? false;
    this._hastaliklar = map['hastaliklar'] ?? false;
    this._secilenTur=map['secilenTur'] ?? 0;
    this._durum = map['durum'] ?? 0;
  }
  @override
  String toString() {
    return 'IzinDb{_adim: $_adim,_nabiz: $_nabiz,_hastaliklar: $_hastaliklar,_secilenTur: $_secilenTur,_durum: $_durum}';
  }
}