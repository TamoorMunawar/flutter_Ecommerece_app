import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class CartService{

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String ref = 'carts';
  FirebaseAuth auth = FirebaseAuth.instance;
  User _user = FirebaseAuth.instance.currentUser;

  void uploadCart({String productName,String description ,String images,int quantity, String sizes,double price, double total, String productId}){
    var id = Uuid();
    String cartId = id.v1();
    _firestore.collection("users").doc(_user.uid).collection("carts").doc(productId).set({
      'name':productName,
      'quantity':quantity,
      'price':price,
      'sizes':sizes,
      'description':description,
      'images':images,
      'total':total,

    });

  }
}
