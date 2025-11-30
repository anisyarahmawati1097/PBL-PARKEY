import 'dart:async';
import 'package:flutter/material.dart';
import 'riwayat.dart'; // <- import halaman RiwayatPage

class AktivitasPage extends StatefulWidget {
  const AktivitasPage({super.key});

  @override
  State<AktivitasPage> createState() => _AktivitasPageState();
}

class _AktivitasPageState extends State<AktivitasPage> {
  List<Map<String, dynamic>> aktivitasBerlangsung = [
    {
      "lokasi": "Grand Batam Mall",
      "merek": "Honda Vario 125",
      "plat": "BP 1234 AB",
      "jamMasuk": DateTime.now().subtract(const Duration(minutes: 42)),
      "tarifFirstHour": 3000,
      "tarifNextHour": 2000,
    },
  ];

  List<Map<String, dynamic>> riwayat = [];
  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  String formatDuration(Duration d) {
    String h = d.inHours.toString().padLeft(2, '0');
    String m = (d.inMinutes % 60).toString().padLeft(2, '0');
    String s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return "$h:$m:$s";
  }

  String formatJam(DateTime dt) {
    return "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')} WIB";
  }

  int hitungBiaya(Duration durasi, int tarifFirst, int tarifNext) {
    final hours = (durasi.inMinutes / 60).ceil();
    return (hours <= 1) ? tarifFirst : tarifFirst + ((hours - 1) * tarifNext);
  }

  void akhiriParkir(int index) {
    final data = aktivitasBerlangsung[index];
    final jamMasuk = data["jamMasuk"];
    final durasi = DateTime.now().difference(jamMasuk);
    final biaya = hitungBiaya(
        durasi, data["tarifFirstHour"], data["tarifNextHour"]);

    setState(() {
      aktivitasBerlangsung.removeAt(index);
      riwayat.add({
        "lokasi": data["lokasi"],
        "merek": data["merek"],
        "plat": data["plat"],
        "jamMasuk": formatJam(jamMasuk),
        "jamKeluar": formatJam(DateTime.now()),
        "durasi": formatDuration(durasi),
        "total": biaya,
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0FFC2),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6A994E),
        title: const Text("Aktivitas", style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => RiwayatPage(riwayat: riwayat),
                ),
              );
            },
          )
        ],
      ),
      body: aktivitasBerlangsung.isEmpty
          ? const Center(
              child: Text("Belum ada aktivitas parkir", style: TextStyle(fontSize: 16)),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: aktivitasBerlangsung.length,
              itemBuilder: (context, index) {
                final data = aktivitasBerlangsung[index];
                final jamMasuk = data["jamMasuk"];
                final durasi = DateTime.now().difference(jamMasuk);
                final biaya = hitungBiaya(
                    durasi, data["tarifFirstHour"], data["tarifNextHour"]);

                return AktifCard(
                  lokasi: data["lokasi"],
                  merek: data["merek"],
                  plat: data["plat"],
                  jamMasuk: jamMasuk,
                  durasi: formatDuration(durasi),
                  biaya: biaya,
                  onAkhiri: () => akhiriParkir(index),
                );
              },
            ),
    );
  }
}

class AktifCard extends StatelessWidget {
  final String lokasi;
  final String merek;
  final String plat;
  final DateTime jamMasuk;
  final String durasi;
  final int biaya;
  final VoidCallback onAkhiri;

  const AktifCard({
    super.key,
    required this.lokasi,
    required this.merek,
    required this.plat,
    required this.jamMasuk,
    required this.durasi,
    required this.biaya,
    required this.onAkhiri,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFF8F4FF),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Aktivitas Sedang Berlangsung", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.green),
                const SizedBox(width: 8),
                Expanded(child: Text(lokasi, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600))),
              ],
            ),
            const SizedBox(height: 6),
            Text("$merek - $plat", style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 6),
            Text("Masuk: ${jamMasuk.hour.toString().padLeft(2,'0')}:${jamMasuk.minute.toString().padLeft(2,'0')} WIB"),
            Text("Durasi: $durasi"),
            Text("Biaya: Rp $biaya", style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 18),
            Center(
              child: ElevatedButton.icon(
                onPressed: onAkhiri,
                icon: const Icon(Icons.exit_to_app),
                label: const Text("Akhiri Parkir"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6A994E),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
