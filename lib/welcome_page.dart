import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

import 'authentication_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  void navigateToAuthentication(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const AuthenticationPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blue, // Replace with your desired background color
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText(
                    'Welcome to Find My Stuff!',
                    textStyle: const TextStyle(
                        fontSize: 28,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                    speed: const Duration(milliseconds: 100),
                  ),
                ],
                totalRepeatCount: 1,
                pause: const Duration(milliseconds: 1000),
                displayFullTextOnTap: true,
                stopPauseOnTap: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => navigateToAuthentication(context),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.green),
                  minimumSize: MaterialStateProperty.all<Size>(
                    const Size(
                        150, 50), // Adjust the width and height as desired
                  ),
                ),
                child: const Text(
                  'Get Started',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    // Adjust the font size as desired
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
