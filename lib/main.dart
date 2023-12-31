import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'pages/auth_page.dart';
import 'pages/chat_page.dart';
import 'pages/launcher_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final Future<FirebaseApp> firebaseInitialization = Firebase.initializeApp();

    return FutureBuilder(
      future: firebaseInitialization,
      builder: (context, snapshot) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Chat',
          theme: ThemeData(
            primarySwatch: Colors.brown,
            backgroundColor: Colors.grey,
            buttonTheme: ButtonTheme.of(context).copyWith(
              buttonColor: Colors.brown,
              textTheme: ButtonTextTheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          home: snapshot.connectionState != ConnectionState.done
              ? const LauncherPage()
              : StreamBuilder(
                  stream: FirebaseAuth.instance.authStateChanges(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const LauncherPage();
                    }
                    if (snapshot.hasData) {
                      return const ChatPage();
                    }
                    return const AuthPage();
                  },
                ),
        );
      },
    );
  }
}
