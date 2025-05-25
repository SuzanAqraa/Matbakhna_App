import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

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

  void _showImageDialog(BuildContext context, ImageProvider imageProvider) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: InteractiveViewer(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.contain,
                ),
              ),
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.6,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider imageProvider;

    if (imageFile != null) {
      imageProvider = FileImage(imageFile!);
    } else if (hasImage && imageUrl != null && imageUrl!.isNotEmpty) {
      imageProvider = CachedNetworkImageProvider(imageUrl!);
    } else {
      imageProvider = const AssetImage('assets/assets/default_profile.png');
    }

    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        GestureDetector(
          onTap: () {
            if (imageFile != null || (imageUrl != null && imageUrl!.isNotEmpty)) {
              _showImageDialog(context, imageProvider);
            } else {
              onEditPressed();
            }
          },
          child: CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey[300],
            backgroundImage: imageProvider,
            child: imageProvider is AssetImage
                ? const Icon(Icons.person, size: 60, color: Colors.white)
                : null,
          ),
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
