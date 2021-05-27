class Users {

  String _name;
  String _surname;
  String _email;
  String _userID;
  String _tcNo;
  String _tel;
  String _password;
  String _dogumTarihi;
  int _age;


  int get age => _age;

  set age(int value) {
    _age = value;
  }

  String get dogumTarihi => _dogumTarihi;

  set dogumTarihi(String value) {
    _dogumTarihi = value;
  }

  String _cinsiyet;


  String get cinsiyet => _cinsiyet;

  set cinsiyet(String value) {
    _cinsiyet = value;
  }

  String get userID => _userID;

  set userID(String value) {
    _userID = value;
  }
  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get surname => _surname;

  set surname(String value) {
    _surname = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get tcNo => _tcNo;

  set tcNo(String value) {
    _tcNo = value;
  }

  String get tel => _tel;

  set tel(String value) {
    _tel = value;
  }

  String get password => _password;

  set password(String value) {
    _password = value;
  }




  Users(this._userID);
  Users.Kayit(this._userID,this._name, this._surname, this._email, this._tcNo,
      this._tel, this._password ,this._age);
  Users.WithID(this._userID,this._name, this._surname, this._email,this._tcNo,///withID = id ile birlikte kullanım
      this._tel, this._password);
  Map <String , dynamic> toMap(){///toMap= database e yazmak için map e çeviriyor
    var map= Map<String,dynamic>();
    map['userID']=_userID;
    map['name']=_name;
    map['surname']=_surname;
    map['email']=_email;
    map['tel']=_tel;
    map['tcNo']=_tcNo;
    map['password']=_password;
    map['dogumTarihi']=_dogumTarihi ?? '';
    map['cinsiyet'] = _cinsiyet ?? '';
    map['age']=_age ?? 0;


    return map;
  }
  Users.fromMap(Map<String,dynamic> map){///fromMap= database den okuduğun map i objeye dönüştürüyor
    this._userID=map['userID'];
    this._tcNo=map['tcNo'];
    this._tel=map['tel'];
    this._password=map['password'];
    this._name=map['name'];
    this._surname=map['surname'];
    this._email=map['email'];
    this._dogumTarihi=map['dogumTarihi'] ?? '';
    this._cinsiyet=map['cinsiyet'] ?? '';
    this._age=map['age'] ?? 0;
  }
  @override
  String toString() {
    return 'Users{_name: $_name, _surname: $_surname, _email: $_email,_userID: $_userID,_tcNo: $_tcNo, _tel: $_tel, _password: $_password'
        '_dogumTarihi: $_dogumTarihi,_cinsiyet: $cinsiyet,_age: $_age';
  }
}