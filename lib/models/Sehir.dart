

class Sehir {
  String sehir_adi;
  int plaka_no;
  Sehir.fromJsonMap(Map <String,dynamic> map):
  sehir_adi=map["sehir_adi"],
  plaka_no=map["plaka_no"];
  
}