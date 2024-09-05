import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _messegeController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _messegeController.dispose();
  }

  _sendMessage() async {
    final user = await FirebaseAuth.instance.currentUser!.uid;
    final userData =
        await FirebaseFirestore.instance.collection('users').doc(user).get();
    if (_messegeController.text.trim().isEmpty) {
      return;
    }
    try {
      final message = _messegeController.text;
      _messegeController.clear();
      FocusScope.of(context).unfocus();

      print("=============name==============${userData.data()!['name']}");
      await FirebaseFirestore.instance.collection('chat').add({
        'text': message,
        'createdAt': Timestamp.now(),
        'userId': user,
        'image': userData.data()!['image'],
        'username': userData.data()!['name']
      });
    } catch (e) {
      print('=-=-=-=-=--=-${userData.data()!['name']}=-=-=-=--=-=$e');
      print("=============name==============${userData.data()!['name']}");
    }
    //
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 15, right: 1, bottom: 14),
      child: Row(
        children: [
          Expanded(
              child: TextField(
            controller: _messegeController,
            decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(35)),
                labelText: 'Messege'),
          )),
          IconButton(
              onPressed: () {
                _sendMessage();
              },
              icon: Icon(Icons.send))
        ],
      ),
    );
  }
}
