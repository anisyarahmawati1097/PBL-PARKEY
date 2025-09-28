import 'package:flutter/material.dart';

class LokasiPageAdmin extends StatelessWidget {
  const LokasiPageAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // 2 lokasi: Grand Mall & SNL Food
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: const Text("Slot Parkir"),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Grand Mall"),
              Tab(text: "SNL Food"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            SlotParkirView(
              lokasi: "Grand Mall",
              totalSlot: 20,
              occupied: [1, 2, 7, 10], // slot terisi
            ),
            SlotParkirView(
              lokasi: "SNL Food",
              totalSlot: 15,
              occupied: [3, 5, 9], // slot terisi
            ),
          ],
        ),
      ),
    );
  }
}

class SlotParkirView extends StatelessWidget {
  final String lokasi;
  final int totalSlot;
  final List<int> occupied;

  const SlotParkirView({
    super.key,
    required this.lokasi,
    required this.totalSlot,
    required this.occupied,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 80, // 🔥 ukuran maksimal slot
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1, // biar kotak (persegi)
      ),
      itemCount: totalSlot,
      itemBuilder: (context, index) {
        final slotNumber = index + 1;
        final isOccupied = occupied.contains(slotNumber);

        return Container(
          decoration: BoxDecoration(
            color: isOccupied ? Colors.red[400] : Colors.green[400],
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 3,
                offset: Offset(2, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              "S$slotNumber",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
        );
      },
    );
  }
}
