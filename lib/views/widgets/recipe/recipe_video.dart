import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../core/utils/brand_colors.dart';
import '../../../core/utils/network_helpers/network_utils.dart';

class RecipeVideoWidget extends StatefulWidget {
  final YoutubePlayerController controller;

  const RecipeVideoWidget({super.key, required this.controller});

  @override
  State<RecipeVideoWidget> createState() => _RecipeVideoWidgetState();
}

class _RecipeVideoWidgetState extends State<RecipeVideoWidget> {
  bool hasInternet = true;
  bool checkedConnection = false;

  @override
  void initState() {
    super.initState();
    debugPrint('initState في RecipeVideoWidget');
    _checkInternet();
  }

  Future<void> _checkInternet() async {
    debugPrint('بدأ التحقق من الاتصال بالإنترنت');

    final connected = await handleWithRetry<bool>(
      request: () async => await NetworkUtils.hasInternetConnection(),
      fallbackValue: false,
      onFail: () {
        debugPrint('فشل التحقق من الاتصال بالإنترنت');
      },
    );

    if (!connected && mounted) {
      debugPrint('سيتم عرض Dialog الآن');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("مشكلة في الاتصال"),
          content: const Text("لا يمكن تحميل الفيديو بسبب انقطاع الإنترنت"),
          actions: [
            TextButton(
              child: const Text("حسنًا"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    }

    if (mounted) {
      setState(() {
        hasInternet = connected;
        checkedConnection = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!checkedConnection) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!hasInternet || widget.controller.initialVideoId.isEmpty) {
      return Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Icon(Icons.wifi_off, size: 48, color: Colors.grey),
            const SizedBox(height: 12),
            const Text("لا يمكن تحميل الفيديو بدون اتصال بالإنترنت"),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _checkInternet,
              icon: const Icon(Icons.refresh),
              label: const Text("إعادة المحاولة"),
              style: ElevatedButton.styleFrom(
                backgroundColor: BrandColors.secondaryColor,
              ),
            ),
          ],
        ),
      );
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            'فيديو التحضير',
            style: TextStyle(
              fontSize: isSmallScreen ? 24 : 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: isSmallScreen ? 12 : 20),
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: AspectRatio(
            aspectRatio: isSmallScreen ? 16 / 9 : 21 / 9,
            child: YoutubePlayer(
              controller: widget.controller,
              showVideoProgressIndicator: true,
              progressIndicatorColor: BrandColors.secondaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
