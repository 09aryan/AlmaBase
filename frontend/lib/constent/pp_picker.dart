import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class ProfileImagePicker extends StatefulWidget {
  final File? pickedImage; // Declare pickedImage as a parameter
  final void Function(File image) onImagePicked;

  const ProfileImagePicker({
    Key? key,
    required this.pickedImage,
    required this.onImagePicked,
  }) : super(key: key);

  @override
  State<ProfileImagePicker> createState() => _ProfileImagePickerState();
}

class _ProfileImagePickerState extends State<ProfileImagePicker> {
  Future<void> _pickImage() async {
    try {
      FilePickerResult? result =
          await FilePicker.platform.pickFiles(type: FileType.image);
      if (result != null) {
        File pickedImage = File(result.files.single.path!);
        widget.onImagePicked(pickedImage);
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.pickedImage != null
        ? Container(
            height: 160,
            width: 130,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                10,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.file(
                widget.pickedImage!,
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
            ),
          )
        : GestureDetector(
            onTap: _pickImage,
            child: Container(
              height: 100,
              width: 100,
              child: DottedBorder(
                color: Colors.grey,
                strokeWidth: 1,
                borderType: BorderType.RRect,
                radius: Radius.circular(12),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Icon(
                    Icons.image,
                    size: 100,
                  ),
                ),
              ),
            ),
          );
  }
}
