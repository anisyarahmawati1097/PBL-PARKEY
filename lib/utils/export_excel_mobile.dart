import 'dart:io';

void exportExcelImpl(List<int> bytes) async {
  final file = File('/storage/emulated/0/Download/laporan_harian.xlsx');
  await file.writeAsBytes(bytes);
}
