//Usecases para proyectos

import 'package:directors_cut/core/resources/data_state.dart';
import 'package:directors_cut/core/usecase/usecase.dart';
import 'package:directors_cut/features/scenes/domain/entities/project_entity.dart';
import 'package:directors_cut/features/scenes/domain/repositories/database_repository.dart';

class CreateProjectuseCase implements UseCase<DataState<void>, ProjectEntity> {
  final DatabaseRepository repository;

  CreateProjectuseCase(this.repository);

  @override
  Future<DataState<void>> call(ProjectEntity params) async {
    return repository.createProject(params);
  }
}

//Para obtener un solo proyecto
class GetProjectUseCase implements UseCase<DataState<ProjectEntity>, String> {
  final DatabaseRepository repository;

  GetProjectUseCase(this.repository);

  @override
  Future<DataState<ProjectEntity>> call(String param) {
    return repository.getProject(param);
  }
}

class GetProjectsUseCase
    implements UseCase<DataState<List<ProjectEntity>>, void> {
  final DatabaseRepository repository;

  GetProjectsUseCase(this.repository);

  @override
  Future<DataState<List<ProjectEntity>>> call(param) {
    return repository.getProjects();
  }
}

class UpdateProjectUseCase implements UseCase<DataState<void>, ProjectEntity> {
  final DatabaseRepository repository;

  UpdateProjectUseCase(this.repository);

  @override
  Future<DataState<void>> call(ProjectEntity params) async {
    return await repository.updateProject(params);
  }
}

class DeleteProjectUseCase implements UseCase<DataState<void>, ProjectEntity> {
  final DatabaseRepository repository;

  DeleteProjectUseCase(this.repository);

  @override
  Future<DataState<void>> call(ProjectEntity params) async {
    return await repository.deleteProject(params);
  }
}
