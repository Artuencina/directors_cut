//Repositorio local utilizando floor
//Para manejar los proyectos y escenas se utilizara floor
import 'package:directors_cut/core/resources/data_state.dart';
import 'package:directors_cut/features/scenes/data/datasources/local/app_database.dart';
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

  // @override
  // Future<void> createAnnotation(
  //     TextAnnotationEntity annotation, String sceneId) async {
  //   await _database.annotationDao.createAnnotation(annotation, sceneId);
  // }

  // @override
  // Future<void> deleteAnnotation(TextAnnotationEntity annotation) async {
  //   await _database.annotationDao.deleteAnnotation(annotation);
  // }

  // @override
  // Future<TextAnnotationEntity?> getAnnotation(String id) async {
  //   return await _database.annotationDao.getAnnotation(id);
  // }

  // @override
  // Future<List<TextAnnotationEntity>> getAnnotations(String sceneId) async {
  //   return await _database.annotationDao.getAnnotations(sceneId);
  // }

  // @override
  // Future<void> updateAnnotation(TextAnnotationEntity annotation) async {
  //   await _database.annotationDao.updateAnnotation(annotation);
  // }

  // @override
  // Future<void> createSoundAnnotation(
  //     SongAnnotationEntity annotation, String sceneId) async {
  //   await _database.songAnnotationDao.createSoundAnnotation(annotation, sceneId);
  // }

  // @override
  // Future<void> deleteSoundAnnotation(SongAnnotationEntity annotation) async {
  //   await _database.songAnnotationDao.deleteSoundAnnotation(annotation);
  // }

  // @override
  // Future<SongAnnotationEntity?> getSoundAnnotation(String id) async {
  //   return await _database.songAnnotationDao.getSoundAnnotation(id);
  // }

  // @override
  // Future<List<SongAnnotationEntity>> getSoundAnnotations(String sceneId) async {
  //   return await _database.songAnnotationDao.getSoundAnnotations(sceneId);
  // }

  // @override
  // Future<void> updateSoundAnnotation(SongAnnotationEntity annotation) async {
  //   await _database.songAnnotationDao.updateSoundAnnotation(annotation);
  // }
}
