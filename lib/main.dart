import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:matbakhna_mobile/features/favorites/screens/favorites_screen.dart';
import 'features/auth/providers/auth_service.dart';
import 'features/home/screens/home_screen.dart';
import 'features/listing/screens/listing_screen.dart';


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
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
      home:  FavoritesScreen(),
    );
  }
}
