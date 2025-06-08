import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ListQuestion extends StatefulWidget {
  const ListQuestion({super.key});

  @override
  State<ListQuestion> createState() => _ListQuestionState();
}

class _ListQuestionState extends State<ListQuestion> {
  List<String> selectedOptions = [];
  List<String> allOptions = [];

  @override
  void initState() {
    super.initState();
    fetchFoodPreferences();
    loadUserPreferences();
  }

  Future<void> fetchFoodPreferences() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('food_preferences').get();

      setState(() {
        allOptions =
            querySnapshot.docs
                .map((doc) {
                  final data = doc.data() as Map<String, dynamic>?;
                  if (data != null && data.containsKey('name')) {
                    return data['name'].toString();
                  }
                  return null;
                })
                .whereType<String>()
                .toList();
      });
    } catch (e) {
      print("Error fetching food preferences: $e");
    }
  }

  Future<void> loadUserPreferences() async {
    String? userID = FirebaseAuth.instance.currentUser?.uid;
    if (userID == null) return;

    DocumentSnapshot doc =
        await FirebaseFirestore.instance
            .collection('user_preferences')
            .doc(userID)
            .get();

    if (doc.exists && doc.data() != null) {
      setState(() {
        selectedOptions = List<String>.from(
          doc.get('food_choices') ?? <String>[],
        );
      });
    }
  }

  Future<void> saveUserPreferences() async {
    String? userID = FirebaseAuth.instance.currentUser?.uid;
    if (userID == null) return;

    await FirebaseFirestore.instance
        .collection('user_preferences')
        .doc(userID)
        .set({'food_choices': selectedOptions});

    print("Navigating to HomePage...");
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6ECE5),
      body: Stack(
        children: [
          Positioned(
            top: MediaQuery.of(context).size.height * 0.06,
            right: 32,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE56B50),
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 30,
                ),
              ),
              onPressed: () {
                print("Skip pressed - Navigating to HomePage...");
                Navigator.pushReplacementNamed(context, '/home');
              },
              child: const Text(
                "تخطي",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
          ),

          const Directionality(
            textDirection: TextDirection.rtl,
            child: Positioned(
              top: 160,
              right: 30,
              left: 50,
              child: Text(
                "اخبرني ما هو أكلك المفضل؟",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          const Directionality(
            textDirection: TextDirection.rtl,
            child: Positioned(
              top: 190,
              right: 30,
              left: 50,
              child: Text(
                "اختر ما هي أكلك المفضلة",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ),
          ),

          Positioned(
            top: 240,
            left: 20,
            right: 20,
            bottom: 80,
            child: SingleChildScrollView(
              child:
                  allOptions.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        alignment: WrapAlignment.center,
                        children:
                            allOptions.map((option) {
                              return ChoiceChip(
                                label: Text(
                                  option,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                ),
                                selected: selectedOptions.contains(option),
                                selectedColor: Color(0xFF6A908C),
                                backgroundColor: Color(0xFF99AFAD),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                onSelected: (isSelected) {
                                  setState(() {
                                    if (isSelected) {
                                      selectedOptions.add(option);
                                    } else {
                                      selectedOptions.remove(option);
                                    }
                                  });
                                },
                              );
                            }).toList(),
                      ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(
          bottom: 20,
        ), 
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () {
              saveUserPreferences(); 
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFA5C8A6), 
              padding: const EdgeInsets.symmetric(
                vertical: 20, 
                horizontal: 40, 
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  12,
                ), 
              ),
              textStyle: const TextStyle(fontSize: 18), 
            ),
            child: const Text('انهاء'),
          ),
        ),
      ),
    );
  }
}