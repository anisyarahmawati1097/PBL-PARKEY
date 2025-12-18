import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'dart:html' as html;

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
        'http://172.20.10.3:8000/api/laporan/harian-lokasi?lokasi_id=$lokasiId';
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

  // ============================
  // FUNGSI EXPORT FIX → DATA MASUK
  // ============================
  Future<void> exportToExcel(List<Map<String, dynamic>> laporan) async {
    print("DEBUG laporan: $laporan");

    if (laporan.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tidak ada data untuk diexport")),
      );
      return;
    }

    // Buat Excel baru
    final excel = Excel.createExcel();

    // Ambil sheet default
    final String sheetName = excel.getDefaultSheet() ?? "Sheet1";
    final Sheet sheet = excel[sheetName];

    // Header
    sheet.appendRow(["Lokasi", "Tanggal", "Total Kunjungan"]);

    // Isi data
    for (var item in laporan) {
      sheet.appendRow([
        item['lokasi'] ?? "",
        item['tanggal'] ?? "",
        item['total'] ?? 0,
      ]);
    }

    final fileBytes = excel.encode();
    if (fileBytes == null) {
      print("ERROR: Excel.encode() menghasilkan null!");
      return;
    }

    // ===== WEB DOWNLOAD =====
    if (kIsWeb) {
      final blob = html.Blob(
          [fileBytes],
          'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
      );

      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute("download", "laporan_harian.xlsx")
        ..click();

      html.Url.revokeObjectUrl(url);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Export Excel berhasil (WEB)")),
      );
      return;
    }

    // ===== MOBILE / DESKTOP SAVE FILE =====
    final dir = await getApplicationDocumentsDirectory();
    final path = "${dir.path}/laporan_harian.xlsx";

    File(path)
      ..createSync(recursive: true)
      ..writeAsBytesSync(fileBytes);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Export berhasil disimpan: $path")),
    );
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
