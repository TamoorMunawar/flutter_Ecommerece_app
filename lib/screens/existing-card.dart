import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:flutter_ecommerce_app/service/payment-service.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:progress_dialog/progress_dialog.dart';
class ExistingCard extends StatefulWidget {
  @override
  _ExistingCardState createState() => _ExistingCardState();
}

class _ExistingCardState extends State<ExistingCard> {
  List cards = [{
    'cardNumber': '4242424242424242',
    'expiryDate': '04/24',
    'cardHolderName': 'Muhammad Ahsan Ayaz',
    'cvvCode': '424',
    'showBackView': false,
  }, {
    'cardNumber': '5555555555554444',
    'expiryDate': '04/23',
    'cardHolderName': 'Tracer',
    'cvvCode': '123',
    'showBackView': false,
  }];
  payViaExistingCard(BuildContext context, card) async {
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
    var expiryArr = card['expiryDate'].split('/');
    CreditCard stripeCard = CreditCard(
      number:card['cardNumber'],
      expMonth: int.parse(expiryArr[0]),
      expYear:int.parse(expiryArr[1]),
    );
    var response = await StripeService.payViaExistingCard(
        "2500",
        "USD",
        stripeCard ,
    );
      await dialog.hide();
      Scaffold.of(context).showSnackBar(
        SnackBar(content: Text(response.message),
          duration: new Duration(milliseconds: 1200),
        ),
      ).closed.then((_){
           Navigator.pop(context);
      });


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: Colors.red,
        title: Text('Pay via existing card'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: ListView.builder(
        itemCount: cards.length,
        itemBuilder: (BuildContext context,int index){
          var card = cards[index];
          return InkWell(
            onTap: (){
              payViaExistingCard(context , card);
            },
            child: CreditCardWidget(
              cardNumber: card['cardNumber'],
              expiryDate: card['expiryDate'],
              cardHolderName: card['cardHolderName'],
              cvvCode: card['cvvCode'],
              showBackView: false, //true when you want to show cvv(back) view
            ),
          );
        },
        ),
      ),
    );
  }
}
