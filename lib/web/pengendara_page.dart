import 'package:flutter/material.dart';

class DataPengendaraPage extends StatefulWidget {
  DataPengendaraPage({Key? key}) : super(key: key);

  @override
  State<DataPengendaraPage> createState() => _DataPengendaraPageState();
}

class _DataPengendaraPageState extends State<DataPengendaraPage> {
  List<Pengendara> pengendaraList = [
    Pengendara(
      nama: 'Andi Saputra',
      jenisKendaraan: 'Motor',
      merkKendaraan: 'Honda Beat',
      platNomor: 'BP 1234 XY',
    ),
    Pengendara(
      nama: 'Andi Saputra',
      jenisKendaraan: 'Motor',
      merkKendaraan: 'Honda Beat',
      platNomor: 'BP 1234 XY',
    ),
    Pengendara(
      nama: 'Andi Saputra',
      jenisKendaraan: 'Motor',
      merkKendaraan: 'Honda Beat',
      platNomor: 'BP 1234 XY',
    ),
  ];

  void _tambahPengendara() {
    showDialog(
      context: context,
      builder: (context) => PengendaraDialog(
        onSave: (pengendara) {
          setState(() {
            pengendaraList.add(pengendara);
          });
        },
      ),
    );
  }

  void _ubahPengendara(int index) {
    showDialog(
      context: context,
      builder: (context) => PengendaraDialog(
        pengendara: pengendaraList[index],
        onSave: (pengendara) {
          setState(() {
            pengendaraList[index] = pengendara;
          });
        },
      ),
    );
  }

  void _hapusPengendara(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: const Text('Apakah Anda yakin ingin menghapus data ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                pengendaraList.removeAt(index);
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF81D4FA),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.people,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'Data Pengendara',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: _tambahPengendara,
                  icon: const Icon(Icons.add),
                  label: const Text('Tambah Data Pengendara'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF81C784),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Expanded(
              child: ListView.builder(
                itemCount: pengendaraList.length,
                itemBuilder: (context, index) {
                  final pengendara = pengendaraList[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 247, 245, 244),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: const Color(0xFF81D4FA),
                          child: const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                pengendara.nama,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${pengendara.jenisKendaraan} - ${pengendara.merkKendaraan}',
                                style: const TextStyle(fontSize: 14),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                pengendara.platNomor,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => _ubahPengendara(index),
                          icon: const Icon(Icons.edit, size: 18),
                          label: const Text('Ubah'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF7CB342),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          onPressed: () => _hapusPengendara(index),
                          icon: const Icon(Icons.delete, size: 18),
                          label: const Text('Hapus'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF7CB342),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Pengendara {
  String nama;
  String jenisKendaraan;
  String merkKendaraan;
  String platNomor;

  Pengendara({
    required this.nama,
    required this.jenisKendaraan,
    required this.merkKendaraan,
    required this.platNomor,
  });
}

class PengendaraDialog extends StatefulWidget {
  final Pengendara? pengendara;
  final Function(Pengendara) onSave;

  const PengendaraDialog({
    Key? key,
    this.pengendara,
    required this.onSave,
  }) : super(key: key);

  @override
  State<PengendaraDialog> createState() => _PengendaraDialogState();
}

class _PengendaraDialogState extends State<PengendaraDialog> {
  late TextEditingController _namaController;
  late TextEditingController _jenisController;
  late TextEditingController _merkController;
  late TextEditingController _platController;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.pengendara?.nama ?? '');
    _jenisController = TextEditingController(text: widget.pengendara?.jenisKendaraan ?? '');
    _merkController = TextEditingController(text: widget.pengendara?.merkKendaraan ?? '');
    _platController = TextEditingController(text: widget.pengendara?.platNomor ?? '');
  }

  @override
  void dispose() {
    _namaController.dispose();
    _jenisController.dispose();
    _merkController.dispose();
    _platController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.pengendara == null ? 'Tambah Pengendara' : 'Ubah Pengendara'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _namaController,
              decoration: const InputDecoration(
                labelText: 'Nama',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _jenisController,
              decoration: const InputDecoration(
                labelText: 'Jenis Kendaraan',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _merkController,
              decoration: const InputDecoration(
                labelText: 'Merk Kendaraan',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _platController,
              decoration: const InputDecoration(
                labelText: 'Plat Nomor',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_namaController.text.isNotEmpty &&
                _jenisController.text.isNotEmpty &&
                _merkController.text.isNotEmpty &&
                _platController.text.isNotEmpty) {
              widget.onSave(
                Pengendara(
                  nama: _namaController.text,
                  jenisKendaraan: _jenisController.text,
                  merkKendaraan: _merkController.text,
                  platNomor: _platController.text,
                ),
              );
              Navigator.pop(context);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF7CB342),
          ),
          child: const Text('Simpan'),
        ),
      ],
    );
  }
}