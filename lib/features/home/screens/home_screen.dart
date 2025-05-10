import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:matbakhna_mobile/core/widgets/custom_widgets.dart';
import 'package:matbakhna_mobile/features/home/widgets/card.dart';
import 'package:matbakhna_mobile/features/Filter/screens/filter_screen.dart';
import 'package:matbakhna_mobile/features/listing/screens/listing_screen.dart';

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
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 80, bottom: 32),
                decoration: const BoxDecoration(
                  color: Color(0xFFA5C8A6),
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(100)),
                ),
                child: Column(
                  children: [
                    const Text(
                      'شو بدك تطبخ اليوم؟',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3D3D3D),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                color: Color(0xFFE8DCCF),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const TextField(
                                style: TextStyle(fontSize: 18),
                                decoration: InputDecoration(
                                  icon: Icon(Icons.search, color: Color(0xFF707070)),
                                  hintText: 'ابحث عن وصفة...',
                                  hintStyle: TextStyle(fontSize: 16),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const SearchScreen()),
                              );
                            },
                            icon: const Icon(Icons.tune, color: Color(0xFF3D3D3D), size: 22),
                            label: const Text(
                              'عذوقك',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF3D3D3D),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE8DCCF),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              elevation: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color(0xFFE8DCCF),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          recipes[0]['imageUrl']!,
                          width: 110,
                          height: 110,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'جرب اليوم',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFE56B50),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              recipes[0]['title']!,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF3D3D3D),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              recipes[0]['description']!,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF707070),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // نصيحة متغيرة
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color(0xFFA5C8A6),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.lightbulb_outline, color: Colors.white, size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          cookingTips[currentTipIndex],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'الأكثر تفاعل',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3D3D3D),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 230,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: recipes.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final recipe = recipes[index];
                    return SizedBox(
                      width: 200,
                      child: RecipeCard(
                        imageUrl: recipe['imageUrl']!,
                        title: recipe['title']!,
                        description: recipe['description']!,
                        time: recipe['time']!,
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 24, top: 12, bottom: 32),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ListingScreen()),
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 1),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      minimumSize: Size.zero,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          'اعرض المزيد',
                          style: TextStyle(
                            color: Color(0xFF3D3D3D),
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(width: 3),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Color(0xFF3D3D3D),
                          size: 11,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavbar(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushNamed(context, '/profile');
          } else if (index == 2) {
            Navigator.pushNamed(context, '/favorites');
          }
        },
      ),
    );
  }
}
