//Usecases para escenas

import 'package:directors_cut/core/resources/data_state.dart';
import 'package:directors_cut/core/usecase/usecase.dart';
import 'package:directors_cut/features/scenes/domain/entities/scene_entity.dart';
import 'package:directors_cut/features/scenes/domain/repositories/database_repository.dart';

class CreateSceneUseCase implements UseCase<DataState<void>, SceneEntity> {
  final DatabaseRepository repository;

  CreateSceneUseCase(this.repository);

  @override
  Future<DataState<void>> call(SceneEntity params) async {
    return repository.createScene(params);
  }
}

class GetScenesUseCase
    implements UseCase<DataState<List<SceneEntity>>, String> {
  final DatabaseRepository repository;

  GetScenesUseCase(this.repository);

  @override
  Future<DataState<List<SceneEntity>>> call(param) {
    return repository.getScenes(param);
  }
}

class UpdateSceneUseCase implements UseCase<DataState<void>, SceneEntity> {
  final DatabaseRepository repository;

  UpdateSceneUseCase(this.repository);

  @override
  Future<DataState<void>> call(SceneEntity params) async {
    return repository.updateScene(params);
  }
}

class UpdateScenesUseCase
    implements UseCase<DataState<void>, List<SceneEntity>> {
  final DatabaseRepository repository;

  UpdateScenesUseCase(this.repository);

  @override
  Future<DataState<void>> call(List<SceneEntity> params) async {
    return repository.updateScenes(params);
  }
}

class DeleteSceneUseCase implements UseCase<DataState<void>, SceneEntity> {
  final DatabaseRepository repository;

  DeleteSceneUseCase(this.repository);

  @override
  Future<DataState<void>> call(SceneEntity params) async {
    return repository.deleteScene(params);
  }
}
