import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'authentication_page.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with SingleTickerProviderStateMixin {
  bool isButtonAnimated = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _scaleAnimation =
        Tween<double>(begin: 1.0, end: 0.9).animate(_animationController);
  }

  void navigateToAuthentication(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const AuthenticationPage()),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black12,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedTextKit(
                animatedTexts: [
                  ColorizeAnimatedText(
                    'Welcome to Find My Stuff!',
                    textStyle: GoogleFonts.ubuntu(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                    colors: [
                      Colors.blueAccent,
                      Colors.red,
                      Colors.purple,
                      Colors.pinkAccent,
                      // Colors.,
                      Colors.black12,
                    ],
                    textAlign: TextAlign.center,
                    speed: const Duration(milliseconds: 1000),
                  ),
                ],
                repeatForever: true,
                pause: const Duration(milliseconds: 100),
                displayFullTextOnTap: true,
                stopPauseOnTap: false,
              ),
              const SizedBox(height: 36),
              GestureDetector(
                onTap: () {
                  navigateToAuthentication(context);
                },
                onTapDown: (_) {
                  _animationController.forward();
                  setState(() {
                    isButtonAnimated = true;
                  });
                },
                onTapUp: (_) {
                  _animationController.reverse();
                  setState(() {
                    isButtonAnimated = false;
                  });
                },
                onTapCancel: () {
                  _animationController.reverse();
                  setState(() {
                    isButtonAnimated = false;
                  });
                },
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (BuildContext context, Widget? child) {
                    return Transform.scale(
                      scale: isButtonAnimated ? _scaleAnimation.value : 1.0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.purple,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 16),
                        child: const Text(
                          'Get Started',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
