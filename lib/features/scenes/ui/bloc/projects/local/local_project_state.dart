//Estados

import 'package:directors_cut/features/scenes/domain/entities/project_entity.dart';
import 'package:equatable/equatable.dart';

abstract class LocalProjectState extends Equatable {
  const LocalProjectState({
    this.projects,
    this.error,
  });

  final List<ProjectEntity>? projects;
  final Exception? error;

  @override
  List<Object> get props => [];
}

class LocalProjectsLoading extends LocalProjectState {
  const LocalProjectsLoading();
}

class LocalProjectsDone extends LocalProjectState {
  const LocalProjectsDone({required List<ProjectEntity> projects})
      : super(projects: projects);
}

class LocalProjectsError extends LocalProjectState {
  const LocalProjectsError({required Exception error}) : super(error: error);
}
