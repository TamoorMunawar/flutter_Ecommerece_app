import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:flutter_ecommerce_app/screens/home1.dart';

class VerifyScreen extends StatefulWidget {
  @override
  _VerifyScreenState createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final auth  = FirebaseAuth.instance;
  User user;
  Timer timer;

  @override
  void initState(){
    user = auth.currentUser;
    user.sendEmailVerification();
    timer= Timer.periodic(Duration(seconds: 3), (timer) {
      checkEmailVerified();
    });
    super.initState();
  }

  @override
  void dispose(){
    timer.cancel();
    super.dispose();

  }

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Verify Email'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Stack(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(30.0, 60.0, 0.0, 0.0),

                  child: Text("Fashion",style: TextStyle(fontSize: 80.0,fontWeight: FontWeight.bold),),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(30.0, 130.0, 0.0, 0.0),
                  child: Text("App",style: TextStyle(fontSize: 80.0,fontWeight: FontWeight.bold),),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(165.0, 130.0, 0.0, 0.0),
                  child: Text(".",style: TextStyle(fontSize: 80.0,fontWeight: FontWeight.bold,color: Colors.red),),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 40.0,left: 15.0,right: 15.0),
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text("A email has Sent to  ${user.email} Please Verify Email.",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16.0),),
              ),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.orangeAccent,
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> checkEmailVerified() async{
    user=auth.currentUser;
    await user.reload();
    if(user.emailVerified){
      timer.cancel();
      Navigator.pushReplacement(context,MaterialPageRoute(builder:(context)=>HomeScreen()));
    }
  }
}
