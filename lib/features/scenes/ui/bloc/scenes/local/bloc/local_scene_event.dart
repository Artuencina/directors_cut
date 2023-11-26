//Eventos

import 'package:directors_cut/features/scenes/domain/entities/scene_entity.dart';

abstract class LocalSceneEvent {
  const LocalSceneEvent();
}

//Evento de obtener escenas
class GetScenesEvent extends LocalSceneEvent {
  const GetScenesEvent({required this.projectId});
  final String projectId;
}

//Evento de crear escena
class CreateSceneEvent extends LocalSceneEvent {
  const CreateSceneEvent({required this.scene});
  final SceneEntity scene;
}

//Evento de actualizar escena
class UpdateSceneEvent extends LocalSceneEvent {
  const UpdateSceneEvent({required this.scene});
  final SceneEntity scene;
}

//Evento de actualizar escenas (para el orden)
class UpdateScenesEvent extends LocalSceneEvent {
  const UpdateScenesEvent({required this.scenes});
  final List<SceneEntity> scenes;
}

//Evento de eliminar escena
class DeleteSceneEvent extends LocalSceneEvent {
  const DeleteSceneEvent({required this.scene});
  final SceneEntity scene;
}

//Evento de cambiar escena actual
class ChangeCurrentSceneEvent extends LocalSceneEvent {
  const ChangeCurrentSceneEvent({required this.scene});
  final SceneEntity scene;
}

//Evento de obtener escena actual
class GetCurrentSceneEvent extends LocalSceneEvent {
  const GetCurrentSceneEvent();
}

//Evento de cambiar a escena anterior
class ChangeToPreviousSceneEvent extends LocalSceneEvent {
  const ChangeToPreviousSceneEvent();
}

//Evento de cambiar a escena siguiente
class ChangeToNextSceneEvent extends LocalSceneEvent {
  const ChangeToNextSceneEvent();
}
