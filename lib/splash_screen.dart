import 'package:e_commerce_demo_project/login_page.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double maxHeight = MediaQuery.of(context).size.height;
    double maxWidth = MediaQuery.of(context).size.width;
    navigateToScreen(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/e-comm-img(2).png",
              height: maxHeight,
              width: maxWidth,
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),
    );
  }
}

void navigateToScreen(BuildContext context) {
  Future.delayed(Duration(seconds: 4), () {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) {
          return LoginScreen();
        },
      ),
    );
  });
}
