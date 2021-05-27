// To parse this JSON data, do
//
//     final eczaneListe = eczaneListeFromJson(jsonString);

import 'dart:convert';

EczaneListe eczaneListeFromJson(String str) => EczaneListe.fromJson(json.decode(str));

String eczaneListeToJson(EczaneListe data) => json.encode(data.toJson());

class EczaneListe {
    EczaneListe({
        this.data,
    });

    List<Datum> data;

    factory EczaneListe.fromJson(Map<String, dynamic> json) => EczaneListe(
        data: json["data"] == null ? null : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    Datum({
        this.cityId,
        this.cityName,
        this.countPharmacy,
        this.area,
    });

    String cityId;
    String cityName;
    String countPharmacy;
    List<Area> area;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        cityId: json["CityID"] == null ? null : json["CityID"],
        cityName: json["CityName"] == null ? null : json["CityName"],
        countPharmacy: json["countPharmacy"] == null ? null : json["countPharmacy"],
        area: json["area"] == null ? null : List<Area>.from(json["area"].map((x) => Area.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "CityID": cityId == null ? null : cityId,
        "CityName": cityName == null ? null : cityName,
        "countPharmacy": countPharmacy == null ? null : countPharmacy,
        "area": area == null ? null : List<dynamic>.from(area.map((x) => x.toJson())),
    };
}

class Area {
    Area({
        this.areaName,
        this.countPharmacy,
        this.pharmacy,
    });

    String areaName;
    String countPharmacy;
    List<Pharmacy> pharmacy;

    factory Area.fromJson(Map<String, dynamic> json) => Area(
        areaName: json["areaName"] == null ? null : json["areaName"],
        countPharmacy: json["countPharmacy"] == null ? null : json["countPharmacy"],
        pharmacy: json["pharmacy"] == null ? null : List<Pharmacy>.from(json["pharmacy"].map((x) => Pharmacy.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "areaName": areaName == null ? null : areaName,
        "countPharmacy": countPharmacy == null ? null : countPharmacy,
        "pharmacy": pharmacy == null ? null : List<dynamic>.from(pharmacy.map((x) => x.toJson())),
    };
}

class Pharmacy {
    Pharmacy({
        this.name,
        this.phone,
        this.address,
        this.maps,
    });

    String name;
    String phone;
    String address;
    String maps;

    factory Pharmacy.fromJson(Map<String, dynamic> json) => Pharmacy(
        name: json["name"] == null ? null : json["name"],
        phone: json["phone"] == null ? null : json["phone"],
        address: json["address"] == null ? null : json["address"],
        maps: json["maps"] == null ? null : json["maps"],
    );

    Map<String, dynamic> toJson() => {
        "name": name == null ? null : name,
        "phone": phone == null ? null : phone,
        "address": address == null ? null : address,
        "maps": maps == null ? null : maps,
    };
}
