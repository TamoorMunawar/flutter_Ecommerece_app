import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_app/screens/existing-card.dart';
import 'package:flutter_ecommerce_app/screens/home1.dart';
import 'package:flutter_ecommerce_app/service/payment-service.dart';
import 'package:progress_dialog/progress_dialog.dart';




class PaymentCard extends StatefulWidget {

  String amount, name , address,email,productId, productTitle, productSize ,price;
  final String id;
  int phone,productQuantity;
  PaymentCard({this.amount,this.name,this.address,this.phone,this.email,this.productId,this.productTitle,this.productSize,this.productQuantity,this.price,this.id});


  @override
  _PaymentCardState createState() => new _PaymentCardState();
}

class _PaymentCardState extends State<PaymentCard> {
  bool isLoading = false;
  final SnackBar _snackBar = SnackBar(content: Text("Order added Successfully"),);
  final SnackBar _snackBar1 = SnackBar(content: Text("Please pay payment for order"),);
  DateTime timestamp  = DateTime.now();
  User _user = FirebaseAuth.instance.currentUser;
  final CollectionReference _userRef = FirebaseFirestore.instance.collection("users");

  final CollectionReference _adminOrderItemRef = FirebaseFirestore.instance.collection("ordersList");
  final CollectionReference _orderItemRef = FirebaseFirestore.instance.collection("orders");
  final _globalKey = GlobalKey<ScaffoldState>();
  bool paymentStatus = false;




  Future _addOrder() {

    return _orderItemRef.doc(_user.uid).collection("MyOrders").doc("1").set
      ({"name": widget.name, "email":widget.email,"amount":widget.amount,"address":widget.address,
      "phone":widget.phone.toInt(), "user":_user.uid, "Payment":paymentStatus , 'timestamp': timestamp,
      });
  }


  Future _addOrderAdmin() {

    return _adminOrderItemRef.doc().set
      ({"name": widget.name, "email":widget.email,"amount":widget.amount,"address":widget.address,
      "phone":widget.phone.toInt(), "user":_user.uid, "Payment":paymentStatus , 'timestamp': timestamp,
    });
  }


  onItemPress(BuildContext context , int index)async{
    switch(index){
      case 0:

        payViaNewCard(context);

        break;
      case 1:
        Navigator.push(context, MaterialPageRoute(builder: (context)=>ExistingCard()));
        break;
    }
  }
  payViaNewCard(BuildContext context)async{
    ProgressDialog dialog = new ProgressDialog(context);
    dialog.style(
        message:'Please wait...',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600)
    );
    await dialog.show();
    var response = await StripeService.payWithNewCard(

        widget.amount.split(".")[0]+"00",
        "USD"
    );
    print("payment ${widget.amount}");

    await dialog.hide();
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(response.message),
        duration: new Duration(milliseconds: response.success == true ? 1200 : 3000),
      ),
    );
    if(response.success){
      paymentStatus = true;
      await _addOrder();
      await _addOrderAdmin();
      _globalKey.currentState.showSnackBar(_snackBar);
      Timer(Duration(seconds: 3), () {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
      });
    }
    else{
      _globalKey.currentState.showSnackBar(_snackBar1);
    }

  }


  @override

  void initState() {
    super.initState();
    StripeService.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: Colors.red,
        title: Text('Payment'),
      ),
      body: Container(
        child: ListView.separated(
            itemBuilder: (context,index){
              Icon icon;
              Text text;
              switch(index){
                case 0:
                  icon = Icon(Icons.add_circle,color: Colors.red,);
                  text = Text("Pay via new card");
                  break;
                case 1:
                  icon = Icon(Icons.credit_card,color: Colors.red,);
                  text = Text("Pay via existing card");
                  break;
              }
              return InkWell(
                onTap: (){
                  onItemPress(context,index);
                },
                child: ListTile(
                  title: text,
                  leading: icon,
                ),
              );
            },
            separatorBuilder:  (context,index) => Divider(
              color: Colors.red,
            ),
            itemCount: 2
        ),
      ),
    );
  }


}