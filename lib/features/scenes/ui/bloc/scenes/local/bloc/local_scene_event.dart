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

//Escena actual, sirve para navegar entre escenas
//y obtener todas las anotaciones de la escena actual
abstract class CurrentSceneEvent {
  const CurrentSceneEvent();
}

//Evento de cambiar la escena actual
class ChangeCurrentSceneEvent extends CurrentSceneEvent {
  const ChangeCurrentSceneEvent({required this.scene});
  final SceneEntity scene;
}

//Evento para cambiar a la escena siguiente
class NextSceneEvent extends CurrentSceneEvent {
  const NextSceneEvent();
}

//Evento para cambiar a la escena anterior
class PreviousSceneEvent extends CurrentSceneEvent {
  const PreviousSceneEvent();
}
