import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:seracker/landing_page.dart';
import 'package:seracker/locator.dart';
import 'package:seracker/models/Users.dart';
import 'package:seracker/viewmodel/user_model.dart';
import 'package:seracker/yukleme_ekrani.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  setupLocator();
  runApp(MyApp());
  // await AndroidAlarmManager.initialize();
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('tr');
    return ChangeNotifierProvider(
          create: (BuildContext context)=>UserModel(),
          child: MaterialApp(
            title: 'Seracker',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              // primarySwatch: Colors.green,
              brightness: Brightness.dark,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
              home: App(),
          ),
      );
  }
}
class App extends StatelessWidget {
  // Create the initialization Future outside of `build`:
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text("Hata çıktı "+snapshot.error.toString()),
            ),
          );
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return LandingPage();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}