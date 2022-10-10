import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';


class ProductService{
  FirebaseFirestore _firestore= FirebaseFirestore.instance;
  String ref = 'products';
  void uploadProduct({String productName , String brand, String category, String description , int quantity,List  images, List sizes, double price}){
    var id = Uuid();
    String productId = id.v1();
    _firestore.collection(ref).doc(productId).set({
      'name':productName,
      'productId' :productId,
      'brand': brand,
      'category':category,
      'description':description,
      'price':price,
      'quantity':quantity,
      'sizes':sizes,
      'images':images

    });

  }





}


