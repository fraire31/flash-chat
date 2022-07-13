import 'package:flutter/material.dart';

import './screens/chat_screen.dart';
import './screens/login_screen.dart';
import './screens/registration_screen.dart';
import './screens/welcome_screen.dart';

void main() => runApp(FlashChat());

class FlashChat extends StatelessWidget {
  const FlashChat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData.dark().copyWith(
          textTheme: const TextTheme(
            bodyText1: TextStyle(color: Colors.black54),
          ),
        ),
        initialRoute: WelcomeScreen.id,
        routes: {
          WelcomeScreen.id: (context) => const WelcomeScreen(),
          RegistrationScreen.id: (context) => const RegistrationScreen(),
          LoginScreen.id: (context) => const LoginScreen(),
          ChatScreen.id: (context) => const ChatScreen(),
        });
  }
}
