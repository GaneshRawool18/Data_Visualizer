import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/data_controller.dart';
import '../widgets/upload_box.dart';
import '../widgets/preview_table.dart';
import '../widgets/column_selector.dart';
import 'chart_page.dart';
import 'credits_page.dart';

class HomePage extends StatelessWidget {
  final DataController controller = Get.put(DataController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Visualizer', style: TextStyle(fontSize: 20)),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () => Get.to(() => CreditsPage()),
          ),
          // IconButton(
          //   icon: Icon(Icons.brightness_6),
          //   onPressed: () {
          //     Get.changeThemeMode(
          //         Get.isDarkMode ? ThemeMode.light : ThemeMode.dark);
          //   },
          // ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            UploadBox(),
            SizedBox(height: 20),
            PreviewTable(),
            SizedBox(height: 20),
            ColumnSelector(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (controller.csvData.isNotEmpty) {
                  controller.parseChartData();
                  Get.to(() => ChartPage());
                }
              },
              child: Text('Generate Chart'),
            ),
            SizedBox(height: 20),
            Obx(() {
              if (controller.recentFiles.isEmpty) return Container();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Recent Files:',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  ...controller.recentFiles.map((file) => Text(file)).toList(),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
