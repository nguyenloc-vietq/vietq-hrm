import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AvatarPicker extends StatefulWidget {
  final String? avatarUrl;
  final Function(File) onImageSelected;

  const AvatarPicker({super.key, this.avatarUrl, required this.onImageSelected});

  @override
  State<AvatarPicker> createState() => _AvatarPickerState();
}

class _AvatarPickerState extends State<AvatarPicker> {
  File? _imageFile;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });

      // callback để upload lên server
      widget.onImageSelected(_imageFile!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final avatarUrl = widget.avatarUrl ?? '';

    return Stack(
      alignment: Alignment.bottomRight,
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 100,
          height: 100,
          padding: const EdgeInsets.all(5).r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Theme.of(context).colorScheme.primary, width: 5.r),
          ),
          child: CircleAvatar(
            radius: 50.r,
            backgroundImage: _imageFile != null
                ? FileImage(_imageFile!)
                : (avatarUrl.isNotEmpty
                ? NetworkImage('${dotenv.env['IMAGE_ENDPOINT']}$avatarUrl') as ImageProvider
                : const AssetImage('assets/default_avatar.png')),
          ),
        ),
        Positioned(
          bottom: -5.h,
          right: -5.w,
          child: GestureDetector(
            onTap: _pickImage,
            child: Container(
              padding: const EdgeInsets.all(6).r,
              decoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.rectangle,
                borderRadius: const BorderRadius.all(Radius.circular(10)).r,
                border: Border.all(color: Colors.white, width: 2.r),
              ),
              child: Icon(
                Icons.camera_alt,
                color: Colors.white,
                size: 25.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
