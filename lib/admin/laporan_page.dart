import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LaporanPage extends StatefulWidget {
  const LaporanPage({super.key});

  @override
  State<LaporanPage> createState() => _LaporanPageState();
}

class _LaporanPageState extends State<LaporanPage> {
  late Future<List<Map<String, dynamic>>> laporanFuture;

  @override
  void initState() {
    super.initState();
    laporanFuture = fetchLaporan();
  }

  Future<List<Map<String, dynamic>>> fetchLaporan() async {
    final prefs = await SharedPreferences.getInstance();
    final lokasiId = prefs.getInt("lokasi_id") ?? 0;

    final url =
        'http://192.168.156.134:8000/api/laporan/harian-lokasi?lokasi_id=$lokasiId';
    print("Fetching laporan: $url");

    final response = await http.get(Uri.parse(url));

    print("Status code: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => e as Map<String, dynamic>).toList();
    } else {
      throw Exception('Gagal mengambil data laporan');
    }
  }

  Widget _buildLaporanKunjungan({
    required String lokasi,
    required String tanggal,
    required int totalKunjungan,
  }) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        leading: const Icon(Icons.location_on, color: Colors.green, size: 34),
        title: Text(
          'Lokasi: $lokasi',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(
          "$tanggal\nTotal Kunjungan: $totalKunjungan",
          style: const TextStyle(fontSize: 15),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Laporan Harian")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: laporanFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Belum ada laporan'));
            } else {
              final laporan = snapshot.data!;
              return ListView(
                children: laporan.map((item) {
                  return _buildLaporanKunjungan(
                    lokasi: item['lokasi'],
                    tanggal: item['tanggal'],
                    totalKunjungan: item['total'],
                  );
                }).toList(),
              );
            }
          },
        ),
      ),
    );
  }
}
