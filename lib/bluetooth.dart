import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:seracker/pages/ana_sayfa.dart';


import 'connection.dart';




class Bluetooth extends StatefulWidget {
  @override
  _BluetoothState createState() => _BluetoothState();
}

class _BluetoothState extends State<Bluetooth> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Aygıtlar'),
          ),
          body: SelectBondedDevicePage(
            onCahtPage: (device1) {
              BluetoothDevice device = device1;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return AnaSayfa(server: device,bluetoothDurum: true,);
                  },
                ),
              );
            },
          ),
        ));
  }
}
