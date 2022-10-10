import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_ecommerce_app/Model/AppData.dart';
import 'package:provider/provider.dart';
class OrderManager extends StatefulWidget {
  @override
  _OrderManagerState createState() => _OrderManagerState();
}
class _OrderManagerState extends State<OrderManager> {
  final SnackBar _snackBar = SnackBar(content: Text("Order deleted"),);
  final CollectionReference _orderItemRef = FirebaseFirestore.instance.collection("orders");
  final CollectionReference _userRef = FirebaseFirestore.instance.collection("users");
  User _user = FirebaseAuth.instance.currentUser;
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        elevation: 0.1,
        backgroundColor: Colors.red,
        title: Text('My Order'),
      ),
      body: Consumer<AppData>(
        builder:(context,value,child)=>Container(
          child: FutureBuilder<QuerySnapshot>(
            future: _userRef.doc(_user.uid).collection("MyOrders").get(),
            builder: (context, snapshot){
              if (snapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Text("Error: ${snapshot.error}"),
                  ),
                );
              }
              if (snapshot.hasData) {
                // Display the data inside a list view
                return ListView(
                  children: snapshot.data.docs.map((document) {
                    return Card(
                      child: ListTile(
                        title: Text(document["name"]),
                        subtitle: Text("\€ ${document["amount"]}"),
                        leading: CircleAvatar(backgroundColor: Colors.white,
                          child: Image(
                            image: AssetImage('images/box.png'),
                          ),
                        ),
                        trailing:   new IconButton(icon: Icon(Icons.delete,color: Colors.red,), onPressed: () async{

                          await Provider.of<AppData>(context,listen: false).deleteOrderData(document.id);

                          Scaffold.of(context).showSnackBar(_snackBar);
                          Timer(Duration(seconds: 2), () {
                            Navigator.pop(context);
                          });
                        }),
                      ),
                    );
                  }).toList(),
                );
              }
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );

            },
          ),
        ),
      ),
    );

  }

}
