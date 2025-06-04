import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AvatarSection extends StatelessWidget {
  final bool hasImage;
  final String? imageUrl;
  final File? imageFile;

  const AvatarSection({
    Key? key,
    required this.hasImage,
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
      imageProvider = const NetworkImage(
        'https://static.vecteezy.com/system/resources/previews/009/292/244/non_2x/default-avatar-icon-of-social-media-user-vector.jpg',
      );
    }

    return GestureDetector(
      onTap: () {
        if (imageFile != null || (imageUrl != null && imageUrl!.isNotEmpty)) {
          _showImageDialog(context, imageProvider);
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
    );
  }
}
