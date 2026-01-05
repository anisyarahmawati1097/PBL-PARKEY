import 'package:flutter/foundation.dart';

// WEB
import 'export_excel_web.dart'
    if (dart.library.io) 'export_excel_mobile.dart';

void exportExcel(List<int> bytes) {
  exportExcelImpl(bytes);
}
