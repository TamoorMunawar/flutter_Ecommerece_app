import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_ecommerce_app/Model/AppData.dart';
import 'package:provider/provider.dart';
class ProductManager extends StatefulWidget {
  @override
  _ProductManagerState createState() => _ProductManagerState();
  final CollectionReference _productRef = FirebaseFirestore.instance.collection("products");

  Future getProductList() async{
    List itemList = [];
    try{
      await _productRef.get().then((querySnapshot){
        querySnapshot.docs.forEach((element) {
          itemList.add(element.data());
        });
      });
      return itemList;
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }
}
class _ProductManagerState extends State<ProductManager> {
  final SnackBar _snackBar = SnackBar(content: Text("Products deleted"),);
  List productList = [];
  @override
  void initState() {
    super.initState();
    fetchDatabaseList();
  }

  fetchDatabaseList() async{
    dynamic resultant = await ProductManager().getProductList();
    if(resultant == null){
      print("unable to retrieve");
    }
    else{
      setState(() {
        productList = resultant;
      });

    }
  }
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        elevation: 0.1,
        backgroundColor: Colors.red,
        title: Text('Products'),
      ),
      body: Consumer<AppData>(
        builder:(context,value,child)=>Container(
          child: ListView.builder(
            itemCount: productList.length,
            itemBuilder: (context, index){
              return Card(
                child: ListTile(
                  title: Text(productList[index]["name"]),
                  subtitle: Text(productList[index]["price"].toString()),
                  leading: CircleAvatar(
                    child: Image.network(productList[index]["images"][0],
                    fit: BoxFit.cover,
                    ),
                  ),
                  trailing:   new IconButton(icon: Icon(Icons.delete,color: Colors.red,), onPressed: () async{

                   await Provider.of<AppData>(context,listen: false).deleteProductData(index);
                    Scaffold.of(context).showSnackBar(_snackBar);
                    Timer(Duration(seconds: 2), () {
                      Navigator.pop(context);
                    });
                  }),
                ),
              );
            },
          ),
        ),
      ),
    );

  }





}
