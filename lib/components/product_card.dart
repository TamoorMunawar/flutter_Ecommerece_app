import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_app/screens/product_detail.dart';

class ProductCard extends StatelessWidget {
  final String productId;
  final Function onPressed;
  final String imageUrl;
  final String title;
  final String price;
  final String name;
  ProductCard({this.onPressed, this.imageUrl, this.title, this.price, this.productId,this.name});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Hero(
          tag:new Text("hero 1"),
          child:Material(
            child: GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => ProductDetails(productId: productId, title: title, price: price),
                ));
              },
              child:  GridTile(
                  footer: Container(
                      color: Colors.white60,
                      padding: EdgeInsets.only(
                        top: 8.0,
                        bottom: 8.0,
                      ),
                      child: new Row(children: <Widget>[
                        Expanded(
                          child: Text(title,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0),),

                        ),
                        new Text(price,style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),)
                      ],)
                  ),
                  child:Image.network(
                    "$imageUrl",
                    fit: BoxFit.cover,
                  )),
            ),
          )),
    );
  }
}