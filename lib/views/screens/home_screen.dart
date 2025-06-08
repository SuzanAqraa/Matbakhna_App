import 'dart:async';
import 'package:flutter/material.dart';
import '../../controller/home_controller.dart';

import '../../core/widgets/appbar/primary_appbar.dart';
import '../../../core/widgets/custom_bottom_navbar.dart';
import '../../../core/utils/spaces.dart';
import '../../../Models/recipe_model.dart';
import '../widgets/home/cooking_tip_card.dart';
import '../widgets/home/most_popular_section.dart';
import '../widgets/home/try_today_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController _controller = HomeController();
  final TextEditingController _searchController = TextEditingController();

  List<RecipeModel> recipes = [];
  List<RecipeModel> mostPopularRecipes = [];
  RecipeModel? tryTodayRecipe;
  List<String> cookingTips = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final sorted = await _controller.getSortedRecipes();
      final popular = _controller.getPopularRecipes(sorted);
      final random = _controller.pickRandomRecipe(sorted);
      final tips = await _controller.getTips();

      setState(() {
        recipes = sorted;
        mostPopularRecipes = popular;
        tryTodayRecipe = random;
        cookingTips = tips;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading data: $e');
      setState(() => isLoading = false);
    }
  }

  void _onSearchSubmitted(String query) {
    if (query.trim().isEmpty) return;

    Navigator.pushNamed(
      context,
      '/listing',
      arguments: query.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF5EC),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: RefreshIndicator(
          onRefresh: _loadData,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              HomeAppBar(
                title: 'شو بدك تطبخ اليوم؟',
                controller: _searchController,
                onSubmitted: _onSearchSubmitted,
              ),
              Spaces.verticalSpacing(20),
              if (isLoading || tryTodayRecipe == null)
                const Center(child: Padding(
                  padding: EdgeInsets.only(top: 100),
                  child: CircularProgressIndicator(),
                ))
              else ...[
                TryTodaySection(recipe: tryTodayRecipe!),
                Spaces.verticalSpacing(10),
                CookingTipCard(cookingTips: cookingTips),
                Spaces.verticalSpacing(10),
                MostPopularSection(recipes: mostPopularRecipes),
              ],
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavbar(currentIndex: 1),
    );
  }

}