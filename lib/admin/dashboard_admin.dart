import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// ========================
// PAGES
// ========================
import 'pengendara_page.dart';
import 'laporan_page.dart';
import 'monitoring_parkir.dart';

// ========================
// WIDGETS
// ========================
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

  int? lokasiId;
  String namaLokasi = "";

  bool loading = true;
  bool loadingAdmin = true;

  @override
  void initState() {
    super.initState();
    loadAdminLocation();
  }

  // ========================
  // LOAD DATA ADMIN
  // ========================
  Future<void> loadAdminLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    lokasiId = prefs.getInt("lokasi_id");
    namaLokasi = prefs.getString("nama_lokasi") ?? "";

    setState(() => loadingAdmin = false);

    if (lokasiId != null) {
      fetchStats();         // fetch pengendara & lokasi
      fetchLaporanCount();  // fetch jumlah laporan langsung
    }
  }

  // ========================
  // FETCH STATS (PENGENDARA & LOKASI)
  // ========================
  Future fetchStats() async {
    if (lokasiId == null) return;

    try {
      final res = await http.get(
        Uri.parse(
          "http://192.168.156.134:8000/api/dashboard/stats?lokasi_id=$lokasiId",
        ),
      );

      if (res.statusCode == 200) {
        final json = jsonDecode(res.body);

        setState(() {
          pengendaraCount = json['pengendara'];
          lokasiCount = json['lokasi'];
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

  // ========================
  // FETCH JUMLAH LAPORAN LANGSUNG
  // ========================
  Future<void> fetchLaporanCount() async {
    if (lokasiId == null) return;

    try {
      final url =
          'http://192.168.217.134:8000/api/laporan/harian-lokasi?lokasi_id=$lokasiId';
      final res = await http.get(Uri.parse(url));

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as List;
        setState(() {
          laporanCount = data.length; // hitung jumlah laporan
        });
      } else {
        print("Error fetch laporan: ${res.statusCode}");
      }
    } catch (e) {
      print("Exception fetch laporan: $e");
    }
  }

  // ========================
  // ROUTING PAGE
  // ========================
  Widget _getPage(String page) {
    if (loadingAdmin) {
      return const Center(child: CircularProgressIndicator());
    }

    if (lokasiId == null) {
      return const Center(
        child: Text(
          "Tidak dapat memuat data lokasi admin.",
          style: TextStyle(fontSize: 18, color: Colors.red),
        ),
      );
    }

    switch (page) {
      case "pengendara":
        return const PengendaraPage();
      case "laporan":
        return LaporanPage();
      case "lokasi":
        return const LokasiPageAdmin();
      default:
        return _buildDashboardHome();
    }
  }

  // ========================
  // DASHBOARD HOME
  // ========================
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
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Halo Admin 👋",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          if (loading) const Center(child: CircularProgressIndicator()),

          if (!loading)
            Row(
              children: [
                _buildStatCard(
                  "PENGENDARA",
                  pengendaraCount.toString(),
                  Icons.people,
                  Colors.blue,
                ),
                const SizedBox(width: 12),
                _buildStatCardAdmin(
                  "ADMIN",
                  namaLokasi.isNotEmpty ? namaLokasi : "Belum ada lokasi",
                  Icons.location_on,
                  Colors.orange,
                ),
                const SizedBox(width: 12),
                _buildStatCard(
                  "LAPORAN",
                  laporanCount.toString(), 
                  Icons.insert_chart,
                  Colors.red,
                ),
              ],
            ),
        ],
      ),
    );
  }

  // ========================
  // CARD NORMAL (VALUE DI ATAS)
  // ========================
  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Card(
        color: Colors.green[400],
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
          child: Column(
            children: [
              CircleAvatar(
                backgroundColor: const Color(0xFFE0FFC2),
                radius: 28,
                child: Icon(icon, size: 32, color: color),
              ),
              const SizedBox(height: 12),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Text(
                title.toUpperCase(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ========================
  // CARD ADMIN (JUDUL DI ATAS, VALUE DI BAWAH)
  // ========================
  Widget _buildStatCardAdmin(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Card(
        color: Colors.green[400],
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
          child: Column(
            children: [
              CircleAvatar(
                backgroundColor: const Color(0xFFE0FFC2),
                radius: 28,
                child: Icon(icon, size: 32, color: color),
              ),
              const SizedBox(height: 12),
              Text(
                title.toUpperCase(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ========================
  // UI BUILD
  // ========================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: Header(
        title: _selectedPage == "dashboard" ? "Dashboard Admin" : "Menu",
      ),
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
