import 'package:flutter/material.dart';
import 'beranda.dart'; // pastikan path sesuai

class AktivitasPage extends StatelessWidget {
  const AktivitasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF6A994E),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const BerandaPage(), // username opsional
                ),
              );
            },
          ),
          title: const Text(
            "Aktivitas",
            style: TextStyle(color: Colors.white),
          ),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(text: "Aktivitas"),
              Tab(text: "Riwayat"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _EmptyState(
              icon: Icons.calendar_today,
              text: "Belum ada aktivitas transaksi",
            ),
            _EmptyState(
              icon: Icons.history,
              text: "Belum ada riwayat transaksi",
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String text;

  const _EmptyState({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: Colors.grey),
          const SizedBox(height: 10),
          Text(
            text,
            style: const TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
