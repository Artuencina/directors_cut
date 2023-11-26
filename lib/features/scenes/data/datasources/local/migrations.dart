//Migraciones de la base de datos

import 'package:directors_cut/core/constants/strings.dart';
import 'package:floor/floor.dart';

final migrations = [
  migration1to2,
];

final migration1to2 = Migration(1, 2, (database) async {
  await database
      .execute('ALTER TABLE $scenesTable ADD COLUMN orderId INTEGER; ');
});
