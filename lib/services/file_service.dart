import 'dart:io';
import 'package:csv/csv.dart';
import '../model/chart_data_model.dart';

class FileService {
  Future<List<List<dynamic>>> readCsv(File file) async {
    final csvString = await file.readAsString();
    return const CsvToListConverter().convert(csvString);
  }

  List<ChartDataModel> parseData(List<List<dynamic>> csvTable, String labelColumn, String valueColumn) {
    List<ChartDataModel> data = [];
    // Assume first row is header.
    int labelIndex = csvTable[0].indexOf(labelColumn);
    int valueIndex = csvTable[0].indexOf(valueColumn);
    for (int i = 1; i < csvTable.length; i++) {
      final row = csvTable[i];
      data.add(ChartDataModel(
        label: row[labelIndex].toString(),
        value: double.tryParse(row[valueIndex].toString()) ?? 0,
      ));
    }
    return data;
  }
}
