import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:safeemilocker/text_style/app_text_styles.dart';
import 'package:safeemilocker/text_style/colors.dart';

Future<File?> openFilePicker(BuildContext context) async {
  return await showModalBottomSheet<File?>(
    context: context,
    builder: (BuildContext context) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: 300,
        child: Column(
          children: [
            const SizedBox(height: 30),
            Container(
              height: 5,
              width: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: AppColors.primaryOrange,
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// CAMERA
                GestureDetector(
                  onTap: () async {
                    final file = await getImageFromCamera();
                    Navigator.pop(context, file); // ✅ FIX
                  },
                  child: _pickerCard(
                    icon: Icons.camera_alt,
                    title: "Open Camera",
                  ),
                ),

                /// GALLERY
                GestureDetector(
                  onTap: () async {
                    final file = await getImageFromGallery();
                    Navigator.pop(context, file); // ✅ FIX
                  },
                  child: _pickerCard(
                    icon: Icons.photo_library_outlined,
                    title: "Open Gallery",
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}

Future<File?> getImageFromGallery() async {
  ImagePicker _picker = ImagePicker();
  var pickedFile = await _picker.pickImage(
    source: ImageSource.gallery,
    imageQuality: 60,
  );
  if (pickedFile != null) {
    return File(pickedFile.path);
  } else {
    return null;
  }
}

Future<File?> getImageFromCamera() async {
  ImagePicker _picker = ImagePicker();
  var pickedFile = await _picker.pickImage(
    source: ImageSource.camera,
    imageQuality: 60,
  );
  if (pickedFile != null) {
    print(pickedFile.path);
    return File(pickedFile.path);
  } else {
    return null;
  }
}

Widget _pickerCard({required IconData icon, required String title}) {
  return SizedBox(
    height: 180,
    width: 160,
    child: Card(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 28, color: AppColors.blackColor),
          const SizedBox(height: 20),
          Text(title, style: AppTextStyles.heading18w700blackColor),
        ],
      ),
    ),
  );
}
