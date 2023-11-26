//Estados

import 'package:directors_cut/features/scenes/domain/entities/scene_entity.dart';
import 'package:equatable/equatable.dart';

abstract class LocalSceneState extends Equatable {
  const LocalSceneState({this.scenes, this.error, this.currentScene});

  final List<SceneEntity>? scenes;
  final SceneEntity? currentScene;
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
    SceneEntity? currentScene,
  }) : super(scenes: scenes);
}

class LocalScenesError extends LocalSceneState {
  const LocalScenesError({required Exception error}) : super(error: error);
}
