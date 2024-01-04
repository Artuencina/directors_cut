//Repositorio de proyectos

import 'package:directors_cut/core/resources/data_state.dart';
import 'package:directors_cut/features/scenes/domain/entities/annotation_entity.dart';
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

  //Anotaciones
  Future<DataState<List<AnnotationEntity>>> getAnnotations(int sceneId);
  Future<DataState<AnnotationEntity?>> getAnnotation(int id);
  Future<DataState<void>> createAnnotation(AnnotationEntity annotation);
  Future<DataState<void>> updateAnnotation(AnnotationEntity annotation);
  Future<DataState<void>> updateAnnotations(List<AnnotationEntity> annotations);
  Future<DataState<void>> deleteAnnotation(AnnotationEntity annotation);
  Future<DataState<void>> deleteAllAnnotations(int sceneId);
}
