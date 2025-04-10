import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/data_controller.dart';

class ColumnSelector extends StatelessWidget {
  final DataController controller = Get.find<DataController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.headers.isEmpty) return Container();
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Label (X-axis) dropdown.
          Column(
            children: [
              Text('Select Label Column'),
              DropdownButton<String>(
                value: controller.selectedLabelColumn.value,
                items: controller.headers
                    .map((col) => DropdownMenuItem<String>(
                          value: col,
                          child: Text(col),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    controller.selectedLabelColumn.value = value;
                    controller.parseChartData();
                  }
                },
              ),
            ],
          ),
          // Value (Y-axis) dropdown.
          Column(
            children: [
              Text('Select Value Column'),
              DropdownButton<String>(
                value: controller.selectedValueColumn.value,
                items: controller.headers
                    .map((col) => DropdownMenuItem<String>(
                          value: col,
                          child: Text(col),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    controller.selectedValueColumn.value = value;
                    controller.parseChartData();
                  }
                },
              ),
            ],
          ),
        ],
      );
    });
  }
}
