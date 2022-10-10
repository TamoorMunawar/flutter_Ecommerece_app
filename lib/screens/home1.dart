import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter_ecommerce_app/components/products.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_ecommerce_app/pages/Login.dart';
import 'package:flutter_ecommerce_app/screens/cart_detail.dart';
import 'package:flutter_ecommerce_app/screens/favouite.dart';
import 'package:flutter_ecommerce_app/screens/orderList.dart';
import 'package:flutter_ecommerce_app/screens/search.dart';


class HomeScreen extends StatefulWidget {
  final auth = FirebaseAuth.instance;
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CollectionReference _userRef = FirebaseFirestore.instance.collection("users");
  User _user = FirebaseAuth.instance.currentUser;
  final _globalKey = GlobalKey<ScaffoldState>();


  userDelete(){
    final CollectionReference _userRef = FirebaseFirestore.instance.collection("users");
    User _user = FirebaseAuth.instance.currentUser;
    _userRef.doc(_user.uid).delete();

  }
  @override
  Widget build(BuildContext context) {
    Widget imageCarousel= new Container(
      height: 200.0,
      child: new Carousel(
        boxFit:BoxFit.cover,
        images:[
          AssetImage('images/c1.jpg'),
          AssetImage('images/m1.jpeg'),
          AssetImage('images/m2.jpg'),
          AssetImage('images/w1.jpeg'),
          AssetImage('images/w3.jpeg'),
          AssetImage('images/w4.jpeg'),
        ],
        autoplay: false,
        animationCurve: Curves.fastLinearToSlowEaseIn,
        animationDuration: Duration(milliseconds: 1000),
        dotSize: 4.00,
        indicatorBgPadding: 2.00,
        dotBgColor:Colors.transparent,
      ),
    );
    return Scaffold(
      key: _globalKey,
      appBar: new AppBar(
        elevation: 0.1,
        backgroundColor: Colors.red,
        title: Text('Fashapp'),
        actions: <Widget>[
          new IconButton(icon: Icon(Icons.search,color: Colors.white,), onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>Search()));
          }),
          Padding(
            padding: const EdgeInsets.fromLTRB(0,0,10,0),
            child: GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Cart()));
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
      drawer: StreamBuilder<DocumentSnapshot>(
        stream: _userRef.doc(_user.uid).snapshots(),
        builder: (BuildContext context, AsyncSnapshot <DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Text("Error: ${snapshot.error}"),
              ),
            );
          }
          if (snapshot.hasData){
            var doc = snapshot.data.data();
            return new Drawer(
              child: new ListView(
                children: <Widget>[
                  //header
                  new UserAccountsDrawerHeader(accountName: Text(doc["name"]),
                    accountEmail:Text(doc["email"]),
                    currentAccountPicture: GestureDetector(
                    ),
                    decoration: new BoxDecoration(
                        color: Colors.red
                    ),
                  ),
                  //              body
                  InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
                    },
                    child: ListTile(
                      title: Text('Home page'),
                      leading: Icon(Icons.home,color: Colors.red,),
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: ListTile(
                      title: Text('My account'),
                      leading: Icon(Icons.person,color: Colors.red,),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>OrderManager()));
                    },
                    child: ListTile(
                      title: Text('My Orders'),
                      leading: Icon(Icons.shopping_basket,color: Colors.red,),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>Cart()));
                    },
                    child: ListTile(
                      title: Text('Shopping cart'),
                      leading: Icon(Icons.shopping_cart,color: Colors.red,),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>Saved()));
                    },
                    child: ListTile(
                      title: Text('Favourites'),
                      leading: Icon(Icons.favorite,color: Colors.red,),
                    ),
                  ),
                  Divider(),
                  InkWell(
                    onTap: () {},
                    child: ListTile(
                      title: Text('About'),
                      leading: Icon(Icons.help,color: Colors.blue,),
                    ),
                  ),

                  InkWell(
                    onTap: ()  {
                      FirebaseAuth.instance.signOut();
                      Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context) => Login()), (Route<dynamic> route) => false);
                    },
                    child: ListTile(
                      title: Text('Logout'),
                      leading: Icon(Icons.logout),
                    ),
                  ),
                ],
              ),
            );
          }
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      ),
      body: new ListView (
        children: <Widget>[
          // image carousel begin here
          imageCarousel,
//          padding widget
          new Padding(padding: const EdgeInsets.all(20.0),
            child: new Text('Recent Products',style: TextStyle(fontWeight: FontWeight.bold),),

          ),
          //grid view
          Container (
            height: 420.0,
            child:Products(),
          )
        ],
      ),
    );
  }


}



