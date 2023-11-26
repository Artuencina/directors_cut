import 'package:directors_cut/core/constants/strings.dart';
import 'package:directors_cut/features/scenes/domain/entities/scene_entity.dart';
import 'package:floor/floor.dart';

@dao
abstract class SceneDao {
  @Query('SELECT * FROM $scenesTable WHERE projectId = :projectId')
  Future<List<SceneEntity>> getScenes(String projectId);

  @Query('SELECT * FROM $scenesTable WHERE id = :id')
  Future<SceneEntity?> getScene(String id);

  @insert
  Future<void> createScene(SceneEntity scene);

  @update
  Future<void> updateScene(SceneEntity scene);

  @delete
  Future<void> deleteScene(SceneEntity scene);

  @update
  Future<void> updateScenes(List<SceneEntity> scenes);
}
