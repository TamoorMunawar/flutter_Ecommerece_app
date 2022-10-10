import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class Reset extends StatefulWidget {
  @override
  ResetState createState() => ResetState();
}

class ResetState extends State<Reset> {

  TextEditingController _emailController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Reset Password'),
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
          Container(
            padding: EdgeInsets.only(top:35.0,left: 30.0,right:30.0),
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red)
                    ),
                  ),
                  controller: _emailController,
                  validator: (value){
                    if(value.isEmpty){
                      return 'Enter email';
                    }
                    return null;
                  },
                  onChanged: (value){
                    _emailController.text = value;
                  },

                ),
                SizedBox(height: 70.0,),
                Container(
                  height: 40.0,
                  child: Material(
                    borderRadius: BorderRadius.circular(20.0),
                    shadowColor: Colors.redAccent,
                    color: Colors.red,
                    elevation: 7.0,
                    child: InkWell(
                      onTap: () {
                        FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text);
                        Navigator.of(context).pop();
                      },
                      child: Center(
                        child: Text(
                          'Send Request',style:TextStyle(color: Colors.white , fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),


              ],
            ),
          ),

        ],
      ),
    );
  }
}
