import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AddingCard extends StatefulWidget {
  const AddingCard({super.key});

  @override
  State<AddingCard> createState() => _AddingCardState();
}

class _AddingCardState extends State<AddingCard> {
  TextEditingController holdernameController = TextEditingController();
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController expiryDateController = TextEditingController();
  TextEditingController cvvCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ADD A CARD"),
        backgroundColor: Colors.green.shade400,
      ),
      body: SingleChildScrollView(
        child: Center(
            child: Column(
          children: [
            Container(
              height: 300,
              width: 300,
              child: Lottie.asset('assets/33275-cards-payment.json'),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 30, left: 30, top: 20),
              child: TextField(
                controller: holdernameController,
                decoration: customInputDecoration("Holder Name"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 30, left: 30, top: 20),
              child: TextField(
                controller: cardNumberController,
                decoration: customInputDecoration("Card Number"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 30, left: 30, top: 20),
              child: TextField(
                controller: expiryDateController,
                decoration: customInputDecoration("Expiry Date (MM/YY)"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 30, left: 30, top: 20),
              child: TextField(
                controller: cvvCodeController,
                decoration: customInputDecoration("CVV"),
              ),
            ),
            Padding(
                padding: EdgeInsets.all(15),
                child: TextButton(
                    onPressed: () {
                      FirebaseFirestore.instance.collection('creditCards').add({
                        "cardHolderName": holdernameController.text,
                        "cardNumber": cardNumberController.text,
                        "cvvCode": cvvCodeController.text,
                        "expiryDate": expiryDateController.text
                      });
                      holdernameController.text = '';
                      cardNumberController.text = '';
                      cvvCodeController.text = '';
                      expiryDateController.text = '';
                    },
                    child: Container(
                      height: 50,
                      width: 120,
                      margin: EdgeInsets.symmetric(horizontal: 60),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.green),
                      child: const Center(
                        child: Text(
                          "+",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ))),
          ],
        )),
      ),
    );
  }

  InputDecoration customInputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
      enabledBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.green)),
      focusedBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.green)),
    );
  }
}
