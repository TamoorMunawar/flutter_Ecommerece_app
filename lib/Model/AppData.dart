import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AppData extends ChangeNotifier {


  deleteData(double grandTotalPrice, String id) async{


     final CollectionReference _userRef = FirebaseFirestore.instance.collection("users");
     User _user = FirebaseAuth.instance.currentUser;
     final CollectionReference collectionReference =_userRef.doc(_user.uid).collection("carts");
     await collectionReference.doc(id).delete();
     notifyListeners();
     calculateTotalPrice(grandTotalPrice);
     notifyListeners();

  }


  deleteFavData(String id) async{

    final CollectionReference _userRef = FirebaseFirestore.instance.collection("users");
    User _user = FirebaseAuth.instance.currentUser;
    final CollectionReference collectionReference =_userRef.doc(_user.uid).collection("favourite");
    await collectionReference.doc(id).delete();
    notifyListeners();
  }


     double price = 0.0;
     double shipmentPrice = 50.0;

      calculateTotalPrice(double grandTotalPrice) {
      print("Grand total price is: $grandTotalPrice");
      price = grandTotalPrice;
      notifyListeners();

  }

    deleteOrderData(String id) async{
    final CollectionReference _orderRef = FirebaseFirestore.instance.collection("orders");
    _orderRef.doc(id).delete();
    notifyListeners();
  }
   deleteUserData(int index) async {
    final CollectionReference _userRef = FirebaseFirestore.instance.collection("users");
    QuerySnapshot querySnapshot = await _userRef.get();
    querySnapshot.docs[index].reference.delete();
    notifyListeners();
  }
  deleteProductData(int index) async {
    final CollectionReference _productRef = FirebaseFirestore.instance.collection("products");
    QuerySnapshot querySnapshot = await _productRef.get();
    querySnapshot.docs[index].reference.delete();
    notifyListeners();
  }

}
