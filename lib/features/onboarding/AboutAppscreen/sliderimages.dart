import 'package:flutter/material.dart';

class ImagesWidget extends StatefulWidget {
  const ImagesWidget({super.key});

  @override
  State<ImagesWidget> createState() => _ImagesWidgetState();
}

class _ImagesWidgetState extends State<ImagesWidget> {
  final List<String> imagesList = [
    'assets/images/image1.jpg',
    'assets/images/image2.jpg',
    'assets/images/image3.jpg',
    'assets/images/cake.jpg',
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
    Future.delayed(const Duration(seconds: 8), () {
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
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 400,
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
                    child: Image.asset(
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
            children: imagesList.asMap().entries.map((entry) {
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
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFA5C8A6), 
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
            textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15), 
            ),
          ),
          onPressed: () {},
          child: const Text('انهاء'),
        ),
      ),
    );
  }
}
