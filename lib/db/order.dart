import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';


class OrderService{
  FirebaseFirestore _firestore= FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
   String ref = 'orders';
  void uploadOrder({int number, String email,String username, String address, String userId,String totalAmount,String cardPId,String size, int productQuantity}){
    var id = Uuid();
    String orderId = id.v1();
     DateTime timestamp  = DateTime.now();
    _firestore.collection(ref).doc(orderId).set({

       'orderId' :orderId,
       'username':username,
       'address':address,
       'email':email,
       'number':number,
       'userId':userId,
       'totalAmount':totalAmount,
       'timestamp': timestamp


    });

  }

}


