import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// PAGES
import 'pengendara_page.dart';
import 'laporan_page.dart';
import 'lokasi_page.dart';

// WIDGETS
import 'widgets/sidebar.dart';
import 'widgets/header.dart';

class DashboardAdmin extends StatefulWidget {
  const DashboardAdmin({super.key});

  @override
  State<DashboardAdmin> createState() => _DashboardAdminState();
}

class _DashboardAdminState extends State<DashboardAdmin> {
  String _selectedPage = "dashboard";

  int pengendaraCount = 0;
  int lokasiCount = 0;
  int laporanCount = 0;

  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchStats();
  }

  Future fetchStats() async {
    try {
      final res = await http.get(
        Uri.parse("http://192.168.14.134:8000/api/dashboard/stats"),
      );

      if (res.statusCode == 200) {
        final json = jsonDecode(res.body);

        setState(() {
          pengendaraCount = json['pengendara'];
          lokasiCount = json['lokasi'];
          laporanCount = json['laporan'];
          loading = false;
        });
      } else {
        setState(() => loading = false);
      }
    } catch (e) {
      print("Error fetch stats: $e");
      setState(() => loading = false);
    }
  }

  Widget _getPage(String page) {
    switch (page) {
      case "pengendara":
        return const PengendaraPage();
      case "lokasi":
        return const LokasiPageAdmin();
      case "laporan":
        return const LaporanPage();
      default:
        return _buildDashboardHome();
    }
  }

  Widget _buildDashboardHome() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 35,
                backgroundColor: Colors.green[400],
                backgroundImage: const AssetImage("assets/logo_parqrin.png"),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("Halo, Admin 👋",
                      style: TextStyle(fontSize: 18, color: Colors.black54)),
                  Text("Selamat Datang di Panel",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

        

          const SizedBox(height: 24),

          if (loading) const Center(child: CircularProgressIndicator()),

          if (!loading)
            Row(
              children: [
                _buildStatCard("Pengendara", pengendaraCount.toString(),
                    Icons.people, Colors.blue),
                const SizedBox(width: 12),
                _buildStatCard("Lokasi", lokasiCount.toString(),
                    Icons.location_on, Colors.orange),
                const SizedBox(width: 12),
                _buildStatCard("Laporan", laporanCount.toString(),
                    Icons.insert_chart, Colors.red),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
          child: Column(
            children: [
              CircleAvatar(
                backgroundColor: color.withOpacity(0.15),
                radius: 28,
                child: Icon(icon, size: 32, color: color),
              ),
              const SizedBox(height: 12),
              Text(value,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(title, style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(
          title: _selectedPage == "dashboard" ? "Dashboard Admin" : "Menu"),
      drawer: Sidebar(
        currentPage: _selectedPage,
        onMenuTap: (page) {
          setState(() => _selectedPage = page);
          Navigator.pop(context);
        },
      ),
      body: _getPage(_selectedPage),
    );
  }
}
