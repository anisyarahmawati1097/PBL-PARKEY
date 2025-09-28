import 'package:flutter/material.dart';

class LokasiPageAdmin extends StatelessWidget {
  const LokasiPageAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          "Kelola Lokasi Parkir",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Card(
          child: ListTile(
            leading: const Icon(Icons.location_on),
            title: const Text("Grand Batam Mall"),
            subtitle: const Text("Jl. Pembangunan, Kota Batam"),
            trailing: IconButton(
              icon: const Icon(Icons.edit, color: Colors.green),
              onPressed: () {},
            ),
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.location_on),
            title: const Text("SNL Food Tanjung Uma"),
            subtitle: const Text("Jl. Tanjung Uma, Kota Batam"),
            trailing: IconButton(
              icon: const Icon(Icons.edit, color: Colors.green),
              onPressed: () {},
            ),
          ),
        ),
      ],
    );
  }
}
