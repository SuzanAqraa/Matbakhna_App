import 'package:flutter/material.dart';
import 'package:matbakhna_mobile/views/screens/listing_screen.dart';
import '../../core/utils/brand_colors.dart';
import '../../core/widgets/appbar/simple_appbar.dart';
import '../widgets/filter/difficulty_filter.dart';
import '../widgets/filter/filter_section.dart';
import '../widgets/filter/show_results_button.dart';



class FilterScreen extends StatefulWidget {
  const FilterScreen({Key? key}) : super(key: key);

  @override
  State<FilterScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<FilterScreen> {
  final List<String> mealTypes = ['فطور', 'غداء', 'عشاء', 'تحلية', 'سناك','سلطة'];
  final List<String> cuisines = ['فلسطيني','سوري', 'مصري', 'إيطالي', 'تركي', 'لبناني','سعودي'];
  List<String> selectedMealTypes = [];
  List<String> selectedCuisines = [];
  double difficulty = 5;
  bool filterByDifficulty = false;

  void toggleSelection(String value, List<String> selectedList) {
    setState(() {
      if (selectedList.contains(value)) {
        selectedList.remove(value);
      } else {
        selectedList.add(value);
      }
    });
  }

  void setDifficulty(double value) {
    setState(() {
      difficulty = value;
    });
  }

  void setFilterByDifficulty(bool value) {
    setState(() {
      filterByDifficulty = value;
    });
  }

  void showResults() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ListingScreen(
          mealTypesFilter: selectedMealTypes.isEmpty ? null : selectedMealTypes,
          nationalitiesFilter: selectedCuisines.isEmpty ? null : selectedCuisines,
          difficultyFilter: filterByDifficulty ? difficulty.round() : null,
        ),
      ),
    );
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
                FilterSection(
                  title: 'نوع الوجبة',
                  options: mealTypes,
                  selectedOptions: selectedMealTypes,
                  onSelectionChanged: (value) => toggleSelection(value, selectedMealTypes),
                ),
                const SizedBox(height: 32),
                FilterSection(
                  title: 'مطبخ البلد',
                  options: cuisines,
                  selectedOptions: selectedCuisines,
                  onSelectionChanged: (value) => toggleSelection(value, selectedCuisines),
                ),
                const SizedBox(height: 32),
                DifficultyFilter(
                  difficulty: difficulty,
                  filterByDifficulty: filterByDifficulty,
                  onDifficultyChanged: setDifficulty,
                  onFilterByDifficultyChanged: setFilterByDifficulty,
                ),
                const SizedBox(height: 40),
                ShowResultsButton(onPressed: showResults),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
