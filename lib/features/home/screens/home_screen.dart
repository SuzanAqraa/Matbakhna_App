import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
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
  final List<Map<String, String>> recipes = [
    {
      'imageUrl': 'https://kitchen.sayidaty.net/uploads/small/65/65a750957fd3d95431c6c55a9fb02237_w750_h500.jpg',
      'title': 'فلافل',
      'description': 'طبق شعبي يتكون من الحمص المطحون مع البهارات، ويُقلى بالزيت.',
      'time': '٤٥ دقيقة',
    },
    {
      'imageUrl': 'https://snd.ps/thumb/730x400/uploads/images/2024/07/fa0sT.jpg',
      'title': 'مقلوبة',
      'description': 'طبق أرز وخضار ولحم يُطهى ويُقلب عند التقديم.',
      'time': '٦٠ دقيقة',
    },
    {
      'imageUrl': 'https://static.webteb.net/images/content/ramadanrecipe_recipe_9_4091e4b9c94-e089-4fff-9ccb-09cdba634024.jpg',
      'title': 'منسف',
      'description': 'طبق أردني يتكون من الأرز واللحم والمكسرات.',
      'time': '٩٠ دقيقة',
    },
    {
      'imageUrl': 'https://kitchen.sayidaty.net/uploads/small/7a/7af73ac1eedaf85a6ef42a6df7da8d02_w750_h500.jpg',
      'title': 'كبة',
      'description': 'كبة لحم محشوة بالبرغل والمكسرات.',
      'time': '٧٥ دقيقة',
    },
    {
      'imageUrl': 'https://i.ytimg.com/vi/9iNDG0Rr7oI/hq720.jpg?sqp=-oaymwEhCK4FEIIDSFryq4qpAxMIARUAAAAAGAElAADIQj0AgKJD&rs=AOn4CLAxiLQIcVR2PyqC4DFqlIee4R3P3w',
      'title': 'شاورما',
      'description': 'شرائح لحم مشوية ومغلفة بالخبز.',
      'time': '٣٠ دقيقة',
    },
  ];

  final List<String> cookingTips = [
    'الملح شوي شوي عمهلك وبالتدريج وخصوصاً بالطبخات.',
    'سخّن المقلاة قبل ما تحط فيها أي شي.',
    'غسل الخضار قبل التقطيع بيحافظ على قيمتها.',
    'ذوّب الزبدة على نار هادية حتى ما تحترق.',
    'رشة قرفة بتعزز نكهة الحلويات.',
    'خلّي الرز ينقع شوي قبل الطبخ.',
  ];

  int currentTipIndex = 0;
  Timer? _tipTimer;

  @override
  void initState() {
    super.initState();
    _startTipRotation();
  }

  void _startTipRotation() {
    _tipTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {
        currentTipIndex = Random().nextInt(cookingTips.length);
      });
    });
  }

  @override
  void dispose() {
    _tipTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF5EC),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const HomeAppBar(title: 'شو بدك تطبخ اليوم؟'),
              const SizedBox(height: 20),
              TryTodaySection(recipe: recipes[0]),
              const CookingTipCard(),
              const SizedBox(height: 20),
              MostPopularSection(recipes: recipes),
              const SizedBox(height: 12),

            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavbar(currentIndex: 1),


    );
  }
}
