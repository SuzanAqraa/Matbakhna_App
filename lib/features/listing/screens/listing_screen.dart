import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:matbakhna_mobile/core/widgets/PrimaryAppBar.dart';
import 'package:matbakhna_mobile/core/widgets/RecipeCardWidget.dart';
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
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    searchQuery = widget.searchQuery ?? '';
    searchController.text = searchQuery;
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
      bottomNavigationBar: const CustomBottomNavbar(currentIndex: 3),
      backgroundColor: const Color(0xFFFDF5EC),
      body: SafeArea(
        child: Directionality(
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

                    var filteredDocs = snapshot.data!.docs.where((doc) {
                      String title = (doc['Title'] ?? '').toString().toLowerCase();
                      return title.contains(searchQuery.toLowerCase());
                    }).toList();

                    if (filteredDocs.isEmpty) {
                      return const Center(child: Text('لا توجد نتائج تطابق البحث.'));
                    }

                    return ListView.builder(
                      itemCount: filteredDocs.length,
                      itemBuilder: (context, index) {
                        var data = filteredDocs[index].data() as Map<String, dynamic>;

                        return SizedBox(
                          height: 300,
                          child: RecipeCard(
                            imageUrl: data['imageUrl']?.toString() ?? '',
                            title: data['Title']?.toString() ?? 'بدون اسم',
                            description: data['Description']?.toString() ?? 'لا يوجد وصف',
                            time: data['duration']?.toString() ?? 'غير محدد',
                            numLikes: data['Num_Likes'] ?? 0,
                            numComments: data['Num_Comments'] ?? 0,
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
