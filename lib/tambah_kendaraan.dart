import 'package:flutter/material.dart';

class TambahKendaraanPage extends StatefulWidget {
  const TambahKendaraanPage({super.key});

  @override
  State<TambahKendaraanPage> createState() => _TambahKendaraanPageState();
}

class _TambahKendaraanPageState extends State<TambahKendaraanPage> {
  String? jenisKendaraan = "Mobil";
  String? merk;
  String? model;
  String? warna;
  String? tahun;
  final nomorPlatController = TextEditingController();
  final nomorMesinController = TextEditingController();
  final nomorRangkaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Kendaraan"),
        backgroundColor: const Color(0xFF6A994E),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// PILIH KENDARAAN
            const Text(
              "Pilih Kendaraan",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 16,
              children: [
                _buildJenis("Mobil", Icons.directions_car),
                _buildJenis("Motor", Icons.two_wheeler),
                _buildJenis("Truk", Icons.local_shipping),
                _buildJenis("Pickup", Icons.fire_truck),
              ],
            ),
            const SizedBox(height: 20),

            /// INPUTAN DATA KENDARAAN
            DropdownButtonFormField<String>(
              decoration: _decor("Plat No. Kendaraan"),
              items: ["B 1234 CD", "D 4567 EF", "L 7890 GH"]
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) {},
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: _decor("Merk"),
                    items: ["Toyota", "Honda", "Mitsubishi"]
                        .map((e) =>
                            DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (val) => setState(() => merk = val),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: _decor("Model"),
                    items: ["Avanza", "Jazz", "Xpander"]
                        .map((e) =>
                            DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (val) => setState(() => model = val),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: _decor("Tahun Pembuatan"),
                    items: ["2018", "2019", "2020", "2021", "2022"]
                        .map((e) =>
                            DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (val) => setState(() => tahun = val),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: _decor("Warna"),
                    items: ["Hitam", "Putih", "Merah", "Biru"]
                        .map((e) =>
                            DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (val) => setState(() => warna = val),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            /// UPLOAD DOKUMEN
            const Text(
              "Unggah foto pendukung",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content:
                        Text("Upload foto kendaraan belum diimplementasi"),
                  ),
                );
              },
              child: Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text(
                    "FOTO KENDARAAN\nSentuh untuk unggah",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            /// SIMPAN
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF386641),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Kendaraan berhasil ditambahkan"),
                    ),
                  );
                  Navigator.pop(context);
                },
                child: const Text("Simpan Kendaraan"),
              ),
            )
          ],
        ),
      ),
    );
  }

  /// Widget pilihan jenis dengan icon
  Widget _buildJenis(String value, IconData icon) {
    return ChoiceChip(
      avatar: Icon(
        icon,
        size: 20,
        color: jenisKendaraan == value ? Colors.white : Colors.black54,
      ),
      label: Text(value),
      selected: jenisKendaraan == value,
      onSelected: (selected) {
        setState(() {
          jenisKendaraan = value;
        });
      },
      selectedColor: const Color(0xFF6A994E),
      labelStyle: TextStyle(
        color: jenisKendaraan == value ? Colors.white : Colors.black,
      ),
    );
  }

  /// Dekorasi field biar seragam
  InputDecoration _decor(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      filled: true,
      fillColor: Colors.grey.shade200,
    );
  }
}
