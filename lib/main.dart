import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_app/pages/Login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'Model/AppData.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
      ChangeNotifierProvider(
        create:(_)=>AppData(),
        child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Login(),
    ),
  ));
}
