import 'package:flutter/material.dart';

class CreditsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Credits & About'),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Data Visualizer",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text("Developed by: Ganesh Rawool"),
            SizedBox(height: 10),
            Text("SRN : 202201921"),
            SizedBox(height: 10),
            Text("Mentor: Shriprada chaturbhuj"),
            SizedBox(height: 10),
            Text("Project : Pie Chart and Histogram Generator."),
            SizedBox(height: 20),
            Text("Technologies Used:",
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text("- Flutter"),
            Text("- GetX for State Management"),
            Text("- Google Fonts"),
            Text("- fl_chart"),
            Text("- CSV, File Picker"),
            Text("- Screenshot & PDF"),
            SizedBox(height: 20),
            Text("GitHub: https://github.com/GaneshRawool18/Data_Visualizer"),
          ],
        ),
      ),
    );
  }
}
