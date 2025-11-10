// lib/main.dart

import 'package:flutter/material.dart';
import 'home_screen.dart'; // Import màn hình chính

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quản lý Chi tiêu',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        // Cải thiện giao diện cho Form
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          labelStyle: TextStyle(fontSize: 16),
        ),
      ),
      // Bắt đầu ứng dụng với HomeScreen
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}