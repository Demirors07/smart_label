import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:smart_label/data/datasources/local_database.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    sqflite.databaseFactory = databaseFactoryFfi;
  });

  group('LocalDatabase', () {
    test('database schema should contain the required tables', () async {
      final db = await LocalDatabase.instance.database;

      final result = await db.rawQuery(
        "SELECT name FROM sqlite_master "
        "WHERE type = 'table' AND name NOT LIKE 'sqlite_%' "
        'ORDER BY name',
      );

      final tableNames = result.map((row) => row['name'] as String).toSet();

      expect(
        tableNames,
        containsAll({
          'ingredients',
          'ingredient_search_terms',
          'categories',
          'ingredient_category_mappings',
          'user_preferences',
        }),
      );

      await db.close();
    });
  });
}
