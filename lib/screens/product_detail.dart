import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_app/screens/cart_detail.dart';
import 'package:flutter_ecommerce_app/screens/favouite.dart';
import 'package:flutter_ecommerce_app/screens/image_swipe.dart';
import 'package:flutter_ecommerce_app/screens/product_size.dart';
import 'package:uuid/uuid.dart';
import '../constants.dart';
import 'dart:async';

class ProductDetails extends StatefulWidget {
  final String productId;
  final String title;
  final String price;



  ProductDetails({this.productId, this.title, this.price});

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final CollectionReference _productsRef = FirebaseFirestore.instance.collection("products");
  final CollectionReference _userRef = FirebaseFirestore.instance.collection("users");
  final CollectionReference _orderItemRef = FirebaseFirestore.instance.collection("orders");
  User _user = FirebaseAuth.instance.currentUser;
  TextEditingController _quantityController = TextEditingController();
  GlobalKey <FormState> _formKey = GlobalKey <FormState>();
  String _selectedProductSize = "0";
  DateTime timestamp  = DateTime.now();



  Future _orderCartItems() {

    return _orderItemRef.doc(_user.uid).collection("carts").doc("1").collection("products").doc(widget.productId).set
      ({
      "size": _selectedProductSize,
      "title": widget.title,
      "quantity": int.parse(_quantityController.text),
      "price": widget.price,
      'timestamp': timestamp,

    });
  }

  Future _addToCart() {

    return _userRef.doc(_user.uid).collection("carts").doc(widget.productId).set
      ({
      "size": _selectedProductSize,
      "title":widget.title,
      "quantity": int.parse(_quantityController.text),
      "price":widget.price,
      'timestamp': timestamp,


    });

  }

  Future _addToFavourite() {
    return _userRef.doc(_user.uid).collection("favourite").doc(widget.productId).set({
      "size": _selectedProductSize,
      "quantity": int.parse(_quantityController.text),
      "title":widget.title,
      "price":widget.price,
      'timestamp': timestamp});

  }

  final SnackBar _snackBar = SnackBar(content: Text("Product added to the cart"),);
  final SnackBar _snackBar1 = SnackBar(content: Text("Product added to the Favourite"),);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        elevation: 0.1,
        backgroundColor: Colors.red,
        title: Text('Details'),
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0,0,10,0),
            child: GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>
                Cart(
                  pId:widget.productId,
                  size:_selectedProductSize,
                  proQuantity:int.parse(_quantityController.text),
                  title: widget.title,
                  prodPrice: widget.price,
                 )
                ));
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
                    stream: _userRef.doc(_user.uid).collection("carts").snapshots(),
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
      body: Stack(
        key: _formKey,
        children: [
          FutureBuilder(
            future: _productsRef.doc(widget.productId).get(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Text("Error: ${snapshot.error}"),
                  ),
                );
              }

              if (snapshot.connectionState == ConnectionState.done) {
                // Firebase Document Data Map
                Map<String, dynamic> documentData = snapshot.data.data();

                // List of images
                List imageList = documentData['images'];
                List productSizes = documentData['sizes'];

                // Set an initial size
                _selectedProductSize = productSizes[0];

                return ListView(
                  padding: EdgeInsets.all(0),
                  children: [
                    ImageSwipe(
                      imageList: imageList,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 24.0,
                        left: 24.0,
                        right: 24.0,
                        bottom: 4.0,
                      ),
                      child: Text(
                        "${documentData['name']}",
                        style: Constants.boldHeading,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4.0,
                        horizontal: 24.0,
                      ),
                      child: Text(
                        "\€${documentData['price']}",
                        style: TextStyle(
                          fontSize: 18.0,
                          color:Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 24.0,
                      ),
                      child: Text(
                        "${documentData['description']}",
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 24.0,
                      ),
                      child:Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 250, 0),
                        child:TextFormField(
                          controller: _quantityController,
                          keyboardType:  TextInputType.number,
                          decoration: InputDecoration(
                          border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),


                          ),
                          hintText: 'Qty'
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'You must enter the quantity';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 24.0,
                        horizontal: 24.0,
                      ),
                      child: Text(
                        "Select Size",
                        style: Constants.regularDarkText,
                      ),
                    ),
                    ProductSize(
                      productSizes: productSizes,
                      onSelected: (size) {
                        _selectedProductSize = size;
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24.0,24.0,24.0,30.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () async{
                             await _addToFavourite() ;
                              Scaffold.of(context).showSnackBar(_snackBar1);
                             Timer(Duration(seconds: 2), () {
                               Navigator.push(context, MaterialPageRoute(builder: (context)=>Saved()));
                             });

                            },
                            child: Container(
                              width: 65.0,
                              height: 65.0,
                              decoration: BoxDecoration(
                                color: Color(0xFFDCDCDC),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              alignment: Alignment.center,
                              child: Image(
                                image: AssetImage(
                                  'images/favorite.png',
                                ),
                                height: 22.0,
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: ()  async{
                                await _orderCartItems();
                                await _addToCart();
                                Scaffold.of(context).showSnackBar(_snackBar);
                              },
                              child: Container(
                                height: 65.0,
                                margin: EdgeInsets.only(
                                  left: 16.0,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  "Add To Cart",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
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