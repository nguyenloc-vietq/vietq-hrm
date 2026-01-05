import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AvatarPicker extends StatefulWidget {
  final String? avatarUrl;
  final Future<bool> Function(XFile file)? onImageSelected;


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
      // callback để upload lên server
     bool isSetAvatar =  await widget.onImageSelected!(pickedFile);
     if (isSetAvatar) {
       setState(() {
         _imageFile = File(pickedFile.path);
       });
     }
    }
  }

  @override
  Widget build(BuildContext context) {
    final avatarUrl = widget.avatarUrl ?? '';

    Widget avatarChild;
    if (_imageFile != null) {
      avatarChild = Image.file(
        _imageFile!,
        fit: BoxFit.cover,
        width: 100.w,
        height: 100.h,
      );
    } else if (avatarUrl.isNotEmpty) {
      avatarChild = Image.network(
        '${dotenv.env['IMAGE_ENDPOINT']}$avatarUrl',
        fit: BoxFit.cover,
        width: 100.w,
        height: 100.h,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            'assets/default_avatar.png', // Fallback image
            fit: BoxFit.cover,
            width: 100.w,
            height: 100.h,
          );
        },
      );
    } else {
      avatarChild = Image.asset(
        'assets/default_avatar.png', // Default image
        fit: BoxFit.cover,
        width: 100.w,
        height: 100.h,
      );
    }

    return Stack(
      alignment: Alignment.bottomRight,
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 100,
          height: 100,
          padding: EdgeInsets.all(5.r),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
                color: Theme.of(context).colorScheme.primary, width: 5.r),
          ),
          child: CircleAvatar(
            radius: 50.r,
            backgroundColor: Colors.transparent,
            child: ClipOval(
              child: avatarChild,
            ),
          ),
        ),
        Positioned(
          bottom: -5.h,
          right: -5.w,
          child: GestureDetector(
            onTap: _pickImage,
            child: Container(
              padding: EdgeInsets.all(6.r),
              decoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(10.r)),
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
