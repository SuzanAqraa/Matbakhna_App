import 'package:flutter/material.dart';

class RecipeStepPage extends StatefulWidget {
  const RecipeStepPage({super.key});

  @override
  State<RecipeStepPage> createState() => _RecipeStepPageState();
}

class _RecipeStepPageState extends State<RecipeStepPage> {
  List<int> selectedSteps = [];

  void toggleStep(int step) {
    setState(() {
      if (selectedSteps.contains(step)) {
        selectedSteps.remove(step);
      } else {
        selectedSteps.add(step);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF6A908C),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            // Action for back button
          },
        ),
        title: const Text(
          'الخطوة الثانية',
          textDirection: TextDirection.rtl,
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              "assets/images/cake.jpg",
              fit: BoxFit.cover,
              width: double.infinity,
              height: 200,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 400,
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'لوازم الخطوة',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: const [
                            Column(
                              children: [
                                Icon(Icons.soup_kitchen, size: 40),
                                Text('طبق تقديم'),
                              ],
                            ),
                            Column(
                              children: [
                                Icon(Icons.no_meals_ouline, size: 40),
                                Text('جوز هند مبشور'),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 30),
                          margin: const EdgeInsets.all(20),
                          child: const Text(
                            'شكل العجينة كرات صغيرة ثم دحرجها في جوز الهند المبشور حتى تغطي بالكامل. ضعها في الثلاجة قليلاً لتتماسك أكثر، ثم قدمها!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              height: 1.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// أزرار الخطوات (بدون GoogleFonts)
                  Center(
                    child: Wrap(
                      spacing: 10,
                      children: List.generate(4, (index) {
                        int step = index + 1;
                        bool isSelected = selectedSteps.contains(step);

                        return GestureDetector(
                          onTap: () => toggleStep(step),
                          child: Container(
                            width: 70,
                            margin: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: isSelected
                                  ? const Color(0xFF6A908C)
                                  : const Color(0xFF99AFAD),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 12),
                            child: Text(
                              '$step',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 25,
                                color: Color(0xFF000000),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StepIndicator extends StatelessWidget {
  final int number;
  final bool isActive;

  const StepIndicator({super.key, required this.number, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 25,
      backgroundColor: isActive ? Colors.teal : Colors.grey.shade300,
      child: Text(
        '$number',
        style: TextStyle(
          fontSize: 20,
          color: isActive ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}
