import 'package:flutter/material.dart';

import '../hatirlatici/igne_hatirlaticilari.dart';
import '../hatirlatici/ilac_hatirlaticilari.dart';
import '../hatirlatici/ozel_gun_hatirlaticilari.dart';

class Hatirlaticilar extends StatefulWidget {
  @override
  _HatirlaticilarState createState() => _HatirlaticilarState();
}

class _HatirlaticilarState extends State<Hatirlaticilar> {
  @override
  Widget build(BuildContext context) {
    DateTime secilenTarih = DateTime.now();
    TimeOfDay secilenSaat = TimeOfDay.fromDateTime(DateTime.now());

    return Theme(
      data: Theme.of(context).copyWith(
        accentColor: Colors.white,
        primaryColor: Colors.green,
        hintColor: Colors.green,
      ),
      child: Scaffold(
        backgroundColor: Colors.grey.shade800,
        appBar: AppBar(
          centerTitle: true,
          title: SizedBox(
            child: Image.asset(
              "img/seracker.png",
              scale: 10,
            ),
          ),
          backgroundColor: Colors.grey.shade900,
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: ExactAssetImage("img/bg2.png") ,
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Image.asset("img/calendar2.png",scale: 1,color: Colors.white60,),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 50, 100, 30),
                child: SizedBox(
                  width: 350,
                  height: 40,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: Colors.green),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Text(
                          "İlaç Hatırlatıcıları",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                        Icon(Icons.arrow_right_sharp),
                      ],
                    ),
                    color: Colors.grey.shade300,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Ilac()),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(100, 30, 10, 30),
                child: SizedBox(
                  width: 350,
                  height: 40,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: Colors.green),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Icon(Icons.arrow_left_sharp),
                        Text(
                          "İğne Hatırlatıcıları",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    color: Colors.grey.shade300,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Igne()),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 30, 100, 30),
                child: SizedBox(
                  width: 350,
                  height: 40,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: Colors.green),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Text(
                          "Özel Gün Hatırlatıcıları",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                        Icon(Icons.arrow_right_sharp),
                      ],
                    ),
                    color: Colors.grey.shade300,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => OzelGun()),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<TimeOfDay> saatSec(BuildContext context) {
  return showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
  );
}

Future<DateTime> tarihSec(BuildContext context) {
  return showDatePicker(
    context: context,
    firstDate: DateTime.now(),
    initialDate: DateTime.now(),
    lastDate: DateTime(2023),
    builder: (BuildContext context, Widget child) {
      return Theme(
        data: ThemeData.dark(),
        child: child,
      );
    },
  );
}
