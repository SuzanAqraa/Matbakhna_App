import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

// YOUR IMPORTS
import 'views/screens/sliderimages.dart'; // ImagesWidget
import 'views/screens/home_screen.dart'; // HomePage
import 'views/screens/login_screen.dart'; // LoginScreen

import 'core/services/auth_service.dart';
import 'views/screens/favorites_screen.dart';
import 'views/screens/listing_screen_wrapper.dart';
import 'views/screens/profile_screen.dart';
import 'views/screens/post_screen.dart';
import 'views/screens/recipe_detail_screen.dart';
import 'views/screens/filter_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();


  

  setupCurrentUserListener();

  runApp(MaterialApp(
   
    title: 'Smart Recipe App',
    builder: (context, child) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: child!,
      );
    },
    initialRoute: '/',
    onGenerateRoute: (settings) {
      switch (settings.name) {
        case '/':
          return MaterialPageRoute(builder: (_) => const HomePage());
        case '/profile':
          return MaterialPageRoute(builder: (_) => ProfileScreen());
        case '/favorites':
          return MaterialPageRoute(builder: (_) => const FavoritesScreen());
        case '/listing':
          final String query = settings.arguments as String;
          return MaterialPageRoute(
            builder: (_) => ListingScreenWrapper(searchQuery: query),
          );
        case '/post':
          final recipeId = settings.arguments as String;
          return MaterialPageRoute(
            builder: (_) => PostPage(recipeId: recipeId),
          );
        case '/recipeDetail':
          final recipeId = settings.arguments as String;
          return MaterialPageRoute(
            builder: (_) => RecipePage(recipeId: recipeId),
          );
        case '/filter':
          return MaterialPageRoute(builder: (_) => FilterScreen());
        case '/login_screen':
          return MaterialPageRoute(builder: (_) => const LoginScreen());
        default:
          return MaterialPageRoute(
            builder: (_) => Scaffold(
              body: Center(
                child: Text('لا يوجد صفحة لهذا الراوت: ${settings.name}'),
              ),
            ),
          );
      }
    },
  ));
}