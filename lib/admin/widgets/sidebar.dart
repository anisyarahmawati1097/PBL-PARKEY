import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  final Function(String) onMenuTap;
  final String currentPage;

  const Sidebar({
    super.key,
    required this.onMenuTap,
    this.currentPage = "dashboard",
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Header dengan warna solid
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            decoration: const BoxDecoration(
              color: Colors.green, // warna solid
            ),
            child: const Center(
              child: Text(
                "Admin Panel",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildMenuItem(Icons.dashboard, "Dashboard", "dashboard"),
                _buildMenuItem(Icons.motorcycle, "Pengendara", "pengendara"),
                _buildMenuItem(Icons.location_on, "Monitoring Parkir", "lokasi"),
                _buildMenuItem(Icons.receipt_long, "Laporan", "laporan"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, String pageKey) {
    final bool isActive = currentPage == pageKey;
    return Material(
      color: isActive ? Colors.green.withOpacity(0.1) : Colors.transparent,
      child: ListTile(
        leading: Icon(
          icon,
          color: isActive ? Colors.green : Colors.black54,
          size: 26,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isActive ? Colors.green : Colors.black87,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            fontSize: 16,
          ),
        ),
        onTap: () => onMenuTap(pageKey),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        hoverColor: Colors.green.withOpacity(0.05),
      ),
    );
  }
}
