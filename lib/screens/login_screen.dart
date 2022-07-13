import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../constants.dart';
import '../screens/chat_screen.dart';
import '../widgets/round_button.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late String email;
  late String password;
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.lightBlueAccent,
        ),
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 15.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Hero(
                    tag: 'logo',
                    child: SizedBox(
                      height: 200.0,
                      child: Image.asset('images/logo.png'),
                    ),
                  ),
                  const SizedBox(
                    height: 48.0,
                  ),
                  TextField(
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    onChanged: (value) {
                      email = value;
                    },
                    decoration:
                        kInputDecoration.copyWith(hintText: 'Enter your Email'),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  TextField(
                    textAlign: TextAlign.center,
                    obscureText: true,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    onChanged: (value) {
                      password = value;
                    },
                    decoration: kInputDecoration.copyWith(
                        hintText: 'Enter your password'),
                  ),
                  const SizedBox(
                    height: 24.0,
                  ),
                  RoundButton(
                    text: 'Log In',
                    buttonColor: Colors.lightBlueAccent,
                    onPress: () async {
                      try {
                        setState(() {
                          showSpinner = true;
                        });
                        UserCredential userCredential = await FirebaseAuth
                            .instance
                            .signInWithEmailAndPassword(
                          email: email,
                          password: password,
                        );
                        Navigator.pushNamed(context, ChatScreen.id);
                        setState(() {
                          showSpinner = false;
                        });
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found') {
                          print('No user found for that email.');
                        } else if (e.code == 'wrong-password') {
                          print('Wrong password provided for that user.');
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
