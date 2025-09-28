import 'package:flutter/material.dart';
import 'dashboard_admin.dart'; // pastikan impor file yg benar

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Admin Dashboard',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: DashboardAdmin(), // ✅ tanpa const
    );
  }
}
