import 'package:flutter/material.dart';
import '../service/kendaraan_service.dart';

class DaftarKendaraanPage extends StatefulWidget {
  final int lokasiId;
  final String lokasiNama;

  const DaftarKendaraanPage({
    super.key,
    required this.lokasiId,
    required this.lokasiNama,
  });

  @override
  State<DaftarKendaraanPage> createState() => _DaftarKendaraanPageState();
}

class _DaftarKendaraanPageState extends State<DaftarKendaraanPage> {
  late Future<List<dynamic>> kendaraanFuture;

  @override
  void initState() {
    super.initState();
    _fetchKendaraan();
  }

  void _fetchKendaraan() {
    kendaraanFuture =
        KendaraanService.getKendaraanByLokasi(widget.lokasiId);
  }

  Future<void> _refresh() async {
    _fetchKendaraan();
    await kendaraanFuture;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("Kendaraan Masuk - ${widget.lokasiNama}"),
        backgroundColor: Colors.green,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: kendaraanFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child:
                    CircularProgressIndicator(color: Colors.green));
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Error: ${snapshot.error}",
                      style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _fetchKendaraan,
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: const Text("Coba Lagi"),
                  ),
                ],
              ),
            );
          }

          final kendaraan = snapshot.data ?? [];

          if (kendaraan.isEmpty) {
            return RefreshIndicator(
              onRefresh: _refresh,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 100),
                  Center(
                    child: Text(
                      "Belum ada kendaraan masuk",
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.builder(
              itemCount: kendaraan.length,
              itemBuilder: (_, i) {
                final item = kendaraan[i];
                final k = item["kendaraans"];

                final jenis = k?["jenis"]?.toString().toLowerCase() ?? "motor";

                final icon = jenis == "mobil"
                    ? Icons.directions_car
                    : Icons.directions_bike;

                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 4,
                  shadowColor: Colors.green.withOpacity(0.2),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.green[100],
                      child: Icon(icon, color: Colors.green),
                    ),
                    title: Text(
                      k?["plat_nomor"] ?? "-",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("Masuk: ${item["masuk"] ?? '-'}"),
                    trailing:
                        const Icon(Icons.chevron_right, color: Colors.green),
                    onTap: () {},
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
