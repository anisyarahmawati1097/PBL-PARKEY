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
  int lokasiCount = 0; // kendaraan
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
    final prefs = await SharedPreferences.getInstance();

    lokasiId = prefs.getInt("lokasi_id");
    namaLokasi = prefs.getString("nama_lokasi") ?? "";

    setState(() => loadingAdmin = false);

    if (lokasiId != null) {
      fetchStats();
      fetchLaporanCount(); // ✅ KUNCI LAPORAN
    }
  }

  // ========================
  // FETCH STATS (PENGENDARA & KENDARAAN)
  // ========================
  Future<void> fetchStats() async {
    if (lokasiId == null) return;

    try {
      final res = await http.get(
        Uri.parse(
          "https://dottie-proaudience-harmonistically.ngrok-free.dev/api/dashboard/stats?lokasi_id=$lokasiId",
        ),
        headers: {
          'Accept': 'application/json',
          'ngrok-skip-browser-warning': 'true',
        },
      );

      debugPrint("STATUS STATS: ${res.statusCode}");
      debugPrint("BODY STATS: ${res.body}");

      if (res.statusCode == 200) {
        final json = jsonDecode(res.body);

        setState(() {
          pengendaraCount = json['pengendara'] ?? 0;
          lokasiCount     = json['kendaraan'] ?? 0;
          loading = false;
        });
      } else {
        loading = false;
      }
    } catch (e) {
      debugPrint("Error fetch stats: $e");
      loading = false;
    }
  }

  // ========================
  // FETCH LAPORAN COUNT (REAL DATA)
  // ========================
  Future<void> fetchLaporanCount() async {
  if (lokasiId == null) return;

  try {
    final uri = Uri.parse(
      "http://151.243.222.93:31020/api/laporan/harian-lokasi?lokasi_id=$lokasiId",
    );

    final res = await http.get(
      uri,
      headers: {'Accept': 'application/json'},
    );

    debugPrint("STATUS LAPORAN: ${res.statusCode}");
    debugPrint("BODY LAPORAN: ${res.body}");

    if (res.statusCode == 200) {
      final decoded = jsonDecode(res.body);

      if (decoded is List) {
        setState(() {
          laporanCount = decoded.length; // ✅ AMAN
        });
      } else {
        setState(() {
          laporanCount = 0;
        });
      }
    } else {
      setState(() {
        laporanCount = 0;
      });
    }
  } catch (e) {
    debugPrint("❌ Error fetch laporan: $e");
    setState(() {
      laporanCount = 0;
    });
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
        return const LaporanPage();
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
              const Text(
                "Halo Admin 👋",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
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
  // CARD NORMAL
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
              ),
              const SizedBox(height: 6),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ========================
  // CARD ADMIN
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
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
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
