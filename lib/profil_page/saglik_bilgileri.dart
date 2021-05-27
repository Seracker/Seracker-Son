import 'package:flutter/material.dart';
import 'package:seracker/profil_page/hastalik.dart';
import 'package:seracker/profil_page/kullanilan_ilac.dart';
class SaglikBilgileri extends StatefulWidget {
  @override
  _SaglikBilgileriState createState() => _SaglikBilgileriState();
}

class _SaglikBilgileriState extends State<SaglikBilgileri> {

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        accentColor: Colors.white,
        primaryColor: Colors.green,
        hintColor: Colors.teal,
      ),
      child: Scaffold(
        backgroundColor: Colors.grey.shade800,
        appBar: AppBar(
          centerTitle: true,
          title: SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Image.asset(
                  "img/seracker.png",
                  scale: 10,
                ),
              ],
            ),
          ),
          backgroundColor: Colors.grey.shade900,
        ),
        body: Column(
          children: [
            SizedBox(height: 10,),
            Text("Sağlık Bilgileri",style: TextStyle(fontSize: 18),),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: 350,
                height: 40,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: BorderSide(color: Colors.green),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Text(
                        "Hastalık",
                        style: TextStyle(
                          fontSize: 16,
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
                      MaterialPageRoute(
                          builder: (context) => SaglikBilgileriHastalik()),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: 350,
                height: 40,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: BorderSide(color: Colors.green),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Text(
                        "Kullanılan İlaçlar",
                        style: TextStyle(
                          fontSize: 16,
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
                      MaterialPageRoute(
                          builder: (context) => SaglikBilgileriIlac()),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }



}
