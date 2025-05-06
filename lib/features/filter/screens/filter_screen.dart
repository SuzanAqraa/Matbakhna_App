import 'package:flutter/material.dart';
import 'package:matbakhna_mobile/features/listing/screens/listing_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final List<String> mealTypes = ['فطور', 'غداء', 'عشاء', 'تحلية', 'سناك'];
  final List<String> cuisines = ['فلسطيني', 'مصري', 'إيطالي', 'تركي', 'لبناني'];
  List<String> selectedMealTypes = [];
  List<String> selectedCuisines = [];
  double difficulty = 5;

  void toggleSelection(String value, List<String> selectedList) {
    setState(() {
      if (selectedList.contains(value)) {
        selectedList.remove(value);
      } else {
        selectedList.add(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFFDF5EC),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(140),
          child: Container(
            padding: const EdgeInsets.only(top: 60, bottom: 24),
            decoration: const BoxDecoration(
              color: Color(0xFFA5C8A6),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(100),
              ),
            ),
            child: Stack(
              children: [
                Center(
                  child: Text(
                    'اختار عذوقك',
                    style: const TextStyle(
                      color: Color(0xFF3D3D3D),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Positioned(
                  right: 16,
                  top: 10,
                  child: BackButton(color: Colors.black),
                ),
              ],
            ),
          ),
        ),

        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [

                const SizedBox(height: 24),
                const Text('نوع الوجبة', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: mealTypes.map((type) {
                    final isSelected = selectedMealTypes.contains(type);
                    return ChoiceChip(
                      label: Text(type),
                      selected: isSelected,
                      selectedColor: const Color(0xFFA5C8A6),
                      onSelected: (_) => toggleSelection(type, selectedMealTypes),
                      backgroundColor: Colors.grey.shade200,
                      labelStyle: TextStyle(color: isSelected ? Colors.black : Colors.grey[700]),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                const Text('مطبخ البلد', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: cuisines.map((cuisine) {
                    final isSelected = selectedCuisines.contains(cuisine);
                    return ChoiceChip(
                      label: Text(cuisine),
                      selected: isSelected,
                      selectedColor: const Color(0xFFA5C8A6),
                      onSelected: (_) => toggleSelection(cuisine, selectedCuisines),
                      backgroundColor: Colors.grey.shade200,
                      labelStyle: TextStyle(color: isSelected ? Colors.black : Colors.grey[700]),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                const Text('كم بدك اياها صعبة؟', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('١', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('١٠', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Slider(
                    value: difficulty,
                    min: 1,
                    max: 10,
                    divisions: 9,
                    label: difficulty.round().toString(),
                    activeColor: const Color(0xFFA5C8A6),
                    onChanged: (value) {
                      setState(() {
                        difficulty = value;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ListingScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFA5C8A6),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'أظهر النتائج',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
