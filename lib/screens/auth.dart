import 'dart:io';

import 'package:chat/widgets.dart/user_image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  String? _email;
  String? _passowrd;
  String? _userNmae;
  var _isLogin = true;
  File? pickedImage;

  void _submit() async {
    if (_isLogin) {
      final valid = _formKey.currentState!.validate();
      if (valid) {
        _formKey.currentState!.save();
      } else {
        return;
      }
      setState(() {
        _isLoading = true;
      });
      try {
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _email!, password: _passowrd!);
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Logged in!')));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'invalid-email') {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('The email address is not valid.')),
          );
        } else if (e.code == 'user-not-found') {
          print('-------------------------FirebaseAuthException: ${e.code}');

          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('No user found for that email.')));
        } else if (e.code == 'wrong-password') {
          print('-------------------------FirebaseAuthException: ${e.code}');

          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Wrong password provided for that user.'),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Email or password not valid')));
        }
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      final valid = _formKey.currentState!.validate();
      if (valid && pickedImage != null) {
        _formKey.currentState!.save();
      } else {
        return;
      }
      setState(() {
        _isLoading = true;
      });
      try {
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _email!,
          password: _passowrd!,
        );
        var uid = credential.user!.uid;
        final Reference storageRef = FirebaseStorage.instance
            .ref()
            .child('users_images')
            .child('${uid}.jpg');
        await storageRef.putFile(pickedImage!);
        final imageUrl = await storageRef.getDownloadURL();
        print('=====================================$_userNmae');
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'name': _userNmae,
          "image": imageUrl,
          'email': _email
        }).onError((e, _) => print(
            "===================================================Error writing document: $e"));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'invalid-email') {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('The email address is not valid.')),
          );
        }
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('The password provided is too weak.')));
        } else if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('The account already exists for that email.')));
        }
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 200,
                margin:
                    EdgeInsets.only(top: 30, bottom: 30, left: 20, right: 20),
                child: Image.asset('images/chat3.png'),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  'FriendLink',
                  style: TextStyle(
                    fontSize: 25,
                    color: Color(0xfff0e4d6),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  _isLogin ? 'Login' : 'SignUp',
                  style: TextStyle(
                    fontSize: 22,
                    color: Color(0xfff0e4d6),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Card(
                margin: EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          if (!_isLogin)
                            UserImagePicker(
                              onPickedImage: (File file) {
                                pickedImage = file;
                              },
                            ),
                          if (!_isLogin)
                            TextFormField(
                              onSaved: (newValue) => _userNmae = newValue,
                              decoration: InputDecoration(
                                labelText: "User name",
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null) {
                                  return 'Enter user name';
                                }
                                return null;
                              },
                              autocorrect: false,
                              textCapitalization: TextCapitalization.none,
                            ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            onSaved: (newValue) => _email = newValue,
                            decoration: InputDecoration(
                              labelText: "Email",
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty ||
                                  !value.contains('@')) {
                                return 'Email is not valid';
                              }
                              return null;
                            },
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.trim().length < 4) {
                                return 'Passowrd should be > 4';
                              }
                              return null;
                            },
                            onSaved: (newValue) => _passowrd = newValue,
                            decoration: InputDecoration(
                              labelText: "Password",
                              border: OutlineInputBorder(),
                            ),
                            obscureText: true,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _submit();
                            },
                            child: _isLoading
                                ? CircularProgressIndicator()
                                : Text(_isLogin ? 'Login' : 'SignUp'),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer),
                          ),
                          TextButton(
                              onPressed: () {
                                setState(() {
                                  _isLogin = !_isLogin;
                                });
                              },
                              child: Text(_isLogin
                                  ? 'Create an account'
                                  : 'I already have an account'))
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
