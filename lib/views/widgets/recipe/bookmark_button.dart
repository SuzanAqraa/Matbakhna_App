import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

typedef ShowLoginDialog = void Function();

class BookmarkButton extends StatefulWidget {
  final String recipeTitle;
  final String imageUrl;
  final String description;
  final String duration;
  final int numLikes;
  final ShowLoginDialog onNeedLogin;

  const BookmarkButton({
    super.key,
    required this.recipeTitle,
    required this.imageUrl,
    required this.description,
    required this.duration,
    required this.numLikes,
    required this.onNeedLogin,
  });

  @override
  State<BookmarkButton> createState() => _BookmarkButtonState();
}

class _BookmarkButtonState extends State<BookmarkButton> {
  bool _isBookmarked = false;

  @override
  void initState() {
    super.initState();
    _checkIfBookmarked();
  }

  Future<void> _checkIfBookmarked() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .doc(widget.recipeTitle)
        .get();

    if (mounted) {
      setState(() {
        _isBookmarked = snapshot.exists;
      });
    }
  }

  void _toggleBookmark() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      widget.onNeedLogin(); 
      return;
    }

    final favoritesRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .doc(widget.recipeTitle);

    if (mounted) {
      setState(() {
        _isBookmarked = !_isBookmarked;
      });
    }

    if (_isBookmarked) {
      await favoritesRef.set({
        'title': widget.recipeTitle,
        'imageUrl': widget.imageUrl,
        'description': widget.description,
        'duration': widget.duration,
        'numLikes': widget.numLikes,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } else {
      await favoritesRef.delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleBookmark,
      child: Icon(
        _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
        color: _isBookmarked ? Colors.orange : Colors.black,
        size: 30,
      ),
    );
  }
}