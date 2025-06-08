import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

typedef ShowLoginDialog = void Function();

class LikeButton extends StatefulWidget {
  final String recipeTitle;
  final int initialLikeCount;
  final ShowLoginDialog onNeedLogin;

  const LikeButton({
    super.key,
    required this.recipeTitle,
    required this.initialLikeCount,
    required this.onNeedLogin,
  });

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  bool _isLiked = false;
  late int _likeCount;

  @override
  void initState() {
    super.initState();
    _likeCount = widget.initialLikeCount;
    _checkIfLiked();
  }

  Future<void> _checkIfLiked() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final recipeDoc = await FirebaseFirestore.instance
          .collection('recipes')
          .doc(widget.recipeTitle)
          .get();

      if (recipeDoc.exists) {
        final likes = List<String>.from(recipeDoc.data()?['likes'] ?? []);
        if (mounted) {
          setState(() {
            _isLiked = likes.contains(user.uid);
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _isLiked = false;
          });
        }
      }
    } catch (e) {
      print("Error checking if liked: $e");
    }
  }

  void _toggleLike() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      widget.onNeedLogin(); 
      return;
    }

    final recipeRef = FirebaseFirestore.instance
        .collection('recipes')
        .doc(widget.recipeTitle);

    try {
      final snapshot = await recipeRef.get();

      if (!snapshot.exists) {
        await recipeRef.set({'likes': []});
      }

      if (mounted) {
        setState(() {
          _isLiked = !_isLiked;
          _likeCount = _isLiked ? _likeCount + 1 : _likeCount - 1;
        });
      }

      if (_isLiked) {
        await recipeRef.update({
          'likes': FieldValue.arrayUnion([user.uid]),
        });
      } else {
        await recipeRef.update({
          'likes': FieldValue.arrayRemove([user.uid]),
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLiked = !_isLiked;
          _likeCount = _isLiked ? _likeCount + 1 : _likeCount - 1;
        });
      }
      print("Error toggling like: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(
            _isLiked ? Icons.favorite : Icons.favorite_border,
            color: _isLiked ? Colors.red : const Color(0xFF3D3D3D),
          ),
          onPressed: _toggleLike,
        ),
        Text('$_likeCount إعجاب'),
      ],
    );
  }
}