import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_ecommerce_app/Model/AppData.dart';
import 'package:provider/provider.dart';
class UserManager extends StatefulWidget {
  @override
  _UserManagerState createState() => _UserManagerState();
  final CollectionReference _userRef = FirebaseFirestore.instance.collection("users");

  Future getUsersList() async{
    List itemList = [];
    try{
      await _userRef.get().then((querySnapshot){
        querySnapshot.docs.forEach((element) {
          itemList.add(element.data());
        });
      });
      return itemList;
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }
}


class _UserManagerState extends State<UserManager> {
  final SnackBar _snackBar = SnackBar(content: Text("Users deleted"),);
 List userProfileList = [];
  @override
  void initState() {
    super.initState();
    fetchDatabaseList();
  }

  fetchDatabaseList() async{
    dynamic resultant = await UserManager().getUsersList();
    if(resultant == null){
      print("unable to retrieve");
    }
    else{
      setState(() {
        userProfileList = resultant;
      });

    }
  }
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        elevation: 0.1,
        backgroundColor: Colors.red,
        title: Text('Users'),
      ),
      body: Consumer<AppData>(
        builder: (context,value,child) =>Container(
          child: ListView.builder(
            itemCount: userProfileList.length,
            itemBuilder: (context, index){
              return Card(
                child: ListTile(
                  title: Text(userProfileList[index]["name"]),
                  subtitle: Text(userProfileList[index]["email"]),
                  leading: CircleAvatar(
                    child: Image(
                    image: AssetImage('images/profile.png'),
                    ),
                  ),
                  trailing:   new IconButton(icon: Icon(Icons.delete,color: Colors.red,), onPressed: () async{

                     await Provider.of<AppData>(context,listen: false).deleteUserData(index) ;

                    Scaffold.of(context).showSnackBar(_snackBar);
                    Timer(Duration(seconds: 2), () {
                      Navigator.pop(context);
                    });
                  }),
                ),
              );
            },
          ),
        ),
      ),
    );
  }



}
