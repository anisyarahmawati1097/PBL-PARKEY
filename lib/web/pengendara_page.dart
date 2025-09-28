import 'package:flutter/material.dart';

class PengendaraPage extends StatelessWidget {
  const PengendaraPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        Text(
          "Daftar Pengendara",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        Card(
          child: ListTile(
            leading: Icon(Icons.motorcycle),
            title: Text("Pengendara 1"),
            subtitle: Text("pengendara1@email.com"),
          ),
        ),
        Card(
          child: ListTile(
            leading: Icon(Icons.motorcycle),
            title: Text("Pengendara 2"),
            subtitle: Text("pengendara2@email.com"),
          ),
        ),
      ],
    );
  }
}
