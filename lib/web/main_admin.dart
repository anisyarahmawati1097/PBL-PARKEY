import 'package:flutter/material.dart';
import 'package:flutter_application_1/web/login_admin.dart';
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
      home: LoginAdminPage(), // ✅ tanpa const
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginAdminPage(),
        '/dashboard' : (context) => const DashboardAdmin()
      },
    );
  }
}
