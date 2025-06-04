import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';

class AvatarSection extends StatefulWidget {
  final bool hasImage;
  final String? imageUrl;
  final File? imageFile;
  final Function(String newUrl) onImageChanged;

  const AvatarSection({
    Key? key,
    required this.hasImage,
    this.imageUrl,
    this.imageFile,
    required this.onImageChanged,
  }) : super(key: key);

  @override
  State<AvatarSection> createState() => _AvatarSectionState();
}

class _AvatarSectionState extends State<AvatarSection> {
  final ImagePicker _picker = ImagePicker();

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

  Future<void> _pickAndUploadImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (pickedFile == null) return;

    final file = File(pickedFile.path);

    final uploadUrl = Uri.parse('https://api.cloudinary.com/v1_1/dflfjyux4/image/upload');
    final request = http.MultipartRequest('POST', uploadUrl)
      ..fields['upload_preset'] = 'flutter_unsigned'
      ..files.add(await http.MultipartFile.fromPath('file', file.path));

    final response = await request.send();

    if (response.statusCode == 200) {
      final res = await http.Response.fromStream(response);
      final data = json.decode(res.body);
      final imageUrl = data['secure_url'];

      widget.onImageChanged(imageUrl);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("فشل رفع الصورة")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider imageProvider;

    if (widget.imageFile != null) {
      imageProvider = FileImage(widget.imageFile!);
    } else if (widget.hasImage && widget.imageUrl != null && widget.imageUrl!.isNotEmpty) {
      imageProvider = CachedNetworkImageProvider(widget.imageUrl!);
    } else {
      imageProvider = const NetworkImage(
        'https://static.vecteezy.com/system/resources/previews/009/292/244/non_2x/default-avatar-icon-of-social-media-user-vector.jpg',
      );
    }

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            if (widget.imageFile != null || (widget.imageUrl != null && widget.imageUrl!.isNotEmpty)) {
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
        ),
        TextButton.icon(
          onPressed: _pickAndUploadImage,
          icon: const Icon(Icons.edit),
          label: const Text("تغيير الصورة"),
        )
      ],
    );
  }
}
