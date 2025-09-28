import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  final Function(String) onMenuTap;
  const Sidebar({super.key, required this.onMenuTap});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.green),
            child: Center(
              child: Text(
                "Admin Panel",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text("Dashboard"),
            onTap: () => onMenuTap("dashboard"),
          ),
          ListTile(
            leading: const Icon(Icons.motorcycle),
            title: const Text("Pengendara"),
            onTap: () => onMenuTap("pengendara"),
          ),
          ListTile(
            leading: const Icon(Icons.location_on),
            title: const Text("Lokasi Parkir"),
            onTap: () => onMenuTap("lokasi"),
          ),
          ListTile(
            leading: const Icon(Icons.receipt_long),
            title: const Text("Laporan"),
            onTap: () => onMenuTap("laporan"),
          ),
        ],
      ),
    );
  }
}
