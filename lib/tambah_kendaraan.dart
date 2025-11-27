import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'bc.dart';

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
  File? foto;

  /// Pick image
  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        foto = File(picked.path);
      });
    }
  }

  /// Simpan kendaraan ke backend
  Future<void> simpanKendaraan() async {
    var url = Uri.parse("http://192.168.115.131:8000/api/kendaraan/store");

    var request = http.MultipartRequest("POST", url);
    request.fields["plat_nomor"] = nomorPlatController.text;
    request.fields["jenis"] = jenisKendaraan ?? "";
    request.fields["merk"] = merk ?? "";
    request.fields["model"] = model ?? "";
    request.fields["warna"] = warna ?? "";
    request.fields["tahun"] = tahun ?? "";
    request.fields["pemilik"] = "User A";

    if (foto != null) {
      request.files.add(await http.MultipartFile.fromPath("foto", foto!.path));
    }

    var response = await request.send();

    if (response.statusCode == 201) {
      var resBody = await response.stream.bytesToString();
      var jsonData = json.decode(resBody);
      var kendaraanBaru = jsonData["data"];

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => QRCodePage(kendaraan: kendaraanBaru),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal menambah kendaraan (${response.statusCode})")),
      );
    }
  }

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
            TextFormField(
              controller: nomorPlatController,
              decoration: _decor("Plat Nomor Kendaraan"),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: _decor("Merk"),
                    items: ["Toyota", "Honda", "Mitsubishi"]
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (val) => setState(() => merk = val),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: _decor("Model"),
                    items: ["Avanza", "Jazz", "Xpander"]
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
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
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (val) => setState(() => tahun = val),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: _decor("Warna"),
                    items: ["Hitam", "Putih", "Merah", "Biru"]
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (val) => setState(() => warna = val),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              "Unggah foto pendukung",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => pickImage(),
              child: Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: foto == null
                      ? const Text(
                          "FOTO KENDARAAN\nSentuh untuk unggah",
                          textAlign: TextAlign.center,
                        )
                      : Image.file(foto!, fit: BoxFit.cover),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF386641),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                onPressed: () {
                  simpanKendaraan();
                },
                child: const Text("Simpan Kendaraan"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJenis(String value, IconData icon) {
    return ChoiceChip(
      avatar: Icon(
        icon,
        size: 20,
        color: jenisKendaraan == value ? Colors.white : Colors.black54,
      ),
      label: Text(value),
      selected: jenisKendaraan == value,
      onSelected: (selected) => setState(() => jenisKendaraan = value),
      selectedColor: const Color(0xFF6A994E),
      labelStyle: TextStyle(
        color: jenisKendaraan == value ? Colors.white : Colors.black,
      ),
    );
  }

  InputDecoration _decor(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      filled: true,
      fillColor: Colors.grey.shade200,
    );
  }
}
