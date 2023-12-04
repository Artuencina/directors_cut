//Estados

import 'package:directors_cut/features/scenes/domain/entities/scene_entity.dart';
import 'package:equatable/equatable.dart';

abstract class LocalSceneState extends Equatable {
  const LocalSceneState({this.scenes, this.error});

  final List<SceneEntity>? scenes;
  final Exception? error;

  @override
  List<Object> get props => [scenes ?? [], error ?? ''];
}

class LocalScenesLoading extends LocalSceneState {
  const LocalScenesLoading();
}

class LocalScenesDone extends LocalSceneState {
  const LocalScenesDone({
    required List<SceneEntity> scenes,
  }) : super(scenes: scenes);
}

class LocalScenesError extends LocalSceneState {
  const LocalScenesError({required Exception error}) : super(error: error);
}

//Estado de la escena actual
abstract class CurrentSceneState extends Equatable {
  const CurrentSceneState({this.scene});

  final SceneEntity? scene;

  @override
  List<Object> get props => [scene ?? ''];
}

class CurrentSceneDone extends CurrentSceneState {
  const CurrentSceneDone({
    required SceneEntity? scene,
  }) : super(scene: scene);
}

class CurrentSceneNone extends CurrentSceneState {
  const CurrentSceneNone();
}
