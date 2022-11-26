import 'package:credit_cards/Auth/register.dart';
import 'package:credit_cards/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

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
              child: LottieBuilder.asset('assets/CC.json'),
            ),
            Text(
              "Welcome to CreditWallet",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.green),
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
                      signIn();
                    },
                    child: Container(
                      height: 50,
                      width: 120,
                      margin: EdgeInsets.symmetric(horizontal: 60),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.green),
                      child: Center(
                        child: Text(
                          "LOGIN",
                          style: TextStyle(color: Colors.white, fontSize: 22),
                        ),
                      ),
                    ))),
            buildNoAccount(context),
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

  RichText buildNoAccount(BuildContext context) {
    return RichText(
        text: TextSpan(
            style: const TextStyle(color: Colors.black, fontSize: 16),
            text: "No Account? ",
            children: [
          TextSpan(
              // hesabın olmaması burda
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Register()));
                },
              text: 'Sign Up',
              style: const TextStyle(
                decoration: TextDecoration.underline,
                color: Colors.green,
              )),
        ]));
  }

  Future signIn() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: CircularProgressIndicator(),
      ),
    );
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
    } on FirebaseAuthException catch (e) {
      print(e);
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
