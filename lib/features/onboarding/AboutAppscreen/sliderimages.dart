import 'package:flutter/material.dart';

class ImagesWidget extends StatefulWidget {
  const ImagesWidget({super.key});

  @override
  State<ImagesWidget> createState() => _ImagesWidgetState();
}

class _ImagesWidgetState extends State<ImagesWidget> {

  final List<String> imagesList = [
   'assets/images/cake.jpg',
    'assets/images/image1.jpg',
    'assets/images/image2.jpg',
    'assets/images/imgas3.jpg',
    ];
  int _currentIndex = 0;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoPlay();
  }

  void _startAutoPlay() {
    Future.delayed(const Duration(seconds: 5), () {
      if (!mounted) return;
      int nextPage = (_currentIndex + 1) % imagesList.length;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,

      );
      setState(() {
        _currentIndex = nextPage;
      });
      _startAutoPlay();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 500,
          width: double.infinity,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemCount: imagesList.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(15.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25.0),
                  child: Image.asset( // استخدم Image.network بدلاً من Image.asset لأن الصور من الإنترنت
                    imagesList[index],
                    fit: BoxFit.cover,
                    width: 400,
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: imagesList
              .asMap()
              .entries
              .map((entry) {
            return Container(
              width: 10.0,
              height: 10.0,
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndex == entry.key
                    ? Colors.black
                    : Colors.grey.shade400,
              ),
            );
          }).toList(),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            "مطبخنا",
            style: TextStyle(
              fontSize: 45,
              fontWeight: FontWeight.bold,
              color: Color(0xFF33363F),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(25.0),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Text(
              "يقدم وصفات أكل متنوعة وشهية بتعليمات دقيقة وصور جذابة. يتميز ببحث ذكي ونصائح مفيدة، مما يجعله رفيقًا مثاليًا لكل مستويات الطهاة.",
              textAlign: TextAlign.justify,
              softWrap: true,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF33363F),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(25.0),
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Color(0xFFA5C8A6),
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 125),
              textStyle: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
              foregroundColor: Color(0xFF33363F),
            ),
            onPressed: () {},
            child: const Text("اكتشف معنا"),
          ),
        ),

      ],
    );
  }



}
