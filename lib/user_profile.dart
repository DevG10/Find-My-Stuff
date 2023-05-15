import 'package:flutter/material.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
      ),
      body: const Center(
        child: Text(
          'User Profile',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
