import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'view/home_page.dart';

void main() {
  runApp(DataVisualizerApp());
}

class DataVisualizerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Data Visualizer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        // Use Google Fonts for a modern look.
        textTheme: GoogleFonts.latoTextTheme(Theme.of(context).textTheme),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        textTheme: GoogleFonts.latoTextTheme(Theme.of(context).textTheme),
      ),
      themeMode: ThemeMode.system,
      home: HomePage(),
    );
  }
}
