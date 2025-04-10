import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:screenshot/screenshot.dart';
import '../controller/data_controller.dart';
import '../services/export_service.dart';

class ChartData {
  final String label;
  final double value;

  ChartData({required this.label, required this.value});
}

class ChartPage extends StatefulWidget {
  @override
  _ChartPageState createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  final DataController controller = Get.find<DataController>();
  final ScreenshotController screenshotController = ScreenshotController();
  final ExportService exportService = ExportService();

  Future<void> _captureAndSaveChartAsImage() async {
    try {
      final image = await screenshotController.capture();
      if (image != null) {
        await exportService.saveImage(image);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Chart saved successfully!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save chart: $e')),
      );
    }
  }

  bool showPieChart = true;

  @override
  Widget build(BuildContext context) {
    double chartWidth = MediaQuery.of(context).size.width * 0.9;
    double chartHeight = MediaQuery.of(context).size.height * 0.45;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chart'),
//         actions: [
//          IconButton(
//   icon: const Icon(Icons.download),
//   onPressed: () async {
//     await _captureAndSaveChartAsImage();
//   },
// ),

//         ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ToggleButtons(
              isSelected: [showPieChart, !showPieChart],
              onPressed: (index) {
                setState(() {
                  showPieChart = index == 0;
                });
              },
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text("Pie Chart"),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text("Histogram"),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Screenshot(
              controller: screenshotController,
              child: Column(
                children: [
                  Container(
                    width: chartWidth,
                    height: chartHeight,
                    child: Obx(() {
                      if (controller.chartData.isEmpty) {
                        return const Center(child: Text("No data available"));
                      }
                      return showPieChart
                          ? _buildPieChart()
                          : _buildHistogram();
                    }),
                  ),
                  if (showPieChart) const SizedBox(height: 16),
                  if (showPieChart) _buildLegend(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPieChart() {
    final data = controller.chartData;
    final total = data.fold(0.0, (sum, item) => sum + item.value);

    return PieChart(
      PieChartData(
        sectionsSpace: 2,
        centerSpaceRadius: 40,
        sections: data.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final percentage = (item.value / total * 100).toStringAsFixed(1);
          final color = Colors.primaries[index % Colors.primaries.length];

          return PieChartSectionData(
            color: color,
            value: item.value,
            radius: 100,
            showTitle: false,
            badgeWidget: _buildBadge('$percentage%', color),
            badgePositionPercentageOffset: 1.3,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBadge(String text, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildLegend() {
    final data = controller.chartData;
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: data.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: Colors.primaries[index % Colors.primaries.length],
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              item.label,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildHistogram() {
    final data = controller.chartData;
    final barWidth = 26.0;
    final labelAngle = -0.6;
    final maxY = data.map((e) => e.value).reduce((a, b) => a > b ? a : b) + 10;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding:
            const EdgeInsets.only(top: 16, bottom: 16), // Extra top for labels
        child: SizedBox(
          width: data.length * (barWidth + 40),
          height: 320,
          child: BarChart(
            BarChartData(
              maxY: maxY,
              barGroups: data.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;

                return BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: item.value,
                      width: barWidth,
                      gradient: LinearGradient(
                        colors: [
                          Colors.primaries[index % Colors.primaries.length]
                              .shade300,
                          Colors.primaries[index % Colors.primaries.length],
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(6),
                        topRight: Radius.circular(6),
                      ),
                    ),
                  ],
                );
              }).toList(),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      int index = value.toInt();
                      if (index < data.length) {
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          space: 8,
                          child: Transform.rotate(
                            angle: labelAngle,
                            child: Text(
                              data[index].label.length > 10
                                  ? data[index].label.substring(0, 10) + '…'
                                  : data[index].label,
                              style: const TextStyle(fontSize: 10),
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: _getYAxisInterval(controller.chartData
                        .map((item) =>
                            ChartData(label: item.label, value: item.value))
                        .toList()),
                    reservedSize: 40, // Increased space to avoid overlap
                    getTitlesWidget: (value, meta) {
                      return SideTitleWidget(
                        axisSide: meta.axisSide,
                        space: 6, // Padding between axis and label
                        child: Text(
                          value.toStringAsFixed(0),
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.black,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    getTitlesWidget: (value, meta) {
                      int index = value.toInt();
                      if (index < data.length) {
                        final val = data[index].value;
                        return Padding(
                          padding:
                              const EdgeInsets.only(bottom: 6), // Push upward
                          child: Text(
                            val.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
                rightTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              gridData: FlGridData(show: true),
              borderData: FlBorderData(show: false),
              alignment: BarChartAlignment.spaceAround,
            ),
          ),
        ),
      ),
    );
  }

  double _getYAxisInterval(List<ChartData> data) {
    final max = data.map((e) => e.value).reduce((a, b) => a > b ? a : b);
    if (max <= 10) return 1;
    if (max <= 50) return 5;
    if (max <= 100) return 10;
    return (max / 10).roundToDouble();
  }
}
