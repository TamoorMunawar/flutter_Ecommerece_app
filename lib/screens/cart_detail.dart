import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_app/Model/AppData.dart';
import 'package:flutter_ecommerce_app/screens/checkout.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
class Cart extends StatefulWidget {
  final String pId;
  final String size;
  final String title;
  final int proQuantity;
  final String prodPrice;


  Cart({Key key, this.pId,this.size,this.proQuantity,this.title,this.prodPrice});

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  double totalPrice=0.0;
  double grandTotalPrice = 0.0;
  double shipPrice =50.0;

  final CollectionReference _userRef = FirebaseFirestore.instance.collection("users");
  final CollectionReference _productsRef = FirebaseFirestore.instance.collection("products");
  User _user = FirebaseAuth.instance.currentUser;
  @override


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        elevation: 0.1,
        backgroundColor: Colors.red,
        title: Text('Cart'),
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
      body: Consumer<AppData>(
        builder: (context, value, child) => Column(
          children: [
            Expanded(
              child: FutureBuilder<QuerySnapshot>(
                future: _userRef.doc(_user.uid).collection("carts").get(),
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
                        top: 10.0,
                        bottom: 12.0,
                      ),
                      children: snapshot.data.docs.map((document)

                      {
                        return GestureDetector(
                          onTap: () {

                          },

                          child: FutureBuilder(
                            future: _productsRef.doc(document.id).get(),
                            builder: (context, productSnap,) {
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
                                  value.calculateTotalPrice(grandTotalPrice);

                                  return InkWell(
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(builder:
                                      (context)=>Checkout(cartPId: widget.pId,cartPSize:widget.size, cartProductQuantity:widget.proQuantity,productPrice: widget.prodPrice,cartPTitle: widget.title,)));
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
                                            width: 140,
                                            height: 140,
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
                                            padding: EdgeInsets.only(left: 16.0,),
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
                                                  padding: const EdgeInsets.symmetric(vertical: 4.0,),
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
                                                  padding: const EdgeInsets.symmetric(vertical: 4.0,),
                                                  child: Text(
                                                    "Size -${document.data()['size']}",
                                                    style: TextStyle(
                                                        fontSize: 16.0,
                                                        color: Colors.black,
                                                        fontWeight:
                                                        FontWeight.w600),
                                                  ),
                                                ),


                                                Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 4.0,),
                                                  child: Text(
                                                    "quantity -${document.data()['quantity']}",
                                                    style: TextStyle(
                                                        fontSize: 16.0,
                                                        color: Colors.black,
                                                        fontWeight:
                                                        FontWeight.w600),
                                                  ),
                                                ),

                                                Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 0.0,),
                                                  child: new IconButton(icon: Icon(Icons.delete), onPressed: () async {

                                                    value.calculateTotalPrice(0.0);
                                                    setState(() {
                                                      grandTotalPrice=0.0;
                                                      totalPrice=0.0;

                                                    });
                                                    _userRef.doc(_user.uid).collection("carts").doc(document.id).delete();

                                                    if(grandTotalPrice<=50.0){
                                                      grandTotalPrice=0.0;
                                                    }

                                                  }),
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
            ),
            Container(
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  Expanded(child: ListTile(
                    title: new Text("Shipping Tax:"),
                    subtitle: new Text("\€${Provider.of<AppData>(context, listen: false).shipmentPrice.toString()}"),
                  )),
                  Expanded(child: ListTile(
                    title:new MaterialButton(onPressed: () {

                      showCustomDialog(grandTotalPrice);
                    },
                      color: Colors.red,
                      textColor: Colors.white,
                      elevation: 0.2,
                      child: new Text("Total"),
                    ),
                  )),

                  Expanded(child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                    child: new MaterialButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>Checkout()));
                    },
                      child: new Text("Checkout",style: TextStyle(color: Colors.white),),
                      color: Colors.red,
                    ),
                  )),
                ],
              ),
            ),
          ],
        ),
      ),

    );

  }

  void  showCustomDialog(price) async{

    AlertDialog alertDialog = AlertDialog(
      title:  Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text("Total Price = \€${price.toString()} "),
        // child: Text("Total Price =  "+ grandTotalPrice.toString()),
      ),
    );
    await showDialog(context: context, builder: (context){
      return alertDialog;
    });
  }


}



