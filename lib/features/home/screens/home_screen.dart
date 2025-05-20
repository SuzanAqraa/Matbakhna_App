import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/widgets/PrimaryAppBar.dart';
import '../../../core/widgets/custom_bottom_navbar.dart';
import '../widgets/CookingTipCard.dart';
import '../widgets/TryTodaySection.dart';
import '../widgets/most_popular_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> recipes = [];
  List<Map<String, dynamic>> mostPopularRecipes = [];

  @override
  void initState() {
    super.initState();
    _fetchRecipesFromFirestore();
  }

  Future<void> _fetchRecipesFromFirestore() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('recipes').get();

      final fetchedRecipes =
          snapshot.docs.map((doc) {
            final data = doc.data();
            int likes = (data['likes'] ?? 0) as int;
            int comments = (data['comments'] ?? 0) as int;
            int totalInteractions = likes + comments;
            print('Description: ${data['Description']}');
            return {
              'id': doc.id,
              'imageUrl': data['imageUrl'] ?? '',
              'title': data['Title'] ?? '',
              'description': data['Description'] ?? '',
              'time': data['duration'] ?? '',
              'likes': likes,
              'comments': comments,
              'totalInteractions': totalInteractions,
            };
          }).toList();

      fetchedRecipes.sort(
        (a, b) => b['totalInteractions'].compareTo(a['totalInteractions']),
      );

      List<Map<String, dynamic>> popularRecipes;
      bool hasInteractions = fetchedRecipes.any(
        (recipe) => recipe['totalInteractions'] > 0,
      );

      if (hasInteractions) {
        popularRecipes = fetchedRecipes.take(5).toList();
      } else {
        popularRecipes = List.from(fetchedRecipes);
        popularRecipes.shuffle();
        popularRecipes = popularRecipes.take(5).toList();
      }

      setState(() {
        recipes = fetchedRecipes;

        mostPopularRecipes = popularRecipes;
      });
    } catch (e) {
      print('Error fetching recipes: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> contentWidgets = [];

    contentWidgets.add(const HomeAppBar(title: 'شو بدك تطبخ اليوم؟'));
    contentWidgets.add(const SizedBox(height: 20));

    if (recipes.isEmpty) {
      contentWidgets.add(const Center(child: CircularProgressIndicator()));
    } else {
      contentWidgets.add(
        GestureDetector(
          onTap: null,
          child: TryTodaySection(recipe: recipes[0]),
        ),
      );

      contentWidgets.add(const SizedBox(height: 10));
      contentWidgets.add(const CookingTipCard());

      contentWidgets.add(const SizedBox(height: 10));
      contentWidgets.add(MostPopularSection(recipes: mostPopularRecipes));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFDF5EC),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(child: Column(children: contentWidgets)),
      ),
      bottomNavigationBar: const CustomBottomNavbar(currentIndex: 1),
    );
  }
}
