import 'package:flutter/material.dart';
import 'data.dart';
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
        return _buildDashboardHome();
    }
  }

  Widget _buildDashboardHome() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header sambutan
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
                  Text(
                    "Halo, Admin 👋",
                    style: TextStyle(fontSize: 18, color: Colors.black54),
                  ),
                  Text(
                    "Selamat Datang di Panel",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Statistik umum
          Row(
            children: [
              _buildStatCard("Pengendara", "120", Icons.people, Colors.blue),
              const SizedBox(width: 12),
              _buildStatCard("Lokasi", "2", Icons.location_on, Colors.orange),
              const SizedBox(width: 12),
              _buildStatCard("Laporan", "30", Icons.insert_chart, Colors.red),
            ],
          ),

          const SizedBox(height: 28),

          // Ringkasan slot parkir
          const Text(
            "Ringkasan Slot Parkir",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          _buildLokasiSummary(
            "Grand Mall",
            total: 12,
            occupied: 4,
          ),
          const SizedBox(height: 12),
          _buildLokasiSummary(
            "SNL Food",
            total: 8,
            occupied: 3,
          ),
        ],
      ),
    );
  }

  // Kartu statistik umum
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

  // Ringkasan slot per lokasi
  Widget _buildLokasiSummary(String nama,
      {required int total, required int occupied}) {
    final kosong = total - occupied;
    final persen = ((occupied / total) * 100).toStringAsFixed(0);

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Nama lokasi
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nama,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text("Total Slot: $total"),
                Text("Terisi: $occupied | Kosong: $kosong"),
              ],
            ),

            // Persentase
            Column(
              children: [
                Text(
                  "$persen%",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: occupied / total > 0.7
                          ? Colors.red
                          : Colors.green[700]),
                ),
                const Text("Terisi"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(
        title: _selectedPage == "dashboard"
            ? "Dashboard Admin"
            : _selectedPage == "pengendara"
                ? "Data Pengendara"
                : _selectedPage == "lokasi"
                    ? "Lokasi Parkir"
                    : "Laporan",
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
