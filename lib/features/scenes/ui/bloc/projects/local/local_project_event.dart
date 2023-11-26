//Eventos

import 'package:directors_cut/features/scenes/domain/entities/project_entity.dart';

abstract class LocalProjectsEvent {
  const LocalProjectsEvent();
}

//Evento de obtener proyecto
class GetProjectEvent extends LocalProjectsEvent {
  const GetProjectEvent({required this.projectId});
  final String projectId;
}

//Evento de obtener proyectos
class GetProjectsEvent extends LocalProjectsEvent {
  const GetProjectsEvent();
}

//Evento de crear proyecto
class CreateProjectEvent extends LocalProjectsEvent {
  const CreateProjectEvent({required this.project});
  final ProjectEntity project;
}

//Evento de actualizar proyecto
class UpdateProjectEvent extends LocalProjectsEvent {
  const UpdateProjectEvent({required this.project});
  final ProjectEntity project;
}

//Evento de eliminar proyecto
class DeleteProjectEvent extends LocalProjectsEvent {
  const DeleteProjectEvent({required this.project});
  final ProjectEntity project;
}
