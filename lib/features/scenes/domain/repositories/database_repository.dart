//Repositorio de proyectos

import 'package:directors_cut/core/resources/data_state.dart';
import 'package:directors_cut/features/scenes/domain/entities/scene_entity.dart';
import 'package:directors_cut/features/scenes/domain/entities/project_entity.dart';

abstract class DatabaseRepository {
  //Proyectos
  Future<DataState<List<ProjectEntity>>> getProjects();
  Future<DataState<ProjectEntity>> getProject(String id);
  Future<DataState<void>> createProject(ProjectEntity project);
  Future<DataState<void>> updateProject(ProjectEntity project);
  Future<DataState<void>> deleteProject(ProjectEntity project);

  //Escenas
  Future<DataState<List<SceneEntity>>> getScenes(String projectId);
  Future<DataState<SceneEntity?>> getScene(String id);
  Future<DataState<void>> createScene(SceneEntity scene);
  Future<DataState<void>> updateScene(SceneEntity scene);
  Future<DataState<void>> updateScenes(List<SceneEntity> scenes);
  Future<DataState<void>> deleteScene(SceneEntity scene);

  //Anotaciones de texto
  // Future<List<TextAnnotationEntity>> getAnnotations(String sceneId);
  // Future<TextAnnotationEntity?> getAnnotation(String id);
  // Future<DataState<void>> createAnnotation(
  //     TextAnnotationEntity annotation, String sceneId);
  // Future<DataState<void>> updateAnnotation(TextAnnotationEntity annotation);
  // Future<DataState<void>> deleteAnnotation(TextAnnotationEntity annotation);

  // //Anotaciones de sonido
  // Future<List<SongAnnotationEntity>> getSoundAnnotations(String sceneId);
  // Future<SongAnnotationEntity?> getSoundAnnotation(String id);
  // Future<DataState<void>> createSoundAnnotation(
  //     SongAnnotationEntity annotation, String sceneId);
  // Future<DataState<void>> updateSoundAnnotation(SongAnnotationEntity annotation);
  // Future<DataState<void>> deleteSoundAnnotation(SongAnnotationEntity annotation);
}
