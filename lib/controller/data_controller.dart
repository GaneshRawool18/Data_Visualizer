import 'dart:io';
import 'package:get/get.dart';
import '../model/chart_data_model.dart';
import '../services/file_service.dart';

class DataController extends GetxController {
  var csvData = <List<dynamic>>[].obs;
  var chartData = <ChartDataModel>[].obs;
  var headers = <String>[].obs;
  var recentFiles = <String>[].obs;
  var selectedLabelColumn = ''.obs;
  var selectedValueColumn = ''.obs;

  final fileService = FileService();

  Future<void> loadCsv(File file) async {
    try {
      var data = await fileService.readCsv(file);
      csvData.value = data;
      if (data.isNotEmpty) {
        headers.value = data[0].map((e) => e.toString()).toList();
        if (headers.isNotEmpty) {
          selectedLabelColumn.value = headers.first;
          selectedValueColumn.value = headers.last;
        }
      }
      recentFiles.add(file.path.split('/').last);
    } catch (e) {
      Get.snackbar("Error", "Failed to load CSV file: $e");
    }
  }

  void parseChartData() {
    if (csvData.isEmpty) return;
    chartData.value = fileService.parseData(
      csvData.value,
      selectedLabelColumn.value,
      selectedValueColumn.value,
    );
  }
}
