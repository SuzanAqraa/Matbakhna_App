import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class NetworkImageWithPlaceholder extends StatelessWidget {
  final String? imageUrl;
  final double width;
  final double height;
  final BoxFit fit;

  const NetworkImageWithPlaceholder({
    Key? key,
    required this.imageUrl,
    required this.width,
    required this.height,
    this.fit = BoxFit.cover,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: imageUrl!,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) => Container(
          width: width,
          height: height,
          color: Colors.grey.shade200,
          child: const Center(child: CircularProgressIndicator()),
        ),
        errorWidget: (context, url, error) => Image.asset(
          'assets/images/default-featured-image.png.jpg',
          width: width,
          height: height,
          fit: fit,
        ),
      );
    } else {
      return Image.asset(
        'assets/images/default-featured-image.png.jpg',
        width: width,
        height: height,
        fit: fit,
      );
    }
  }
}
