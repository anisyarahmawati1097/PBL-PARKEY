import 'dart:convert';
import 'package:flutter/foundation.dart'; // ⬅️ WAJIB UNTUK kIsWeb
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:excel/excel.dart';

import '../utils/export_excel.dart';

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

  // ============================
  // FETCH DATA LAPORAN (WEB & ANDROID AMAN)
  // ============================
  Future<List<Map<String, dynamic>>> fetchLaporan() async {
    final prefs = await SharedPreferences.getInstance();
    final lokasiId = prefs.getInt("lokasi_id") ?? 0;

    // 🔥 KUNCI UTAMA ADA DI SINI
    final String baseUrl = kIsWeb
        ? 'https://dottie-proaudience-harmonistically.ngrok-free.dev'
        : 'http://151.243.222.93:31020';

    final url =
        '$baseUrl/api/laporan/harian-lokasi?lokasi_id=$lokasiId';

    debugPrint("🔗 FETCH LAPORAN: $url");

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Accept': 'application/json',
        if (kIsWeb) 'ngrok-skip-browser-warning': 'true',
      },
    );

    debugPrint("STATUS: ${response.statusCode}");
    debugPrint("BODY: ${response.body}");

    if (response.statusCode == 200 &&
        response.headers['content-type']?.contains('application/json') == true) {
      final List data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data);
    }

    throw Exception('Gagal memuat laporan');
  }

  // ============================
  // EXPORT EXCEL
  // ============================
  Future<void> exportToExcel(List<Map<String, dynamic>> laporan) async {
    if (laporan.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tidak ada data untuk diexport")),
      );
      return;
    }

    final excel = Excel.createExcel();
    final sheet = excel[excel.getDefaultSheet()!];

    sheet.appendRow(["Lokasi", "Tanggal", "Total Kunjungan"]);

    for (var item in laporan) {
      sheet.appendRow([
        item['lokasi'] ?? '',
        item['tanggal'] ?? '',
        item['total'] ?? 0,
      ]);
    }

    final fileBytes = excel.encode();
    if (fileBytes != null) {
      exportExcel(fileBytes);
    }
  }

  // ============================
  // UI
  // ============================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Laporan Harian"),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () async {
              final data = await laporanFuture;
              exportToExcel(data);
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: laporanFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }

            final data = snapshot.data ?? [];

            if (data.isEmpty) {
              return const Center(child: Text("Belum ada laporan"));
            }

            return ListView(
              children: data.map((item) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: const Icon(Icons.location_on, color: Colors.green),
                    title: Text("Lokasi: ${item['lokasi']}"),
                    subtitle: Text(
                      "${item['tanggal']}\nTotal: ${item['total']}",
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
