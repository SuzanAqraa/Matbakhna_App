import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'features/recipes/screens/recipe_detail_screen.dart';

void main() async{
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
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          primary: Color(0xFFA5C8A6),      // الأخضر الفاتح
          secondary: Color(0xFFE56B50),   // البرتقالي
          background: Color(0xFFE8DCCF),  // بيج فاتح
          onPrimary: Color(0xFF3D3D3D),   // للنص على اللون الأساسي
        ),
        useMaterial3: true,
      ),

      home: const RecipePage(),
    );
  }
}
