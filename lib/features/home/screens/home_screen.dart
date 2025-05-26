import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:matbakhna_mobile/Models/recipe_model.dart';
import '../../../core/widgets/PrimaryAppBar.dart';
import '../../../core/widgets/custom_bottom_navbar.dart';
import '../../../core/services/auth_service.dart';
import '../../listing/screens/listing_screen.dart';
import '../widgets/CookingTipCard.dart';
import '../widgets/TryTodaySection.dart';
import '../widgets/most_popular_section.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<RecipeModel> recipes = [];
  List<RecipeModel> mostPopularRecipes = [];
  RecipeModel? tryTodayRecipe;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchRecipesFromFirestore();
  }

  Future<void> _fetchRecipesFromFirestore() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('recipes').get();

      final fetchedRecipes = snapshot.docs.map((doc) {
        final data = doc.data();
        final id = doc.id;

        final recipe = RecipeModel.fromJson(id, data);
        int totalInteractions = recipe.numLikes + recipe.numComments;

        return {
          'model': recipe,
          'totalInteractions': totalInteractions,
        };
      }).toList();

      fetchedRecipes.sort(
            (a, b) => (b['totalInteractions'] as int).compareTo(a['totalInteractions'] as int),
      );

      DateTime now = DateTime.now();
      int seed = now.year * 10000 + now.month * 100 + now.day;
      Random random = Random(seed);
      RecipeModel randomRecipe = fetchedRecipes[random.nextInt(fetchedRecipes.length)]['model'] as RecipeModel;

      List<RecipeModel> sortedRecipes = fetchedRecipes
          .map((e) => e['model'] as RecipeModel)
          .toList();

      List<RecipeModel> popularRecipes;
      bool hasInteractions = fetchedRecipes.any((r) => (r['totalInteractions'] as int) > 0);

      if (hasInteractions) {
        popularRecipes = sortedRecipes.take(5).toList();
      } else {
        popularRecipes = List<RecipeModel>.from(sortedRecipes)..shuffle();
        popularRecipes = popularRecipes.take(5).toList();
      }

      setState(() {
        recipes = sortedRecipes;
        mostPopularRecipes = popularRecipes;
        tryTodayRecipe = randomRecipe;
      });
    } catch (e) {
      print('Error fetching recipes: $e');
    }
  }

  void _onSearchSubmitted(String query) {
    if (query.trim().isEmpty) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ListingScreen(searchQuery: query.trim()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> contentWidgets = [];

    contentWidgets.add(
      HomeAppBar(
        title: 'شو بدك تطبخ اليوم؟',
        controller: _searchController,
        onSubmitted: _onSearchSubmitted,
      ),
    );
    contentWidgets.add(const SizedBox(height: 20));

    if (recipes.isEmpty || tryTodayRecipe == null) {
      contentWidgets.add(const Center(child: CircularProgressIndicator()));
    } else {
      contentWidgets.add(TryTodaySection(recipe: tryTodayRecipe!));
      contentWidgets.add(const SizedBox(height: 10));
      contentWidgets.add(const CookingTipCard());
      contentWidgets.add(const SizedBox(height: 10));
      contentWidgets.add(MostPopularSection(recipes: mostPopularRecipes));
      print('test ❤️❤️❤️، ${currentUser?.email ?? 'visitor'}');
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFDF5EC),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          child: Column(children: contentWidgets),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavbar(currentIndex: 1),
    );
  }
}
