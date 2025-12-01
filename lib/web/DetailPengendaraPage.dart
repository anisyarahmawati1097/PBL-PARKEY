import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DetailPengendaraPage extends StatefulWidget {
  final int userId;
  final String namaPengendara;

  const DetailPengendaraPage({
    super.key,
    required this.userId,
    required this.namaPengendara,
  });

  @override
  State<DetailPengendaraPage> createState() => _DetailPengendaraPageState();
}

class _DetailPengendaraPageState extends State<DetailPengendaraPage> {
  List kendaraanList = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchKendaraan();
  }

  Future fetchKendaraan() async {
    try {
      final res = await http.get(
        Uri.parse("http://192.168.58.134:8000/api/pengendara/${widget.userId}/kendaraan"),
      );

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);

        setState(() {
          if (body is List) {
            kendaraanList = body;
          } else if (body is Map && body['data'] is List) {
            kendaraanList = body['data'];
          } else {
            kendaraanList = [];
          }
          loading = false;
        });
      } else {
        setState(() => loading = false);
      }
    } catch (e) {
      debugPrint("Error fetch kendaraan: $e");
      setState(() => loading = false);
    }
  }

  IconData getJenisIcon(String jenis) {
    switch (jenis.toLowerCase()) {
      case 'motor':
        return Icons.motorcycle;
      case 'mobil':
        return Icons.directions_car;
      default:
        return Icons.help_outline;
    }
  }

  Widget _buildKendaraanCard(Map item) {
    final jenis = item['jenis']?.toString() ?? '-';
    final merk = item['merk']?.toString() ?? '-';
    final plat = item['plat_nomor']?.toString() ?? '-';
    final model = item['model']?.toString() ?? '-';
    final warna = item['warna']?.toString() ?? '-';
    final tahun = item['tahun']?.toString() ?? '-';

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.green[100],
              child: Icon(getJenisIcon(jenis), size: 28, color: Colors.green),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("$jenis - $merk",
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text("Plat Nomor : $plat"),
                  Text("Model      : $model"),
                  Text("Warna      : $warna"),
                  Text("Tahun      : $tahun"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Detail Pengendara",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.person, size: 26, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  "Pengendara",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Text(
              widget.namaPengendara,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 20),
            const Text(
              "Daftar Kendaraan",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 10),

            if (loading) const Center(child: CircularProgressIndicator()),

            if (!loading && kendaraanList.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 40),
                child: Center(child: Text("Tidak ada kendaraan", style: TextStyle(fontSize: 16))),
              ),

            for (var item in kendaraanList) _buildKendaraanCard(item),
          ],
        ),
      ),
    );
  }
}
