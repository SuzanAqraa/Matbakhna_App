import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../../controller/home_controller.dart';
import '../../core/utils/network_helpers/network_utils.dart';

import '../../../core/widgets/appbar/primary_appbar.dart';
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
    setState(() => isLoading = true);
    try {
      final sorted = await handleWithRetry<List<RecipeModel>>(
        request: () => _controller.getSortedRecipes(),
        fallbackValue: [],
        maxRetries: 3,
        retryDelay: const Duration(seconds: 2),
        onFail: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("فشل الاتصال بالإنترنت. حاول مرة أخرى.")),
          );
        },
      );

      final popular = _controller.getPopularRecipes(sorted);
      final random = _controller.pickRandomRecipe(sorted);

      final tips = await handleWithRetry<List<String>>(
        request: () => _controller.getTips(),
        fallbackValue: [],
        onFail: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("تعذر تحميل نصائح الطبخ. تحقق من الاتصال.")),
          );
        },
      );

      setState(() {
        recipes = sorted;
        mostPopularRecipes = popular;
        tryTodayRecipe = random;
        cookingTips = tips;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading data: $e');
      setState(() => isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("حدث خطأ غير متوقع. حاول لاحقاً.")),
      );
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
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
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
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 100),
                        child: CircularProgressIndicator(),
                      ),
                    )
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
        ),
      ),
      bottomNavigationBar: kIsWeb ? null : const CustomBottomNavbar(currentIndex: 1),
    );
  }
}
