import 'package:flutter/material.dart';
import '../../../core/utils/brand_colors.dart';
import '../../../core/utils/textfeild_styles.dart';


class DifficultyFilter extends StatelessWidget {
  final double difficulty;
  final bool filterByDifficulty;
  final ValueChanged<double> onDifficultyChanged;
  final ValueChanged<bool> onFilterByDifficultyChanged;

  const DifficultyFilter({
    Key? key,
    required this.difficulty,
    required this.filterByDifficulty,
    required this.onDifficultyChanged,
    required this.onFilterByDifficultyChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('كم بدك اياها صعبة؟', style: ThemeTextStyle.recipeNameTextFieldStyle),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('١', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text('١٠', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
        Slider(
          value: difficulty,
          min: 1,
          max: 10,
          divisions: 9,
          label: difficulty.round().toString(),
          activeColor: BrandColors.secondaryColor,
          onChanged: onDifficultyChanged,
        ),
        const SizedBox(height: 12),
        SwitchListTile(
          title: const Text(
            'تفعيل فلترة حسب الصعوبة',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          value: filterByDifficulty,
          onChanged: onFilterByDifficultyChanged,
        ),
      ],
    );
  }
}
