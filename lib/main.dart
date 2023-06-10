import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'authentication_page.dart';
import 'home_page.dart';
import 'user_profile.dart';
import 'welcome_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const FindMyStuffApp());
}

class FindMyStuffApp extends StatefulWidget {
  const FindMyStuffApp({Key? key}) : super(key: key);

  @override
  _FindMyStuffAppState createState() => _FindMyStuffAppState();
}

class _FindMyStuffAppState extends State<FindMyStuffApp> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    if (_firebaseAuth.currentUser != null) {
      // User is logged in, navigate to the home page
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // User is not logged in, navigate to the authentication page
      Navigator.pushReplacementNamed(context, '/authentication');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Find My Stuff',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomePage(),
        '/authentication': (context) => const AuthenticationPage(),
        '/home': (context) => const HomePage(),
        '/userProfile': (context) => const UserProfilePage(username: ''),
      },
    );
  }
}