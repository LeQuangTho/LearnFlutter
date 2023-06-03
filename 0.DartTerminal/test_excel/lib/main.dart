import 'dart:io';

import 'package:excel/excel.dart';
import 'package:path/path.dart' as path;

void main() async {
  var currentScriptPath = path.dirname(path.fromUri(Platform.script));
  var assetsPath = path.join(currentScriptPath, 'assets');

  var filePath = path.join(assetsPath, 'test.xlsx');

  File file = File(filePath);

  var data = file.readAsBytesSync();
  var excel = Excel.decodeBytes(data);

  for (var table in excel.tables.keys) {
    print(table); //sheet Name
    print(excel.tables[table]?.maxCols);
    print(excel.tables[table]?.maxRows);
    for (var row in excel.tables[table]!.rows) {
      print('${row.first?.value}');
    }
  }
}
