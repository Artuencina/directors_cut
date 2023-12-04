import 'dart:async';

import 'package:directors_cut/features/scenes/data/datasources/local/dao/annotations_dao.dart';
import 'package:directors_cut/features/scenes/data/datasources/local/dao/scenes_dao.dart';
import 'package:directors_cut/features/scenes/domain/entities/annotation_entity.dart';
import 'package:directors_cut/features/scenes/domain/entities/project_entity.dart';
import 'package:directors_cut/features/scenes/domain/entities/scene_entity.dart';
import 'package:floor/floor.dart';
import 'package:directors_cut/features/scenes/data/datasources/local/dao/projects_dao.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'app_database.g.dart';

@Database(version: 3, entities: [
  ProjectEntity,
  SceneEntity,
  AnnotationEntity,
])
abstract class AppDatabase extends FloorDatabase {
  ProjectDao get projectDao;
  SceneDao get sceneDao;
  AnnotationDao get annotationDao;
}
