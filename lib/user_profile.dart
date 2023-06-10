import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'authentication_page.dart';

class UserProfilePage extends StatefulWidget {
  final String username;

  const UserProfilePage({Key? key, required this.username}) : super(key: key);

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? _user;

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  Future<void> _getUser() async {
    final user = _firebaseAuth.currentUser;
    setState(() {
      _user = user;
    });
  }

  Future<void> _signOut(BuildContext context) async {
    _firebaseAuth.signOut();
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const AuthenticationPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _signOut(context),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 64,
              child: Icon(
                Icons.person,
                size: 64,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Welcome,',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              widget.username,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: ListTile(
                leading: const Icon(Icons.email),
                title: Text(_user?.email ?? 'N/A'),
                subtitle: const Text('Email'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
