import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ecommerce_app/Model/AppData.dart';
import 'package:flutter_ecommerce_app/db/order.dart';
import 'package:flutter_ecommerce_app/screens/payment.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';


class FavCheckout extends StatefulWidget {


  @override
  _FavCheckoutState createState() => _FavCheckoutState();
}

class _FavCheckoutState extends State<FavCheckout> {
  double totalPrice=0.0;
  double grandTotalPrice = 0.0;
  double shipPrice =50.0;
  double price = 0.0;

  final CollectionReference _userRef = FirebaseFirestore.instance.collection("users");
  final CollectionReference _productsRef = FirebaseFirestore.instance.collection("products");
  User _user = FirebaseAuth.instance.currentUser;
  GlobalKey <FormState> _formKey = GlobalKey <FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  OrderService _orderService =  OrderService();
  bool isLoading = false;
  final _globalKey = GlobalKey<ScaffoldState>();
  final SnackBar _snackBar = SnackBar(content: Text("Order added"),);
  DateTime timestamp  = DateTime.now();

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: new AppBar(
        elevation: 0.1,
        backgroundColor: Colors.red,
        title: Text('Favorite Checkout'),
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0,0,10,0),
            child: GestureDetector(
              onTap: (){
              },
              child: Container(
                width: 54.0,
                height: 44.0,
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                alignment: Alignment.center,
                child: StreamBuilder(
                    stream: _userRef.doc(_user.uid).collection("favourite").snapshots(),
                    builder: (context, snapshot){
                      int _totalItems = 0 ;
                      if(snapshot.connectionState == ConnectionState.active) {
                        List _documents = snapshot.data.docs;
                        _totalItems = _documents.length;
                      }
                      return Text(
                        "$_totalItems"  ?? "0" ,
                        style: TextStyle(
                          fontSize: 28.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),);
                    }
                ),
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Container(
          child: Consumer<AppData>(
            builder: (context, value, child) => Stack(
              children: [
                FutureBuilder<QuerySnapshot>(
                  future: _userRef.doc(_user.uid).collection("favourite").get(),
                  builder: (context, snapshot) {
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
                      return ListView(
                        padding: EdgeInsets.only(
                          top: 370.0,
                          bottom: 12.0,
                        ),
                        children: snapshot.data.docs.map((document)

                        {
                          return GestureDetector(
                            onTap: () {

                            },
                            child: FutureBuilder(
                              future: _productsRef.doc(document.id).get(),
                              builder: (context, productSnap) {
                                if (productSnap.hasError) {
                                  return Container(
                                    child: Center(
                                      child: Text("${productSnap.error}"),
                                    ),
                                  );
                                }
                                if (productSnap.connectionState == ConnectionState
                                    .done) {
                                  //total price calculation
                                  if (productSnap.hasData)  {
                                    Map _productMap = productSnap.data.data();

                                    totalPrice = totalPrice + document.data()["quantity"] * _productMap['price'];
                                    grandTotalPrice  = shipPrice + totalPrice ;
                                    calculateTotalPrice(grandTotalPrice);


                                    return InkWell(
                                      onTap: () {
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 16.0,
                                          horizontal: 24.0,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 100,
                                              height: 100,
                                              child: ClipRRect(
                                                borderRadius:
                                                BorderRadius.circular(8.0),
                                                child: Image.network(
                                                  "${_productMap['images'][0]}",
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.only(
                                                left: 16.0,
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "${_productMap['name']}",
                                                    style: TextStyle(
                                                        fontSize: 18.0,
                                                        color: Colors.black,
                                                        fontWeight:
                                                        FontWeight.bold),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      vertical: 4.0,
                                                    ),
                                                    child: Text(
                                                      "\€${_productMap['price']}",
                                                      style: TextStyle(
                                                          fontSize: 16.0,
                                                          color: Colors.red,
                                                          fontWeight:
                                                          FontWeight.bold),
                                                    ),
                                                  ),

                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      vertical: 4.0,
                                                    ),
                                                    child: Text(
                                                      "quantity -${document.data()['quantity']}",
                                                      style: TextStyle(
                                                          fontSize: 16.0,
                                                          color: Colors.black,
                                                          fontWeight:
                                                          FontWeight.w600),
                                                    ),
                                                  ),
                                                ],

                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );

                                  }
                                }
                                return Container(
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              },
                            ),
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 350,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 16.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left:2.0),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child:Text("Address Details:" ,textAlign: TextAlign.left,  style:  TextStyle(color:Colors.black ,fontWeight: FontWeight.bold, fontSize: 16.0),)),
                        ),
                        SizedBox(
                          height: 16.0,
                        ),
                        Container(
                          height: 50.0,
                          child: TextFormField(
                            controller: emailController,
                            keyboardType:  TextInputType.emailAddress,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(3),
                              ),
                              prefixIcon: Icon(Icons.email,color: Colors.red,),
                              hintText: 'Email',
                              labelText: 'Email',
                              fillColor: Colors.grey.shade200,
                              filled: true,
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'You must enter the email';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 16.0,
                        ),
                        Container(
                          height: 50.0,
                          child: TextFormField(
                            controller: nameController,
                            keyboardType:  TextInputType.name,
                            maxLines: 1,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(3),
                              ),
                              prefixIcon: Icon(Icons.person,color: Colors.red,),
                              hintText: 'Name',
                              labelText: 'Name',
                              fillColor: Colors.grey.shade200,
                              filled: true,
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'You must enter the name';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 16.0,
                        ),
                        Container(
                          height: 50.0,
                          child: TextFormField(
                            controller: phoneController,
                            keyboardType:  TextInputType.phone,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(3),
                              ),
                              prefixIcon: Icon(Icons.phone,color: Colors.red,),
                              hintText: 'Phone',
                              labelText: 'Phone',
                              fillColor: Colors.grey.shade200,
                              filled: true,
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'You must enter the phone';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 16.0,
                        ),
                        Container(
                          height: 50.0,
                          child: TextFormField(
                            controller: addressController,
                            keyboardType:  TextInputType.streetAddress,
                            maxLines: 1,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(

                                  borderRadius: BorderRadius.circular(3),
                                ),
                                prefixIcon: Icon(Icons.home,color: Colors.red,),
                                hintText: 'Address',
                                labelText: 'Address',
                                fillColor: Colors.grey.shade200,
                                filled: true
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'You must enter the address';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

          ),
        ),
      ),

      bottomNavigationBar: new Container(
        color: Colors.white,
        child: Row(
          children: <Widget>[
            Expanded(child: ListTile(
              title: new Text("Shipping Tax:"),
              subtitle: new Text("\€${Provider.of<AppData>(context, listen: false).shipmentPrice.toString()}"),
            )),
            Expanded(child: ListTile(
              title: new Text("Total:"),
              subtitle: new Text("\€${Provider.of<AppData>(context, listen: true).price.toString()}"),
            )),

            StreamBuilder<QuerySnapshot>(
                stream: _userRef.doc(_user.uid).collection("favourite").snapshots(),
                builder: (context, snapshot) {
                  int _totalItems = 0 ;
                  if(snapshot.connectionState == ConnectionState.active) {
                    List _documents = snapshot.data.docs;
                    _totalItems = _documents.length;
                  }
                  return Expanded(child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10 , 10, 10),
                    child: new MaterialButton(onPressed: () async{



                      validateAndUpload( _totalItems);


                    },
                      child: new Text("Pay now ",style: TextStyle(color: Colors.white),),
                      color: Colors.red,
                    ),
                  ));
                }
            ),
          ],
        ),
      ),
    );
  }
  void calculateTotalPrice(double grandTotalPrice){

    price = grandTotalPrice;
    print('new value updated: $price');


  }
  void validateAndUpload(int totalItems)  async {

    if(_formKey.currentState.validate()){
      setState(()=>isLoading = true);
      if(nameController != null && emailController !=null && phoneController !=null && addressController!=null){
        _orderService.uploadOrder(
          username: nameController.text.toString(),
          email: emailController.text.toString(),
          number: int.parse(phoneController.text),
          address: addressController.text.toString(),
          userId: _user.uid,
          totalAmount:"\€ ${price.toString()}",
        );
        _globalKey.currentState.showSnackBar(_snackBar);

        Timer(Duration(seconds: 1), () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=> PaymentCard(amount: price.toString(),)));
        });
        _formKey.currentState.reset();
        setState(()=>isLoading = false);

      }
      else{
        setState(()=>isLoading = false);
        Fluttertoast.showToast(msg: "all the fields must be provided",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    }

  }

}



