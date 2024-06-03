import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:splash_view/source/source.dart';
import 'package:tap2024/screens/login_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SplashView(
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Colors.blue,
            Colors.white,
          ]
        ),
        logo: Lottie.asset(
          'assets/logo_tecnm.json', 
          height: MediaQuery.of(context).size.height * .5
        ),
        done: Done(const LoginScreen()),
        duration: const Duration(milliseconds: 5450),
        bottomLoading: true,
      )
    );
  }
}