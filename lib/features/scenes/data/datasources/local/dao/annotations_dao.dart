import 'package:directors_cut/features/scenes/domain/entities/annotation_entity.dart';
import 'package:floor/floor.dart';
import 'package:directors_cut/core/constants/strings.dart';

@dao
abstract class AnnotationDao {
  @Query('SELECT * FROM $annotationsTable where sceneId = :sceneId')
  Future<List<AnnotationEntity>> getAnnotations(int sceneId);

  @Query('SELECT * FROM $annotationsTable WHERE id = :id')
  Future<AnnotationEntity?> getAnnotation(int id);

  @insert
  Future<void> createAnnotation(AnnotationEntity annotation);

  @update
  Future<void> updateAnnotation(AnnotationEntity annotation);

  @update
  Future<void> updateAnnotations(List<AnnotationEntity> annotations);

  @delete
  Future<void> deleteAnnotation(AnnotationEntity annotation);

  @Query('DELETE FROM $annotationsTable WHERE sceneId = :sceneId')
  Future<void> deleteAllAnnotations(int sceneId);
}
