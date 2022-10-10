import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import  'package:flutter_ecommerce_app/pages/Signup.dart';
import   'package:flutter_ecommerce_app/screens/home1.dart';
import    'package:flutter_ecommerce_app/pages/reset.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  GlobalKey <FormState> _formKey = GlobalKey <FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final auth = FirebaseAuth.instance;
  bool isAdmin = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Login'),
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

            child: Form(
              child: Column(
                key: _formKey,
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red)
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    validator: (value){
                      if(value.isEmpty || !value.contains('@')){
                        return 'invalid email';
                      }
                      return null;
                    },
                    onChanged: (value){




                    },

                  ),
                  SizedBox(height: 20.0,),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red)
                      ),
                    ),
                    obscureText: true,
                    controller: _passwordController,
                    validator: (value){
                      if(value.isEmpty || value.length<=8){
                        return 'invalid password';
                      }
                      return null;
                    },
                    onChanged: (value){




                    },

                  ),
                  SizedBox(height: 5.0,),
                  Container(
                    alignment: Alignment(1.0,0.0),
                    padding: EdgeInsets.only(top:15.0,left: 20.0),
                    child: InkWell(
                      child: TextButton(child: Text("Forgot Password?",style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),), onPressed: () {
                        Navigator.push(context,MaterialPageRoute(builder:(context)=>Reset()));
                      },),
                    ),
                  ),
                  SizedBox(height: 40.0,),
                  Container(
                    height: 40.0,
                    child: Material(
                      borderRadius: BorderRadius.circular(20.0),
                      shadowColor: Colors.redAccent,
                      color: Colors.red,
                      elevation: 7.0,
                      child: InkWell(
                        onTap: (){

                          auth.signInWithEmailAndPassword(email: _emailController.text, password: _passwordController.text).then((_){
                            Navigator.push(context,MaterialPageRoute(builder: (context) => HomeScreen()));
                          }).catchError((err) {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Error !"),
                                    content: Text(err.message,style: TextStyle(color: Colors.red),),
                                    actions: [
                                      FlatButton(
                                        child: Text("Ok"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      )
                                    ],
                                  );
                                });
                          });
                        },
                        child: Center(
                          child: Text(
                            'Login',style:TextStyle(color: Colors.white , fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20.0,),
                  Container(
                    height: 40.0,
                    child: Material(
                      borderRadius: BorderRadius.circular(20.0),
                      elevation: 7.0,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(context,MaterialPageRoute(builder: (context) => SignUp()));
                        },
                        child: Center(
                          child: Text(
                            'Sign up',style:TextStyle(color: Colors.black , fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),


        ],
      ),
    );
  }
}
