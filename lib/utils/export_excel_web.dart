import 'dart:html' as html;

void exportExcelImpl(List<int> bytes) {
  final blob = html.Blob(
    [bytes],
    'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
  );

  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.AnchorElement(href: url)
    ..setAttribute("download", "laporan_harian.xlsx")
    ..click();

  html.Url.revokeObjectUrl(url);
}
