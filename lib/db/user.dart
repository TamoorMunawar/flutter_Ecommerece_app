import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService{
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String ref = 'users';
  FirebaseAuth auth = FirebaseAuth.instance;
  void uploadUser({String userName, String email,String password ,String city}){
     String uid = auth.currentUser.uid;
    _firestore.collection(ref).doc(uid).set({
      'name':userName,
      'email':email,
      'uid':uid,
      'password':password,
      'city':city
    });

  }
}
