import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_app/components/product_card.dart';
import 'custom_input.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Constants {
  static const regularHeading =
  TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: Colors.black);

  static const boldHeading =
  TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600, color: Colors.black);

  static const regularDarkText =
  TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600, color: Colors.black);
}
class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String _searchString = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
      elevation: 0.1,
      backgroundColor: Colors.red,
      title: Text('Search'),
    ),
      body: Container(
        child: Stack(
          children: [
            if (_searchString.isEmpty)
              Center(
                child: Container(
                  child: Text(
                    "Search Results",
                    style: Constants.regularDarkText,
                  ),
                ),
              )
            else
            StreamBuilder(
                stream: FirebaseFirestore.instance.collection("products").orderBy("name").startAt([_searchString]).endAt(["$_searchString\uf8ff"]).snapshots(),
                builder: (BuildContext  context, AsyncSnapshot<QuerySnapshot> snapshot){
                  if(!snapshot.hasData)
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  return GridView.count(
                    padding: EdgeInsets.only(
                      top: 120.0,
                      bottom: 100.0,
                    ),
                      crossAxisCount: 1,
                       crossAxisSpacing: 80,
                      children: snapshot.data.docs.map((document) {
                      return  ProductCard(
                        title: document.data()['name'],
                        imageUrl: document.data()['images'][0],
                        price: "\$${document.data()['price']}",
                        productId: document.id,
                      );
                    }).toList(),
                  );
                }
            ),
            Padding(
              padding: const EdgeInsets.only(top: 45.0),
              child: CustomInput(
                hintText: "Search here.....",
                onSubmitted:(value){
                    setState(() {
                      _searchString = value;
                    });

                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
