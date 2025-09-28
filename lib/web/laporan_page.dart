import 'package:flutter/material.dart';

class LaporanPage extends StatelessWidget {
  const LaporanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        Text(
          "Laporan Transaksi Parkir",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        Card(
          child: ListTile(
            leading: Icon(Icons.receipt),
            title: Text("Transaksi #001"),
            subtitle: Text("Grand Batam Mall - Rp 5.000"),
          ),
        ),
        Card(
          child: ListTile(
            leading: Icon(Icons.receipt),
            title: Text("Transaksi #002"),
            subtitle: Text("SNL Food - Rp 10.000"),
          ),
        ),
      ],
    );
  }
}
