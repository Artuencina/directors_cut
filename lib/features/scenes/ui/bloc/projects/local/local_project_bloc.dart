//BLOC

import 'package:directors_cut/core/resources/data_state.dart';
import 'package:directors_cut/features/scenes/data/repositories/database_repository_impl.dart';
import 'package:directors_cut/features/scenes/domain/usecases/projects_usecases.dart';
import 'package:directors_cut/features/scenes/ui/bloc/projects/local/local_project_event.dart';
import 'package:directors_cut/features/scenes/ui/bloc/projects/local/local_project_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LocalProjectsBloc extends Bloc<LocalProjectsEvent, LocalProjectState> {
  final DatabaseRepositoryImpl repository;
  final GetProjectUseCase getProjectUseCase;
  final GetProjectsUseCase getProjectsUseCase;
  final CreateProjectuseCase createProjectUseCase;
  final UpdateProjectUseCase updateProjectUseCase;
  final DeleteProjectUseCase deleteProjectUseCase;

  LocalProjectsBloc(
      this.getProjectsUseCase,
      this.createProjectUseCase,
      this.updateProjectUseCase,
      this.deleteProjectUseCase,
      this.getProjectUseCase,
      this.repository)
      : super(const LocalProjectsLoading()) {
    on<GetProjectEvent>(onGetProject);
    on<GetProjectsEvent>(onGetProjects);
    on<CreateProjectEvent>(onCreateProject);
    on<UpdateProjectEvent>(onUpdateProject);
    on<DeleteProjectEvent>(onDeleteProject);
  }

  void onGetProject(
      GetProjectEvent event, Emitter<LocalProjectState> emit) async {
    final dataState = await getProjectUseCase(event.projectId);

    if (dataState is DataSuccess) {
      emit(LocalProjectsDone(projects: [dataState.data!]));
    }

    //Si falla, emitimos el estado de error
    if (dataState is DataFailed) {
      emit(LocalProjectsError(error: dataState.error!));
    }
  }

  void onGetProjects(
      GetProjectsEvent event, Emitter<LocalProjectState> emit) async {
    final dataState = await getProjectsUseCase(repository);

    if (dataState is DataSuccess) {
      emit(LocalProjectsDone(projects: dataState.data!));
    }

    //Si falla, emitimos el estado de error
    if (dataState is DataFailed) {
      emit(LocalProjectsError(error: dataState.error!));
    }
  }

  void onCreateProject(
      CreateProjectEvent event, Emitter<LocalProjectState> emit) async {
    //Antes de crear el proyecto, emitimos el estado de cargando
    emit(const LocalProjectsLoading());
    final createdataState = await createProjectUseCase(event.project);

    if (createdataState is DataSuccess) {
      //Si se crea el proyecto, volvemos a obtener los proyectos
      final dataState = await getProjectsUseCase(repository);
      emit(LocalProjectsDone(projects: dataState.data!));
    }

    //Si falla, emitimos el estado de error
    if (createdataState is DataFailed) {
      emit(LocalProjectsError(error: createdataState.error!));
    }
  }

  void onUpdateProject(
      UpdateProjectEvent event, Emitter<LocalProjectState> emit) async {
    //Antes de crear el proyecto, emitimos el estado de cargando
    emit(const LocalProjectsLoading());
    final updatedataState = await updateProjectUseCase(event.project);

    if (updatedataState is DataSuccess) {
      final dataState = await getProjectsUseCase(repository);
      emit(LocalProjectsDone(projects: dataState.data!));
    }

    //Si falla, emitimos el estado de error
    if (updatedataState is DataFailed) {
      emit(LocalProjectsError(error: updatedataState.error!));
    }
  }

  void onDeleteProject(
      DeleteProjectEvent event, Emitter<LocalProjectState> emit) async {
    emit(const LocalProjectsLoading());

    final deletedataState = await deleteProjectUseCase(event.project);

    if (deletedataState is DataSuccess) {
      final dataState = await getProjectsUseCase(repository);
      emit(LocalProjectsDone(projects: dataState.data!));
    }

    //Si falla, emitimos el estado de error
    if (deletedataState is DataFailed) {
      emit(LocalProjectsError(error: deletedataState.error!));
    }
  }
}
