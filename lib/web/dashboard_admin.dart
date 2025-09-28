import 'package:flutter/material.dart';
import 'pengendara_page.dart';
import 'laporan_page.dart';
import 'lokasi_page.dart';
import 'widgets/sidebar.dart';
import 'widgets/header.dart';

class DashboardAdmin extends StatefulWidget {
  const DashboardAdmin({super.key});

  @override
  State<DashboardAdmin> createState() => _DashboardAdminState();
}

class _DashboardAdminState extends State<DashboardAdmin> {
  String _selectedPage = "dashboard";

  Widget _getPage(String page) {
    switch (page) {
      case "pengendara":
        return const PengendaraPage();
      case "lokasi":
        return const LokasiPageAdmin();
      case "laporan":
        return const LaporanPage();
      default:
        return const Center(child: Text("📊 Selamat datang di Dashboard Admin"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Header(),
      drawer: Sidebar(
        onMenuTap: (page) {
          setState(() {
            _selectedPage = page;
          });
          Navigator.pop(context); // tutup drawer
        },
      ),
      body: _getPage(_selectedPage),
    );
  }
}
