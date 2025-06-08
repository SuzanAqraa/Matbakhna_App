import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:matbakhna_mobile/core/widgets/appbar/primary_appbar.dart';
import 'package:matbakhna_mobile/core/widgets/recipe_card_widget.dart';
import 'package:matbakhna_mobile/core/widgets/custom_bottom_navbar.dart';

class ListingScreen extends StatefulWidget {
  final List<String>? mealTypesFilter;
  final List<String>? nationalitiesFilter;
  final int? difficultyFilter;
  final String? searchQuery;

  const ListingScreen({
    super.key,
    this.mealTypesFilter,
    this.nationalitiesFilter,
    this.difficultyFilter,
    this.searchQuery,
  });

  @override
  State<ListingScreen> createState() => _ListingScreenState();
}

class _ListingScreenState extends State<ListingScreen> {
  late TextEditingController searchController;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController(text: widget.searchQuery ?? '');
    searchQuery = widget.searchQuery ?? '';
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Query recipesQuery = FirebaseFirestore.instance.collection('recipes');

    if (widget.mealTypesFilter != null && widget.mealTypesFilter!.isNotEmpty) {
      recipesQuery = recipesQuery.where('mealType', whereIn: widget.mealTypesFilter);
    }

    if (widget.nationalitiesFilter != null && widget.nationalitiesFilter!.isNotEmpty) {
      recipesQuery = recipesQuery.where('nationality', whereIn: widget.nationalitiesFilter);
    }

    if (widget.difficultyFilter != null) {
      recipesQuery = recipesQuery.where('difficulty', isEqualTo: widget.difficultyFilter);
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFDF5EC),
      bottomNavigationBar: const CustomBottomNavbar(currentIndex: 3),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
            HomeAppBar(
              title: 'صفحة التصفح',
              controller: searchController,
              onChanged: (value) {
                setState(() {
                  searchQuery = value.trim();
                });
              },
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: recipesQuery.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('لا توجد وصفات متاحة.'));
                  }

                  var allDocs = snapshot.data!.docs;

                  var filteredDocs = allDocs.where((doc) {
                    final data = doc.data() as Map<String, dynamic>?;
                    final title = (data?['Title'] ?? '').toString().toLowerCase();
                    return title.contains(searchQuery.toLowerCase());
                  }).toList();

                  if (filteredDocs.isEmpty) {
                    return const Center(child: Text('لا توجد نتائج تطابق البحث.'));
                  }

                  return ListView.builder(
                    itemCount: filteredDocs.length,
                    itemBuilder: (context, index) {
                      final doc = filteredDocs[index];
                      final data = doc.data() as Map<String, dynamic>;

                      final imageUrl = data['imageUrl'] ?? '';
                      final title = data['Title'] ?? 'بدون اسم';
                      final description = data['Description'] ?? 'لا يوجد وصف';
                      final duration = data['duration']?.toString() ?? 'غير محدد';
                      final numLikes = data['Num_Likes'] ?? 0;
                      final numComments = data['Num_Comments'] ?? 0;

                      return RecipeCard(
                        imageUrl: imageUrl,
                        title: title,
                        description: description,
                        time: duration,
                        numLikes: numLikes,
                        numComments: numComments,
                        recipeId: doc.id,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}