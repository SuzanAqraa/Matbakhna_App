import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AvatarSection extends StatelessWidget {
  final bool hasImage;
  final String? imageUrl;
  final File? imageFile;
  final VoidCallback onEditPressed;

  const AvatarSection({
    Key? key,
    required this.hasImage,
    required this.onEditPressed,
    this.imageUrl,
    this.imageFile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;

    if (imageFile != null) {
      imageWidget = CircleAvatar(
        radius: 50,
        backgroundImage: FileImage(imageFile!),
      );
    } else if (hasImage && imageUrl != null && imageUrl!.isNotEmpty) {
      imageWidget = CircleAvatar(
        radius: 50,
        backgroundColor: Colors.grey[300],
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: imageUrl!,
            width: 100,
            height: 100,
            fit: BoxFit.cover,
            placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => const Icon(Icons.person, size: 60, color: Colors.white),
          ),
        ),
      );
    } else {
      imageWidget = const CircleAvatar(
        radius: 50,
        backgroundColor: Colors.grey,
        child: Icon(Icons.person, size: 60, color: Colors.white),
      );
    }

    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        imageWidget,
        CircleAvatar(
          backgroundColor: Colors.white,
          radius: 18,
          child: IconButton(
            padding: EdgeInsets.zero,
            icon: const Icon(Icons.edit, size: 18),
            onPressed: onEditPressed,
          ),
        ),
      ],
    );
  }
}
