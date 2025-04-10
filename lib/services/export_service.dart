import 'dart:io';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:pdf/widgets.dart' as pw;

class ExportService {
  /// Captures a widget as an image and creates a PDF document.
  Future<pw.Document> exportChartAsPdf(ScreenshotController screenshotController) async {
    Uint8List? imageBytes = await screenshotController.capture();
    final pdf = pw.Document();
    if (imageBytes != null) {
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Center(child: pw.Image(pw.MemoryImage(imageBytes)));
          },
        ),
      );
    }
    return pdf;
  }
  Future<void> saveImage(Uint8List imageBytes) async {
    // Request permission
    if (!await Permission.storage.request().isGranted) {
      throw Exception("Storage permission denied");
    }

    // Create directory
    final directory = Directory('/storage/emulated/0/Download/Charts');
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    // Create file
    final filePath = '${directory.path}/chart_${DateTime.now().millisecondsSinceEpoch}.png';
    final file = File(filePath);

    // Save image
    await file.writeAsBytes(imageBytes);
  }

  Future<void> _captureAndSaveChartAsImage(ScreenshotController screenshotController) async {
  try {
    // Request storage permissions
    if (!await Permission.storage.request().isGranted) {
      Get.snackbar("Permission Denied", "Storage permission is required.");
      return;
    }

    // Capture the widget as image
    final imageBytes = await screenshotController.capture();
    if (imageBytes == null) {
      Get.snackbar("Error", "Failed to capture chart.");
      return;
    }

    // Get public Downloads directory
    final baseDir = Directory('/storage/emulated/0/Download/Charts');
    if (!await baseDir.exists()) {
      await baseDir.create(recursive: true);
    }

    // Create unique file name
    final fileName = 'chart_${DateTime.now().millisecondsSinceEpoch}.png';
    final filePath = '${baseDir.path}/$fileName';

    // Write file
    final file = File(filePath);
    await file.writeAsBytes(imageBytes);

    // Show success
    Get.snackbar("Saved", "Chart saved to Downloads/Charts as $fileName");
  } catch (e) {
    Get.snackbar("Error", "Something went wrong: $e");
  }
}

}
