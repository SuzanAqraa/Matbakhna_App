import 'dart:io';
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
    ImageProvider imageProvider;

    if (imageFile != null) {
      imageProvider = FileImage(imageFile!);
    } else if (hasImage && imageUrl != null && imageUrl!.isNotEmpty) {
      imageProvider = NetworkImage(imageUrl!);
    } else {
      imageProvider = const AssetImage('assets/assets/default_profile.png');
    }

    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.grey[300],
          backgroundImage: imageProvider,
          child: imageProvider is AssetImage
              ? const Icon(Icons.person, size: 60, color: Colors.white)
              : null,
        ),
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
