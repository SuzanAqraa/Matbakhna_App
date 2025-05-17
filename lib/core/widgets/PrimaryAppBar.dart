import 'package:flutter/material.dart';
import 'package:matbakhna_mobile/features/filter/screens/filter_screen.dart';

class HomeAppBar extends StatelessWidget {
  final String title;

  const HomeAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 80, bottom: 32),
      decoration: const BoxDecoration(
        color: Color(0xFFA5C8A6),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(100)),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
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
    );
  }
}
