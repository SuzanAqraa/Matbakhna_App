import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfileImageWithPlaceholder extends StatelessWidget {
  final String? imageUrl;
  final File? imageFile;
  final double radius;
  final VoidCallback? onTap;

  const ProfileImageWithPlaceholder({
    super.key,
    this.imageUrl,
    this.imageFile,
    required this.radius,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (imageFile != null) {
      return GestureDetector(
        onTap: onTap,
        child: CircleAvatar(
          radius: radius,
          backgroundColor: Colors.grey.shade200,
          backgroundImage: FileImage(imageFile!),
        ),
      );
    } else if (imageUrl != null && imageUrl!.isNotEmpty) {
      return GestureDetector(
        onTap: onTap,
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: imageUrl!,
            width: radius * 2,
            height: radius * 2,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              width: radius * 2,
              height: radius * 2,
              color: Colors.grey.shade200,
              child: const Center(child: CircularProgressIndicator()),
            ),
            errorWidget: (context, url, error) => Container(
              width: radius * 2,
              height: radius * 2,
              color: Colors.grey.shade200,
              child: const Icon(Icons.person, size: 40, color: Colors.grey),
            ),
          ),
        ),
      );
    } else {
      return GestureDetector(
        onTap: onTap,
        child: CircleAvatar(
          radius: radius,
          backgroundColor: Colors.grey.shade200,
          child: const Icon(Icons.person, size: 40, color: Colors.grey),
        ),
      );
    }
  }
}
