import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/data_controller.dart';

class PreviewTable extends StatelessWidget {
  final DataController controller = Get.find<DataController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.csvData.isEmpty) return Container();
      // Display header and first 3 data rows.
      int rowCount = (controller.csvData.length < 4) ? controller.csvData.length : 4;
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: controller.headers
              .map((header) => DataColumn(
                    label: Text(
                      header,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ))
              .toList(),
          rows: List.generate(rowCount - 1, (index) {
            int dataIndex = index + 1;
            return DataRow(
              cells: controller.csvData[dataIndex]
                  .map<DataCell>((cell) => DataCell(Text(cell.toString())))
                  .toList(),
            );
          }),
        ),
      );
    });
  }
}
