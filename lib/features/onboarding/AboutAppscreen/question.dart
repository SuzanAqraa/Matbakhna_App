import 'package:flutter/material.dart';

// Assuming Buttons is a custom button widget, you'll need to import it here.
// import '../../core/widgets/button.dart';

class ListQuestion extends StatefulWidget {
  const ListQuestion({super.key});

  @override
  State<ListQuestion> createState() => _ListQuestionState();
}

class _ListQuestionState extends State<ListQuestion> {
  List<String> selectedOptions = [];
  final List<String> allOptions = [
    "المقبلات",
    "الحلويات",
    "المشروبات",
    "الشواء",
    "النودلز",
    "المخبوزات",
    "أطعمة بحرية",
    "السندويشات",
    "السوشي",
    "لأطعمة السريعة",
    "المأكولات المكسيكية",
    "الوجبات النباتية",
    "الأطباق الرئيسية",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6ECE5),
      body: Stack(
        children: [
          // زر التخطي
          Positioned(
            top: MediaQuery.of(context).size.height * 0.06,
            right: 32,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE56B50),
                padding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              ),
              onPressed: () {},
              child: const Text(
                "تخطي",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          const Directionality(
            textDirection: TextDirection.rtl,
            child: Positioned(
              top: 160,
              right: 30,
              left: 50,
              child: Text(
                "اخبرني ما هو اكلك المفضل ؟",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                softWrap: true,
              ),
            ),
          ),
          const Directionality(
            textDirection: TextDirection.rtl,
            child: Positioned(
              top: 190,
              right: 30,
              left: 50,
              child: Text(
                "اختار ما هي اكلتلك المفضلة",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          Positioned(
            top: 240,
            left: 20,
            right: 20,
            bottom: 80,
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                alignment: WrapAlignment.center,
                children: allOptions.map((option) {
                  return ChoiceChip(
                    label: Text(
                      option,
                      style: const TextStyle(fontSize: 18, color: Colors.black),
                    ),
                    selected: selectedOptions.contains(option),
                    selectedColor: const Color(0xFF6A908C),
                    backgroundColor: const Color(0xFF99AFAD),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    onSelected: (isSelected) {
                      setState(() {
                        if (isSelected) {
                          selectedOptions.add(option);
                        } else {
                          selectedOptions.remove(option);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
          },
          child: const Text('انهاء'),
        ),
      ),
    );
  }
}
