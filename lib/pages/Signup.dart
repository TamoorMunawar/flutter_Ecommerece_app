import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_ecommerce_app/db/user.dart';
import 'package:flutter_ecommerce_app/pages/Login.dart';
import 'package:flutter_ecommerce_app/pages/verify.dart';


class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  GlobalKey <FormState> _formKey = GlobalKey <FormState>();
  UserService _userService = UserService();
  TextEditingController _usernameController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _cityController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Sign up'),
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
              key: _formKey,
              children: [
                // name field
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Name',
                    labelStyle: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red)
                    ),
                  ),
                  controller: _usernameController,
                  validator:(value){
                    if(value.isEmpty){
                      return 'Enter name';
                    }
                    return null;
                  },
                  onChanged: (value){

                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'City',
                    labelStyle: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red)
                    ),
                  ),
                  controller: _cityController,
                  keyboardType: TextInputType.name,
                  validator: (value){
                    if(value.isEmpty){
                      return 'invalid city';
                    }
                    return null;
                  },
                  onChanged: (value){

                  },
                ),
                //email field
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red)
                    ),
                  ),
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value){
                    if(value.isEmpty || !value.contains('@')){
                      return 'invalid email';
                    }
                    return null;
                  },
                  onChanged: (value){

                  },
                ),
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
                    if(value.isEmpty){
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
                      onTap: () {
                        FirebaseAuth.instance.createUserWithEmailAndPassword(email: _emailController.text, password: _passwordController.text).then((_){
                        }).catchError((err) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Error !"),
                                  content: Text(err.message,style:TextStyle(color: Colors.red),),
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
                        _userService.uploadUser(
                          userName: _usernameController.text,
                          email: _emailController.text,
                          password: _passwordController.text,
                          city: _cityController.text.toLowerCase().trim()

                        );
                        Navigator.push(context,MaterialPageRoute(builder: (context) =>VerifyScreen()));
                      },
                      child: Center(
                        child: Text(
                          'Sign up',style:TextStyle(color: Colors.white , fontWeight: FontWeight.bold),
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
                        Navigator.push(context,MaterialPageRoute(builder: (context) => Login()));
                      },
                      child: Center(
                        child: Text(
                          'Login',style:TextStyle(color: Colors.black , fontWeight: FontWeight.bold),
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
