//Repositorio local utilizando floor
//Para manejar los proyectos y escenas se utilizara floor
import 'package:directors_cut/core/resources/data_state.dart';
import 'package:directors_cut/features/scenes/data/datasources/local/app_database.dart';
import 'package:directors_cut/features/scenes/domain/entities/annotation_entity.dart';
import 'package:directors_cut/features/scenes/domain/entities/project_entity.dart';
import 'package:directors_cut/features/scenes/domain/entities/scene_entity.dart';
import 'package:directors_cut/features/scenes/domain/repositories/database_repository.dart';

class DatabaseRepositoryImpl implements DatabaseRepository {
  final AppDatabase _database;

  DatabaseRepositoryImpl(this._database);

  @override
  Future<DataState<void>> createProject(ProjectEntity project) async {
    try {
      await _database.projectDao.createProject(project);
      return const DataSuccess<void>(null);
    } catch (e) {
      return DataFailed<void>(e as Exception);
    }
  }

  @override
  Future<DataState<void>> deleteProject(ProjectEntity project) async {
    try {
      await _database.projectDao.deleteProject(project);
      return const DataSuccess<void>(null);
    } catch (e) {
      return DataFailed<void>(e as Exception);
    }
  }

  @override
  Future<DataState<ProjectEntity>> getProject(String id) async {
    try {
      final project = await _database.projectDao.getProject(id);
      return DataSuccess<ProjectEntity>(project!);
    } catch (e) {
      return DataFailed<ProjectEntity>(e as Exception);
    }
  }

  @override
  Future<DataState<List<ProjectEntity>>> getProjects() async {
    try {
      final projects = await _database.projectDao.getProjects();
      return DataSuccess<List<ProjectEntity>>(projects);
    } catch (e) {
      return DataFailed<List<ProjectEntity>>(e as Exception);
    }
  }

  @override
  Future<DataState<void>> updateProject(ProjectEntity project) async {
    try {
      await _database.projectDao.updateProject(project);
      return const DataSuccess<void>(null);
    } catch (e) {
      return DataFailed<void>(e as Exception);
    }
  }

  @override
  Future<DataState<void>> createScene(SceneEntity scene) async {
    try {
      await _database.sceneDao.createScene(scene);
      return const DataSuccess<void>(null);
    } catch (e) {
      return DataFailed<void>(e as Exception);
    }
  }

  @override
  Future<DataState<void>> deleteScene(SceneEntity scene) async {
    try {
      await _database.sceneDao.deleteScene(scene);
      return const DataSuccess<void>(null);
    } catch (e) {
      return DataFailed<void>(e as Exception);
    }
  }

  @override
  Future<DataState<SceneEntity?>> getScene(String id) async {
    try {
      final scene = await _database.sceneDao.getScene(id);
      return DataSuccess<SceneEntity?>(scene);
    } catch (e) {
      return DataFailed(e as Exception);
    }
  }

  @override
  Future<DataState<List<SceneEntity>>> getScenes(String projectId) async {
    try {
      final scenes = await _database.sceneDao.getScenes(projectId);

      //Ordenar por orderId
      scenes.sort((a, b) => a.orderId.compareTo(b.orderId));
      return DataSuccess<List<SceneEntity>>(scenes);
    } catch (e) {
      return DataFailed(e as Exception);
    }
  }

  @override
  Future<DataState<void>> updateScene(SceneEntity scene) async {
    try {
      await _database.sceneDao.updateScene(scene);
      return const DataSuccess<void>(null);
    } catch (e) {
      return DataFailed<void>(e as Exception);
    }
  }

  @override
  Future<DataState<void>> updateScenes(List<SceneEntity> scenes) async {
    try {
      await _database.sceneDao.updateScenes(scenes);
      return const DataSuccess<void>(null);
    } catch (e) {
      return DataFailed<void>(e as Exception);
    }
  }

  //Annotation
  @override
  Future<DataState<void>> createAnnotation(AnnotationEntity annotation) async {
    try {
      await _database.annotationDao.createAnnotation(annotation);
      return const DataSuccess<void>(null);
    } catch (e) {
      return DataFailed<void>(e as Exception);
    }
  }

  @override
  Future<DataState<void>> deleteAnnotation(AnnotationEntity annotation) async {
    try {
      await _database.annotationDao.deleteAnnotation(annotation);
      return const DataSuccess<void>(null);
    } catch (e) {
      return DataFailed<void>(e as Exception);
    }
  }

  @override
  Future<DataState<void>> deleteAllAnnotations(int sceneId) async {
    try {
      await _database.annotationDao.deleteAllAnnotations(sceneId);
      return const DataSuccess<void>(null);
    } catch (e) {
      return DataFailed<void>(e as Exception);
    }
  }

  @override
  Future<DataState<AnnotationEntity?>> getAnnotation(int id) async {
    try {
      final annotation = await _database.annotationDao.getAnnotation(id);
      return DataSuccess<AnnotationEntity?>(annotation);
    } catch (e) {
      return DataFailed(e as Exception);
    }
  }

  @override
  Future<DataState<List<AnnotationEntity>>> getAnnotations(int sceneId) async {
    try {
      final annotations = await _database.annotationDao.getAnnotations(sceneId);

      //Ordenar por orderId
      annotations.sort((a, b) => a.orderId!.compareTo(b.orderId!));
      return DataSuccess<List<AnnotationEntity>>(annotations);
    } catch (e) {
      return DataFailed(e as Exception);
    }
  }

  @override
  Future<DataState<void>> updateAnnotation(AnnotationEntity annotation) async {
    try {
      await _database.annotationDao.updateAnnotation(annotation);
      return const DataSuccess<void>(null);
    } catch (e) {
      return DataFailed<void>(e as Exception);
    }
  }

  @override
  Future<DataState<void>> updateAnnotations(
      List<AnnotationEntity> annotations) async {
    try {
      await _database.annotationDao.updateAnnotations(annotations);
      return const DataSuccess<void>(null);
    } catch (e) {
      return DataFailed<void>(e as Exception);
    }
  }
}
