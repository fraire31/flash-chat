import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import './chat_screen.dart';
import '../constants.dart';
import '../widgets/round_button.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'register';

  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth
      .instance; //underscore mains only this file can access this variable and since we dont want this variables value to change we will have it a 'final'

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
                      //Do something with the user input.
                    },
                    decoration:
                        kInputDecoration.copyWith(hintText: 'Enter Email'),
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
                    text: 'Register',
                    buttonColor: Colors.lightBlue,
                    onPress: () async {
                      setState(() {
                        showSpinner = true;
                      });
                      try {
                        //here we are capturing the new user instance in a variable since it is a Future obj and we dont know exactly when well have the obj
                        final newUser =
                            await _auth.createUserWithEmailAndPassword(
                          email: email,
                          password: password,
                        );
                        if (newUser != null) {
                          Navigator.pushNamed(context, ChatScreen.id);
                        }
                        setState(() {
                          showSpinner = false;
                        });
                      } catch (e) {
                        print(e);
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
