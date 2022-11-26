import 'package:credit_cards/Auth/login.dart';
import 'package:credit_cards/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.green.shade100,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: height * .45,
              child: Lottie.asset('assets/CC.json'),
            ),
            Text(
              "Welcome to CreditWallet",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 30, left: 30, top: 20),
              child: TextField(
                controller: emailController,
                decoration: customInputDecoration("E-Mail"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 30, left: 30, top: 10),
              child: TextField(
                controller: passwordController,
                decoration: customInputDecoration("Password"),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15),
              child: TextButton(
                  onPressed: () {
                    signUp();
                  },
                  child: Container(
                    height: 50,
                    width: 120,
                    margin: EdgeInsets.symmetric(horizontal: 60),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.green,
                    ),
                    child: Center(
                      child: Text(
                        "SIGN UP",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                        ),
                      ),
                    ),
                  )),
            ),
            buildHaveAccount(context),
          ],
        ),
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

  RichText buildHaveAccount(BuildContext context) {
    return RichText(
        text: TextSpan(
            style: TextStyle(color: Colors.black, fontSize: 16),
            text: "Have a account?",
            children: [
          TextSpan(
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Login()));
                },
              text: " Login",
              style: TextStyle(
                decoration: TextDecoration.underline,
                color: Colors.green,
              ))
        ]));
  }

  Future signUp() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
              child: CircularProgressIndicator(),
            ));
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
    } on FirebaseAuthException catch (e) {
      print(e);
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
