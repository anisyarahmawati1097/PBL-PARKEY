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
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.green,
            ),
            child: Center(
              child: Text(
                "Admin Panel",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
          _buildMenuItem(Icons.dashboard, "Dashboard", "dashboard"),
          _buildMenuItem(Icons.motorcycle, "Pengendara", "pengendara"),
          _buildMenuItem(Icons.location_on, "Lokasi Parkir", "lokasi"),
          _buildMenuItem(Icons.receipt_long, "Laporan", "laporan"),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, String pageKey) {
    final bool isActive = currentPage == pageKey;
    return ListTile(
      leading: Icon(icon, color: isActive ? Colors.green : Colors.black54),
      title: Text(
        title,
        style: TextStyle(
          color: isActive ? Colors.green : Colors.black87,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isActive,
      onTap: () => onMenuTap(pageKey),
    );
  }
}
