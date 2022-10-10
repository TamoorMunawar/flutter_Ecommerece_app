import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserAdminService{
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String ref = 'admins';
  FirebaseAuth auth = FirebaseAuth.instance;
  void uploadAdminUser({String userName, String email,String password}){
    String adminUid = auth.currentUser.uid;
    _firestore.collection(ref).doc(adminUid).set({
      'name':userName,
      'email':email,
      'uid':adminUid,
      'password':password,

    });

  }
}
