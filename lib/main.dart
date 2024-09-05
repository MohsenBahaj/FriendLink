import 'package:chat/firebase_options.dart';
import 'package:chat/screens/auth.dart';
import 'package:chat/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FriendLink',
      theme: ThemeData(
        textTheme: GoogleFonts.quicksandTextTheme(),
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(204, 219, 175, 31)),
        useMaterial3: true,
      ),
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return const Home();
            } else {
              return AuthScreen();
            }
          }),
    );
  }
}
