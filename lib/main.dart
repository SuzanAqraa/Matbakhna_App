import 'package:flutter/material.dart';

import 'features/listing/screens/listing_screen.dart';
//import 'features/onboarding/AboutAppscreen/question.dart';
//import 'features/onboarding/AboutAppscreen/aboutapp.dart';
//import 'features/onboarding/logoScreen/splashsceen.dart';
import 'features/auth/providers/auth_service.dart';
import 'features/home/screens/home_screen.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();


  await Firebase.initializeApp();
  setupCurrentUserListener();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Recipe App',

      home: ListingScreen(),

      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
    
    );
  }
}