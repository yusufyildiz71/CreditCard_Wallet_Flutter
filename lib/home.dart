import 'package:credit_cards/adiingCard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController holdernameController = TextEditingController();
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController expiryDateController = TextEditingController();
  TextEditingController cvvCodeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddingCard()));
        },
        label: Row(
          children: [
            Icon(
              Icons.credit_card,
            ),
            Text(" ADD CARD"),
          ],
        ),
        backgroundColor: Colors.green,
      ),
      appBar: AppBar(
        backgroundColor: Colors.green.shade400,
        title: Text("MY WALLET"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: Icon(Icons.exit_to_app),
              color: Colors.red,
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "CREDIT CARDS",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                ),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('creditCards')
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: Text("EMPTY WALLET"),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text("HAS ERROR"),
                      );
                    }
                    if (snapshot.hasData) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final DocumentSnapshot documentSnapshot =
                                snapshot.data!.docs[index];
                            return Column(
                              children: [
                                CreditCardWidget(
                                  cardBgColor: Colors.red,
                                  cardNumber: documentSnapshot['cardNumber'],
                                  expiryDate:
                                      documentSnapshot['expiryDate'] ?? '',
                                  cardHolderName:
                                      documentSnapshot['cardHolderName'] ?? '',
                                  cvvCode: documentSnapshot['cvvCode'] ?? '',
                                  obscureCardCvv: false,
                                  obscureCardNumber: false,
                                  showBackView: false,
                                  isHolderNameVisible: true,
                                  onCreditCardWidgetChange: (p0) {},
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: TextButton(
                                          onPressed: () {
                                            _delete(documentSnapshot.id);
                                          },
                                          child: Text(
                                            "DELETE",
                                            style:
                                                TextStyle(color: Colors.white),
                                          )),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: TextButton(
                                          onPressed: () {
                                            _update(documentSnapshot);
                                          },
                                          child: Text(
                                            "UPDATE",
                                            style:
                                                TextStyle(color: Colors.white),
                                          )),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                      );
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _delete(String pId) async {
    await FirebaseFirestore.instance
        .collection('creditCards')
        .doc(pId)
        .delete();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("You have successfully deleted a credit card")));
  }

  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      holdernameController.text = documentSnapshot['cardHolderName'];
      cardNumberController.text = documentSnapshot['cardNumber'];
      expiryDateController.text = documentSnapshot['expiryDate'];
      cvvCodeController.text = documentSnapshot['cvvCode'];
    }
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: holdernameController,
                  decoration: InputDecoration(hintText: "Holder Name"),
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: cardNumberController,
                  decoration: InputDecoration(hintText: "Card Number"),
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: expiryDateController,
                  decoration: InputDecoration(hintText: "Expiry Date (MM/YY)"),
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: cvvCodeController,
                  decoration: InputDecoration(hintText: "CVV"),
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      final String HolderName = holdernameController.text;
                      final String CardNumber = cardNumberController.text;
                      final String ExpiryDate = expiryDateController.text;
                      final String CvvNumber = cvvCodeController.text;

                      FirebaseFirestore.instance
                          .collection('creditCards')
                          .doc(documentSnapshot!.id)
                          .update({
                        "cardHolderName": HolderName,
                        "cardNumber": CardNumber,
                        "cvvCode": CvvNumber,
                        "expiryDate": ExpiryDate
                      });
                      holdernameController.text = "";
                      cardNumberController.text = "";
                      expiryDateController.text = "";
                      cvvCodeController.text = "";
                    },
                    child: Text("UPDATE"),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green),
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }
}
