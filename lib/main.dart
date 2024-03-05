import 'package:crypto_app/view/onboard/onboarding_view.dart';
import 'package:crypto_app/view_model/onboard/onboarding_view_model.dart';
import 'package:crypto_app/view_model/wallet_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("Firebase connected successfully!");
  } on FirebaseException catch (e) {
    // Handle Firebase initialization error
    print("Firebase initialization error:");
  }
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => WalletViewModel()),
        ChangeNotifierProvider(create: (context) => OnBoardingViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blue, fontFamily: "MontserratAlternates"),
      home: const OnBoardingView(),
    );
  }
}
