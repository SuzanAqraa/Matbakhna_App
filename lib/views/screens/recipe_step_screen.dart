import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:matbakhna_mobile/core/utils/brand_colors.dart';

class RecipeStepPage extends StatefulWidget {
  final String recipeId;
  final int stepNumber;
  final String? sharedImageUrl; 

  const RecipeStepPage({
    super.key,
    required this.recipeId,
    required this.stepNumber,
    this.sharedImageUrl,
  });

  @override
  State<RecipeStepPage> createState() => _RecipeStepPageState();
}

class _RecipeStepPageState extends State<RecipeStepPage> {
  late Future<Map<String, dynamic>> stepDetailsFuture;

  @override
  void initState() {
    super.initState();
    stepDetailsFuture = fetchStepDetails(widget.recipeId, widget.stepNumber);
  }

  Future<Map<String, dynamic>> fetchStepDetails(
    String recipeId,
    int stepNumber,
  ) async {
    try {
      final DocumentSnapshot snapshot =
          await FirebaseFirestore.instance
              .collection('recipes')
              .doc(recipeId)
              .get();

      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        final List<dynamic> steps = data['steps'];
        final stepIndex =
            stepNumber - 1; 

        if (stepIndex >= 0 && stepIndex < steps.length) {
          return steps[stepIndex] as Map<String, dynamic>;
        } else {
          throw Exception("Step $stepNumber not found");
        }
      } else {
        throw Exception("Recipe not found");
      }
    } catch (e) {
      throw Exception("Failed to load step details: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: BrandColors.primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'الخطوة ${widget.stepNumber}',
          textDirection: TextDirection.rtl,
          style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: stepDetailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('خطأ: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('لا توجد بيانات متاحة.'));
          }

          final step = snapshot.data!;
          final description = step['description'] ?? '';
          final imageUrl =
              widget.sharedImageUrl ?? ''; 
          final ingredients = step['ingredients'] ?? [];
          final tools = step['tools'] ?? [];

          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child:
                      imageUrl.isNotEmpty
                          ? Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (_, __, ___) => const Icon(Icons.error),
                            loadingBuilder: (_, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                          )
                          : const Center(child: Text('لا يوجد صورة')),
                ),

                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: BrandColors.primaryColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'وصف الخطوة',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              description,
                              textAlign: TextAlign.justify,
                              style: const TextStyle(fontSize: 20, height: 1.5),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'المكونات',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: ingredients.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  leading: const Icon(Icons.local_dining),
                                  title: Text(ingredients[index]),
                                );
                              },
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'أدوات الطهي',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: tools.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  leading: const Icon(Icons.local_dining),
                                  title: Text(tools[index]),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}