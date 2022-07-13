import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_3.dart';

import './login_screen.dart';
import './welcome_screen.dart';
import '../constants.dart';

final _firestore = FirebaseFirestore.instance;
User? loggedInUser;

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';

  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  String? messageText;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    // messagesStream();
    // getMessages();
  }

  void getCurrentUser() {
    final user = _auth.currentUser;
    if (user != null) {
      loggedInUser = user;
    } else {
      Navigator.pushNamed(context, LoginScreen.id);
    }
  }

  // void getMessages() async {
  //   final messages = await _firestore
  //       .collection('messages')
  //       .where('sender', isEqualTo: loggedInUser.email)
  //       .get()
  //       .then((QuerySnapshot querySnapshot) {
  //     querySnapshot.docs.forEach((doc) {
  //       print(doc.data());
  //     });
  //   });
  // }

  // void messagesStream() async {
  //   await for (var snapshot in _firestore
  //       .collection('messages')
  //       .where('sender', isEqualTo: loggedInUser!.email)
  //       .snapshots()) {
  //     for (var message in snapshot.docs) {
  //       print(message.data());
  //     }
  //   }
  //   ;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.popAndPushNamed(context, WelcomeScreen.id);
              }),
        ],
        title: const Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const MessageStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                        //Do something with the user input.
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      messageTextController.clear();
                      _firestore.collection('messages').add(
                        {
                          'text': messageText,
                          'sender': loggedInUser!.email,
                          'timestamp': DateTime.now()
                        },
                      );
                      //Implement send functionality.
                    },
                    child: const Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  const MessageBubble(
      {Key? key, required this.text, required this.sender, required this.isMe})
      : super(key: key);

  final String sender;
  final String text;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: const TextStyle(
              fontSize: 12.0,
            ),
          ),
          if (isMe)
            ChatBubble(
              elevation: 0,
              clipper: ChatBubbleClipper3(type: BubbleType.sendBubble),
              alignment: Alignment.topRight,
              backGroundColor: Colors.lightBlueAccent,
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                ),
                child: Text(text),
              ),
            ),
          if (!isMe)
            ChatBubble(
              elevation: 0,
              clipper: ChatBubbleClipper3(type: BubbleType.receiverBubble),
              backGroundColor: Colors.lightBlue,
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                ),
                child: Text(text),
              ),
            )
        ],
      ),
    );
  }
}

class MessageStream extends StatelessWidget {
  const MessageStream({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('messages')
          .orderBy('timestamp', descending: false)
          .snapshots(), //here is the data going to come from
      builder: (context, snapshot) {
        const centerWidget = Center(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          ),
        );

        List<MessageBubble> messageBubbles = [];
        if (!snapshot.hasData) {
          return centerWidget;
        }

        final docs = snapshot.data!.docs.reversed;
        for (var doc in docs) {
          Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;

          final messageText = data['text'];
          final messageSender = data['sender'];

          final currentUser = loggedInUser!.email;

          final messageBubble = MessageBubble(
            sender: messageSender,
            text: messageText,
            isMe: currentUser == messageSender,
          );

          messageBubbles.add(messageBubble);
        }

        return Expanded(
          child: ListView(
            reverse: true,
            children: messageBubbles,
          ),
        );
      },
    );
  }
}
