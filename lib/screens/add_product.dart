import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_ecommerce_app/db/product.dart';
import '../db/category.dart';
import '../db/brand.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {

      CategoryService _categoryService = CategoryService();
      BrandService _brandService = BrandService();
      ProductService _productService = ProductService();
      GlobalKey <FormState> _formKey = GlobalKey <FormState>();
      TextEditingController productNameController = TextEditingController();
      TextEditingController quantityController = TextEditingController();
      TextEditingController priceController = TextEditingController();
      TextEditingController descriptionController = TextEditingController();
      List <DocumentSnapshot> brands = <DocumentSnapshot>[];
      List <DocumentSnapshot> categories = <DocumentSnapshot>[];
      List <DropdownMenuItem <String>> categoriesDropDown = <DropdownMenuItem <String>>[];
      List <DropdownMenuItem <String>> brandsDropDown = <DropdownMenuItem <String>>[];
      String  _currentCategory;
      String  _currentBrand;
      Color white = Colors.white;
      Color black = Colors.black;
      Color grey = Colors.grey;
      Color red = Colors.red;
      List <String> selectedSizes = <String>[];
      File _image1;
      File _image2;
      File _image3;
      List <String> _imageList = <String>[];
      bool isLoading = false;




      @override
       void initState(){
          _getCategories();
          _getBrands();

      }
      List <DropdownMenuItem <String>>getCategoriesDropdown(){
      List <DropdownMenuItem <String>> items = new List();
      for(int i=0;i < categories.length;i++){
        setState(() {
          items.insert(0, DropdownMenuItem(child: Text(categories[i].data()['category']),
          value: categories[i].data()['category']));
      });
        }
            return items;
      }
      List <DropdownMenuItem <String>>getBrandsDropdown(){
        List <DropdownMenuItem <String>> items = new List();
        for(int i=0;i < brands.length;i++){
          setState(() {
            items.insert(0, DropdownMenuItem(child: Text(brands[i].data()['brand']),
                value: brands[i].data()['brand']));
          });
        }
        return items;
      }


      @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
      appBar: AppBar(
            elevation: 0.1,
            backgroundColor: white,
            leading:  new IconButton(icon: Icon(Icons.close, color:Colors.black, ), onPressed: (){
              Navigator.pop(context);
            }),
            title:Text("Add Product",style: TextStyle(color: black),),
      ),
      body: Form(
        key: _formKey,
        child: isLoading ? CircularProgressIndicator():Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OutlineButton(
                      borderSide: BorderSide(color: grey.withOpacity(0.5), width: 2.5),
                      onPressed: () {
                        _selectImage(ImagePicker.pickImage(source: ImageSource.gallery),1);
                      },
                       child:  _displayChild1()
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OutlineButton(
                      borderSide: BorderSide(color: grey.withOpacity(0.5), width: 2.5),
                      onPressed: () {
                        _selectImage(ImagePicker.pickImage(source: ImageSource.gallery),2);
                      },
                      child: _displayChild2()
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OutlineButton(
                      borderSide: BorderSide(color: grey.withOpacity(0.5), width: 2.5),
                      onPressed: () {
                        _selectImage(ImagePicker.pickImage(source: ImageSource.gallery),3);
                      },
                      child: _displayChild3()
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Enter a product" ,textAlign: TextAlign.center,  style:  TextStyle(color: red , fontSize: 14.0),),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                controller: productNameController,
                decoration: InputDecoration(
                  hintText: 'Product name'
                ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'You must enter the product';
                    }
                    return null;
                  },
              ),
            ),
            // =============select category===============
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Category",style: TextStyle(color: red),),
                ),
                DropdownButton(items: categoriesDropDown,onChanged: changeSelectedCategory,value: _currentCategory,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Brand",style: TextStyle(color: red),),
                ),
                DropdownButton(items: brandsDropDown,onChanged: changeSelectedBrand,value: _currentBrand,),

              ],
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    hintText: 'Description',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return ' Enter the Product Description';
                    }
                    return null;
                  },
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                hintText: 'Quantity',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'You must enter the product';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Price',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'You must enter the  price';
                  }
                  return null;
                },
              ),
            ),
             Row(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: Text("Available Sizes"),
                 )
               ],
             ),
            Row(
              children: [
                Checkbox(value: selectedSizes.contains('XS'), onChanged: (value)=> changeSelectedSize('XS')),
                Text("XS"),
                Checkbox(value: selectedSizes.contains('S'), onChanged: (value)=> changeSelectedSize('S')),
                Text("S"),
                Checkbox(value: selectedSizes.contains('M'), onChanged: (value)=> changeSelectedSize('M')),
                Text("M"),
                Checkbox(value: selectedSizes.contains('L'), onChanged: (value)=> changeSelectedSize('L')),
                Text("L"),
                Checkbox(value: selectedSizes.contains('XL'), onChanged: (value)=> changeSelectedSize('XL')),
                Text("XL"),
              ],
            ),
            Row(
              children: [
                Checkbox(value: selectedSizes.contains('6'), onChanged: (value)=> changeSelectedSize('6')),
                Text("28"),
                Checkbox(value: selectedSizes.contains('7'), onChanged: (value)=> changeSelectedSize('7')),
                Text("30"),
                Checkbox(value: selectedSizes.contains('8'), onChanged: (value)=> changeSelectedSize('8')),
                Text("32"),
                Checkbox(value: selectedSizes.contains('9'), onChanged: (value)=> changeSelectedSize('9')),
                Text("38"),
                Checkbox(value: selectedSizes.contains('10'), onChanged: (value)=> changeSelectedSize('10')),
                Text("40"),
              ],
            ),
            Expanded(
              child: FlatButton(
                 color: red,
                 textColor: white,
                 child: Text("Add Product"),
                 onPressed: () {
                   validateAndUpload();
                 },
               ),
            ),
          ],
        ),
      ),
    );
  }

   _getCategories() async {
     List <DocumentSnapshot> data = await _categoryService.getCategories();
     setState(() {
       categories= data;
       categoriesDropDown = getCategoriesDropdown();
       _currentCategory = categories[0].data()['category'];
     });
  }

  void _getBrands() async{
    List <DocumentSnapshot> data = await _brandService.getBrands();
    setState(() {
       brands= data;
       brandsDropDown = getBrandsDropdown();
      _currentBrand = brands[0].data()['brand'];
    });
  }

      changeSelectedCategory(String selectedCategory) {
        setState(() => _currentCategory = selectedCategory);
      }
      changeSelectedBrand(String selectedBrand) {
        setState(() => _currentBrand = selectedBrand);
      }

  void changeSelectedSize( String size) {
        if(selectedSizes.contains(size)){
          setState(() {
            selectedSizes.remove(size);
          });
        }
        else{
          setState(() {
            selectedSizes.insert(0,size);
          });

        }
  }

  void _selectImage(Future<File> pickImage,int imageNumber)  async{
    File tempImg = await  pickImage;
    switch(imageNumber){
      case 1: setState(() => _image1 = tempImg);
      break;
      case 2: setState(() => _image2 = tempImg);
      break;
      case 3: setState(() => _image3 = tempImg);
    }
  }

   Widget _displayChild1() {
        if(_image1==null) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(14, 50, 14, 50),
            child: new Icon(Icons.add, color: Colors.grey,),
          );
      }
        else{
          return Image.file(_image1, fit: BoxFit.fill, width: double.infinity,);
        }
   }
      Widget _displayChild2() {
        if(_image2==null) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(14, 50, 14, 50),
            child: new Icon(Icons.add, color: Colors.grey,),
          );
        }
        else{
          return Image.file(_image2, fit: BoxFit.fill, width: double.infinity,);
        }
      }
      Widget _displayChild3() {
        if(_image3==null) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(14, 50, 14, 50),
            child: new Icon(Icons.add, color: Colors.grey,),
          );
        }
        else{
          return Image.file(_image3, fit: BoxFit.fill, width: double.infinity,);
        }
      }

            void validateAndUpload()  async {
             if(_formKey.currentState.validate()){
               setState(()=>isLoading = true);
               if(_image1 != null && _image2 !=null && _image3 !=null){
                 if(selectedSizes.isNotEmpty){

                   String imageUrl1;
                   String imageUrl2;
                   String imageUrl3;

                   firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
                   final String picture1 = "1${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";
                   firebase_storage.Reference storageReference1 = firebase_storage.FirebaseStorage.instance.ref().child('images').child(picture1);
                   final firebase_storage.UploadTask uploadTask1 = storageReference1.putFile(_image1);
                   //for picture2
                   final String picture2 = "2${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";
                   firebase_storage.Reference storageReference2 = firebase_storage.FirebaseStorage.instance.ref().child('images').child(picture2);
                   final firebase_storage.UploadTask uploadTask2 = storageReference2.putFile(_image2);
                   //for picture3
                   final String picture3 = "3${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";
                   firebase_storage.Reference storageReference3 = firebase_storage.FirebaseStorage.instance.ref().child('images').child(picture3);
                   final firebase_storage.UploadTask uploadTask3 = storageReference3.putFile(_image3);

                   firebase_storage.TaskSnapshot  snapshot1 = await  uploadTask1.then((snapshot) => snapshot);
                   firebase_storage.TaskSnapshot  snapshot2 = await  uploadTask2.then((snapshot) => snapshot);

                     uploadTask3.then((snapshot3) async{
                       imageUrl1 =await snapshot1.ref.getDownloadURL();
                       imageUrl2 =await snapshot2.ref.getDownloadURL();
                       imageUrl3 =await snapshot3.ref.getDownloadURL();

                       List<String> _imageList = [imageUrl1,imageUrl2,imageUrl3];

                       _productService.uploadProduct(productName: productNameController.text,
                         price:double.parse(priceController.text),
                         quantity: int.parse(quantityController.text),
                         description: descriptionController.text.toString(),
                         brand:_currentBrand,
                         category:_currentCategory ,
                         sizes: selectedSizes,
                         images: _imageList,

                       );
                       _formKey.currentState.reset();
                       setState(()=>isLoading = false);
                       Fluttertoast.showToast(msg: "Product added",
                         toastLength: Toast.LENGTH_SHORT,
                         gravity: ToastGravity.CENTER,
                         timeInSecForIosWeb: 1,
                         backgroundColor: Colors.grey,
                         textColor: Colors.white,
                         fontSize: 16.0,
                       );
                     });
                 }
                 else{
                   setState(()=>isLoading = false);
                   Fluttertoast.showToast(msg: "select at least 1 size",
                     toastLength: Toast.LENGTH_SHORT,
                     gravity: ToastGravity.CENTER,
                     timeInSecForIosWeb: 2,
                     backgroundColor: Colors.red,
                     textColor: Colors.white,
                     fontSize: 16.0,
                   );
                 }
               }
               else{
                 setState(()=>isLoading = false);
                 Fluttertoast.showToast(msg: "all the image must be provided",
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


