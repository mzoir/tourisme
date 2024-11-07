import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tourisme/service/auth.dart';
import 'package:tourisme/view/firebase_options.dart';
import 'package:tourisme/view/log.dart';
import 'package:tourisme/view/sign.dart';
import 'package:tourisme/viewmodels/UserViewModel.dart';
import 'package:tourisme/viewmodels/ViewModel.dart';
import 'package:tourisme/viewmodels/ViewRestoModel.dart';
import 'package:tourisme/viewmodels/hotel_viewmodel.dart';
import 'package:tourisme/viewmodels/attraction_viewmodel.dart';
import 'package:tourisme/view/home_page.dart';

const Color darkBlue = Color.fromARGB(255, 18, 32, 47);
const messageLimit = 30;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  Future<bool> checkConnectivity() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData myTheme = ThemeData(
      primarySwatch: Colors.blue,
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HotelViewModel()),
        ChangeNotifierProvider(create: (_) => AttractionViewModel()),
        ChangeNotifierProvider(create: (_) => FireAuth()),
        ChangeNotifierProvider(create: (_) => UserViewModel()),
        ChangeNotifierProvider(create: (_) => VideoViewModel()),
        ChangeNotifierProvider(create: (_) => RestaurantViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: myTheme,
        home: FutureBuilder<bool>(
          future: checkConnectivity(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData && snapshot.data == true) {
              return FutureBuilder<User?>(
                future: FirebaseAuth.instance.authStateChanges().first,
                builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasData && snapshot.data != null) {
                    return HoMepa(email: snapshot.data!.email ?? '');
                  } else {
                    return LogPage();
                  }
                },
              );
            } else {
              return Scaffold(
                body: Center(child: Text('No internet connection')),
              );
            }
          },
        ),
      ),
    );
  }
}
