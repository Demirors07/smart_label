import 'package:sqflite/sqflite.dart';

class DatabaseSeeder {
  DatabaseSeeder._();

  static Future<void> seed(Database db) async {
    await db.transaction((txn) async {
      // 1. Create categories.
      final categories = <Map<String, Object?>>[
        {
          'code': 'gluten',
          'category_name': 'Gluten',
          'type': 'ALLERGEN',
          'description': 'Gluten-related food restriction.',
        },
        {
          'code': 'lactose',
          'category_name': 'Lactose',
          'type': 'ALLERGEN',
          'description': 'Lactose-related food restriction.',
        },
        {
          'code': 'nuts',
          'category_name': 'Nuts',
          'type': 'ALLERGEN',
          'description': 'Nuts allergy-related restriction.',
        },
        {
          'code': 'soy',
          'category_name': 'Soy',
          'type': 'ALLERGEN',
          'description': 'Soy allergy-related restriction.',
        },
        {
          'code': 'egg',
          'category_name': 'Egg',
          'type': 'ALLERGEN',
          'description': 'Egg allergy-related restriction.',
        },
        {
          'code': 'vegan',
          'category_name': 'Vegan',
          'type': 'DIET',
          'description': 'Vegan dietary preference.',
        },
        {
          'code': 'vegetarian',
          'category_name': 'Vegetarian',
          'type': 'DIET',
          'description': 'Vegetarian dietary preference.',
        },
      ];

      for (final category in categories) {
        await txn.insert(
          'categories',
          category,
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );
      }

      // 2. Insert example ingredients.
      final ingredients = <Map<String, Object?>>[
        {
          'canonical_name': 'Gelatin',
          'code': 'E441',
          'description':
              'A gelling agent commonly derived from animal sources.',
        },
        {
          'canonical_name': 'Wheat Flour',
          'code': null,
          'description': 'Flour produced from wheat.',
        },
        {
          'canonical_name': 'Milk Powder',
          'code': null,
          'description': 'A dairy ingredient that may contain lactose.',
        },
      ];

      for (final ingredient in ingredients) {
        await txn.insert(
          'ingredients',
          ingredient,
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );
      }

      // 3. Add search terms for each ingredient.
      final searchTerms = <String, List<String>>{
        'Gelatin': ['gelatin', 'gelatine', 'jelatin', 'e441'],
        'Wheat Flour': ['wheat flour', 'wheat', 'buğday unu'],
        'Milk Powder': ['milk powder', 'milk solids', 'süt tozu'],
      };

      for (final entry in searchTerms.entries) {
        final ingredientRows = await txn.query(
          'ingredients',
          columns: ['id'],
          where: 'canonical_name = ?',
          whereArgs: [entry.key],
          limit: 1,
        );

        if (ingredientRows.isEmpty) {
          continue;
        }

        final ingredientId = ingredientRows.first['id'] as int;

        for (final term in entry.value) {
          final normalizedTerm = term.trim().toLowerCase();

          await txn.insert('ingredient_search_terms', {
            'ingredient_id': ingredientId,
            'search_term': term,
            'normalized_term': normalizedTerm,
          }, conflictAlgorithm: ConflictAlgorithm.ignore);
        }
      }

      // 4. Map ingredients to relevant categories.
      final mappings = <String, Map<String, String>>{
        'Gelatin': {'vegan': 'INCOMPATIBLE', 'vegetarian': 'INCOMPATIBLE'},
        'Wheat Flour': {'gluten': 'INCOMPATIBLE'},
        'Milk Powder': {'lactose': 'WARNING'},
      };

      for (final entry in mappings.entries) {
        final ingredientRows = await txn.query(
          'ingredients',
          columns: ['id'],
          where: 'canonical_name = ?',
          whereArgs: [entry.key],
          limit: 1,
        );

        if (ingredientRows.isEmpty) {
          continue;
        }

        final ingredientId = ingredientRows.first['id'] as int;

        for (final mapping in entry.value.entries) {
          final categoryRows = await txn.query(
            'categories',
            columns: ['id'],
            where: 'code = ?',
            whereArgs: [mapping.key],
            limit: 1,
          );

          if (categoryRows.isEmpty) {
            continue;
          }

          final categoryId = categoryRows.first['id'] as int;

          await txn.insert(
            'ingredient_category_mappings',
            {
              'ingredient_id': ingredientId,
              'category_id': categoryId,
              'risk_level': mapping.value,
            },
            conflictAlgorithm: ConflictAlgorithm.ignore,
          );
        }
      }
    });
  }
}
