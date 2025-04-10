import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/data_controller.dart';

class UploadBox extends StatelessWidget {
  final DataController controller = Get.find<DataController>();

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );
    if (result != null && result.files.single.path != null) {
      File file = File(result.files.single.path!);
      await controller.loadCsv(file);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickFile,
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            // Dark shadow (bottom-right)
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: Offset(4, 4),
              blurRadius: 10,
            ),
            // Light shadow (top-left)
            BoxShadow(
              color: Colors.white.withOpacity(0.7),
              offset: Offset(-4, -4),
              blurRadius: 10,
            ),
          ],
        ),
        child: Center(
          child: Text(
            'Drag & Drop or Tap to Upload CSV',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
