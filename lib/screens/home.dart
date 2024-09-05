import 'package:chat/widgets.dart/chat_messages.dart';
import 'package:chat/widgets.dart/new_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("FriendLink"),
          backgroundColor: Theme.of(context).colorScheme.primary,
          actions: [
            IconButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                },
                icon: Icon(Icons.exit_to_app))
          ],
        ),
        body: Center(
            child: Column(
          children: [
            Expanded(child: ChatMessages()),
            SizedBox(
              height: 10,
            ),
            NewMessage()
          ],
        )),
      ),
    );
  }
}
