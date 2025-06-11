import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

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
    this.fit = BoxFit.contain, 
  }) : super(key: key);

  Future<bool> checkConnection() async {
    final checker = InternetConnectionChecker.createInstance();
    return await checker.hasConnection;
  }

  Widget _buildPlaceholder() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey.shade200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.restaurant,
              size: width * 0.3,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 8),
            Text(
              'صورة الوصفة غير متوفرة',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: checkConnection(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildPlaceholder();
        } else if (snapshot.hasData && snapshot.data!) {
          if (imageUrl != null && imageUrl!.isNotEmpty) {
            return CachedNetworkImage(
              imageUrl: imageUrl!,
              width: width,
              height: height,
              fit: fit,
              placeholder: (context, url) => _buildPlaceholder(),
              errorWidget: (context, url, error) => _buildPlaceholder(),
            );
          } else {
            return _buildPlaceholder();
          }
        } else {
          return _buildPlaceholder();
        }
      },
    );
  }
}