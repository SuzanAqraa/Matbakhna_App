import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:matbakhna_mobile/features/recipes/screens/recipe_detail_screen.dart';
import 'core/constants/theme.dart';
import 'features/home/screens/home_screen.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Recipe App',
      theme: appTheme,
      home: const HomePage(),
    );
  }
}