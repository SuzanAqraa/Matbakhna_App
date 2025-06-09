import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


import 'package:matbakhna_mobile/core/widgets/appbar/primary_appbar.dart';
import 'package:matbakhna_mobile/core/widgets/custom_bottom_navbar.dart';
import 'package:matbakhna_mobile/core/widgets/recipe_card_widget.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  @override
  void dispose() {
    searchController.dispose(); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const CustomBottomNavbar(currentIndex: 2),
      backgroundColor: const Color(0xFFFDF5EC),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
         
            HomeAppBar(
              title: 'الوصفات المفضلة',
              controller: searchController,
              onChanged: (value) {
                setState(() {
                  searchQuery = value.trim();
                });
              },
            ),

          
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .collection('favorites')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('لا توجد وصفات مفضلة.'));
                  }

              
                  final allDocs = snapshot.data!.docs;
                  final filteredDocs = searchQuery.isEmpty
                      ? allDocs
                      : allDocs.where((doc) {
                          final data = doc.data() as Map<String, dynamic>;
                          final title = data['title']?.toString().toLowerCase() ?? '';
                          return title.contains(searchQuery.toLowerCase());
                        }).toList();

                  if (filteredDocs.isEmpty) {
                    return const Center(child: Text('لا توجد نتائج للبحث.'));
                  }

                  return ListView.builder(
                    itemCount: filteredDocs.length,
                    itemBuilder: (context, index) {
                      var data = filteredDocs[index].data() as Map<String, dynamic>;
                      String imageUrl = data['imageUrl'] ?? '';
                      String title = data['title'] ?? 'بدون اسم';
                      String description = data['description'] ?? 'لا يوجد وصف';
                      String time = data['duration'] ?? 'غير محدد';
                      int numLikes = data['numLikes'] ?? 0;
                      int numComments = data['numComments'] ?? 0;

                      return RecipeCard(
                        imageUrl: imageUrl,
                        title: title,
                        description: description,
                        time: time,
                        numLikes: numLikes,
                        recipeId: filteredDocs[index].id,
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