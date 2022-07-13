import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import './registration_screen.dart';
import '../../screens/login_screen.dart';
import '../widgets/round_button.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome';
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      setState(() {});
    });
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    animation =
        ColorTween(begin: Colors.pink, end: Colors.yellow).animate(controller);

    controller.forward();

    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print(MediaQuery.of(context).size.width);
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Hero(
                  tag: 'logo',
                  child: SizedBox(
                    child: Image.asset('images/logo.png'),
                    height: 75.0,
                  ),
                ),
                LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.minWidth <= 375) {
                      return AnimatedTextKit(
                        repeatForever: true,
                        animatedTexts: [
                          TyperAnimatedText(
                            'Flash Chat',
                            textStyle: const TextStyle(
                              color: Colors.grey,
                              fontSize: 40.0,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      );
                    } else {
                      return AnimatedTextKit(
                        repeatForever: true,
                        animatedTexts: [
                          TyperAnimatedText(
                            'Flash Chat',
                            textStyle: const TextStyle(
                              color: Colors.grey,
                              fontSize: 45.0,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      );
                    }
                  },
                )
              ],
            ),
            const SizedBox(height: 48.0),
            RoundButton(
              text: 'Log In',
              buttonColor: Colors.lightBlueAccent,
              onPress: () {
                Navigator.push(context, MyRoute(builder: (_) => LoginScreen()));
              },
            ),
            RoundButton(
              text: 'Register',
              buttonColor: Colors.lightBlue,
              onPress: () {
                Navigator.push(
                    context, MyRoute(builder: (_) => RegistrationScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MyRoute extends MaterialPageRoute {
  MyRoute({WidgetBuilder? builder}) : super(builder: builder!);

  @override
  Duration get transitionDuration => const Duration(milliseconds: 800);
}
