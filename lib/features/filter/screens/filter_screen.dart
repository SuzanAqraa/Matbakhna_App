import 'package:flutter/material.dart';
import 'package:matbakhna_mobile/features/listing/screens/listing_screen.dart';
import '../../../core/utils/brand_colors.dart';
import '../../../core/utils/textfeild_styles.dart';
import '../../../core/widgets/SimpleAppBar.dart';

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
        backgroundColor: BrandColors.backgroundColor,
        appBar: const CustomAppBar(title: 'اختار عذوقك', showBackButton: true),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 32),
                Text(
                  'نوع الوجبة',
                  style: ThemeTextStyle.recipeNameTextFieldStyle,
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12.0,
                  runSpacing: 12.0,
                  children:
                      mealTypes.map((type) {
                        final isSelected = selectedMealTypes.contains(type);
                        return ChoiceChip(
                          label: Text(
                            type,
                            style: TextStyle(
                              fontSize: 16,
                              color:
                                  isSelected ? Colors.black : Colors.grey[700],
                            ),
                          ),
                          selected: isSelected,
                          selectedColor: BrandColors.primaryColor,
                          onSelected:
                              (_) => toggleSelection(type, selectedMealTypes),
                          backgroundColor: Colors.grey.shade200,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        );
                      }).toList(),
                ),
                const SizedBox(height: 32),
                Text(
                  'مطبخ البلد',
                  style: ThemeTextStyle.recipeNameTextFieldStyle,
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12.0,
                  runSpacing: 12.0,
                  children:
                      cuisines.map((cuisine) {
                        final isSelected = selectedCuisines.contains(cuisine);
                        return ChoiceChip(
                          label: Text(
                            cuisine,
                            style: TextStyle(
                              fontSize: 16,
                              color:
                                  isSelected ? Colors.black : Colors.grey[700],
                            ),
                          ),
                          selected: isSelected,
                          selectedColor: BrandColors.primaryColor,
                          onSelected:
                              (_) => toggleSelection(cuisine, selectedCuisines),
                          backgroundColor: Colors.grey.shade200,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        );
                      }).toList(),
                ),
                const SizedBox(height: 32),
                Text(
                  'كم بدك اياها صعبة؟',
                  style: ThemeTextStyle.recipeNameTextFieldStyle,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      '١',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      '١٠',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Slider(
                  value: difficulty,
                  min: 1,
                  max: 10,
                  divisions: 9,
                  label: difficulty.round().toString(),
                  activeColor: BrandColors.secondaryColor,
                  onChanged: (value) {
                    setState(() {
                      difficulty = value;
                    });
                  },
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ListingScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: BrandColors.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'أظهر النتائج',
                    style: ThemeTextStyle.ButtonTextFieldStyle.copyWith(
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
