import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:matbakhna_mobile/core/widgets/PrimaryAppBar.dart';
import 'package:matbakhna_mobile/core/widgets/RecipeCardWidget.dart';
import 'package:matbakhna_mobile/core/widgets/custom_bottom_navbar.dart';

class ListingScreen extends StatelessWidget {
  const ListingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const CustomBottomNavbar(currentIndex: 3),
      backgroundColor: const Color(0xFFFDF5EC),

      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            children: [
              const HomeAppBar(title: 'صفحة التصفح'),

              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('recipes').snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(child: Text('لا توجد وصفات متاحة.'));
                    }

                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var data = snapshot.data!.docs[index].data() as Map<String, dynamic>;

                        String imageUrl = data['imageUrl']?.toString() ?? '';
                        String title = data['Title']?.toString() ?? 'بدون اسم';
                        String description = data['Description']?.toString() ?? 'لا يوجد وصف';
                        String time = data['duration']?.toString() ?? 'غير محدد';
                        int numLikes = data['Num_Likes'] ?? 0;
                        int numComments = data['Num_Comments'] ?? 0;

                        return SizedBox(
                          height: 300,
                          child: RecipeCard(
                            imageUrl: imageUrl,
                            title: title,
                            description: description,
                            time: time,
                            numLikes: numLikes,
                            numComments: numComments,
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