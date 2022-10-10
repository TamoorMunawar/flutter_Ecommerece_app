import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_ecommerce_app/components/product_card.dart';


class Products extends StatefulWidget {

  @override
  _ProductsState createState() => _ProductsState();

}


class _ProductsState extends State<Products> {
  final CollectionReference _productsRef = FirebaseFirestore.instance.collection("products");
  final CollectionReference _userRef = FirebaseFirestore.instance.collection("users");
  User _user = FirebaseAuth.instance.currentUser;
  Future<QuerySnapshot> getProductsByCities()async{

    final userData = await _userRef.doc(_user.uid).get();
    final city = userData.data()["city"];
    return _productsRef.where("city",isEqualTo: city).get();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          FutureBuilder<QuerySnapshot>(
            future: getProductsByCities(),
            builder: (context, snapshot){

              if (snapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Text("Error: ${snapshot.error}"),
                  ),
                );
              }

              // Collection Data ready to display
              if (snapshot.connectionState == ConnectionState.done) {
                // Display the data inside a list view
                return GridView.count(
                  crossAxisCount: 2,
                  children: snapshot.data.docs.map((document) {
                    return ProductCard(
                      title: document.data()['name'],
                      imageUrl: document.data()['images'][0],
                      price: "\€${document.data()['price']}",
                      productId: document.id,
                    );
                  }).toList(),
                );
              }

              // Loading State
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          ),
        ],
      ),
    );

  }
}
