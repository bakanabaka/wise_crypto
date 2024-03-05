import 'package:crypto_app/view/bottom_bar_view.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../utils/constants.dart';
import '../../utils/extensions/lottie_extension.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OnBoardingView3 extends StatefulWidget {
  const OnBoardingView3({Key? key}) : super(key: key);

  @override
  State<OnBoardingView3> createState() => _OnBoardingView3State();
}

class _OnBoardingView3State extends State<OnBoardingView3>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: DurationConstants.lottieMedium(),
    );
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signInWithEmailAndPassword(BuildContext context) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Navigate to the BottomBarView page on successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => BottomBarView(),
        ),
      );
    } catch (e) {
      print('Error signing in: $e');
      // Handle sign-in errors
      String errorMessage = 'An error occurred during login.';

      // Check the type of exception and provide specific error messages
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'user-not-found':
            errorMessage = 'No user found with that email.';
            break;
          case 'wrong-password':
            errorMessage = 'Incorrect password.';
            break;
          case 'invalid-email':
            errorMessage = 'The email address is not valid.';
            break;
          default:
            errorMessage = 'Invalid credentials.';
        }
      }

      // Show error message to the user
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Login Failed'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _signUpWithEmailAndPassword(BuildContext context) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Show signup success message
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Signup Successful'),
          content: Text('You have successfully signed up!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      print('Error signing up: $e');
      // Handle sign-up errors
      String errorMessage = 'An error occurred during signup.';

      // Check the type of exception and provide specific error messages
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'weak-password':
            errorMessage = 'The password provided is too weak.';
            break;
          case 'email-already-in-use':
            errorMessage = 'The account already exists for that email.';
            break;
          case 'invalid-email':
            errorMessage = 'The email address is not valid.';
            break;
          default:
            errorMessage = 'A non-empty password must be provided.';
        }
      }

      // Show error message to the user
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Signup Failed'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 150),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LottieBuilder.asset(
              LottieEnum.onboard1.lottiePath,
              fit: BoxFit.cover,
              animate: true,
              repeat: true,
              controller: _animationController,
              onLoaded: (p0) {
                _animationController.forward();
                _animationController.repeat();
              },
            ),
            const Text(
              "Realtime Data",
              style: onBoardTitle,
            ),
            const SizedBox(
              height: 10,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                "Track your cryptocurrency portfolio in realtime.",
                style: onBoardDescription,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            // Login and Signup Form
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                  ),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(labelText: 'Password'),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () => _signInWithEmailAndPassword(context),
                        child: const Text('Login'),
                      ),
                      ElevatedButton(
                        onPressed: () => _signUpWithEmailAndPassword(context),
                        child: const Text('Sign Up'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
