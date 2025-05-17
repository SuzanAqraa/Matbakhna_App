import 'package:flutter/material.dart';
import 'features/listing/screens/listing_screen.dart';
//import 'features/onboarding/AboutAppscreen/question.dart';
//import 'features/onboarding/AboutAppscreen/aboutapp.dart';
//import 'features/onboarding/logoScreen/splashsceen.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Recipe App',
      home: ListingScreen(),
    );
  }
}