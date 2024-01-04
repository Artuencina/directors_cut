import 'package:directors_cut/core/constants/strings.dart';
import 'package:directors_cut/features/scenes/domain/entities/project_entity.dart';
import 'package:floor/floor.dart';

@dao
abstract class ProjectDao {
  @Query('SELECT * FROM $projectsTable')
  Future<List<ProjectEntity>> getProjects();

  @Query('SELECT * FROM $projectsTable WHERE id = :id')
  Future<ProjectEntity?> getProject(String id);

  @insert
  Future<void> createProject(ProjectEntity project);

  @update
  Future<void> updateProject(ProjectEntity project);

  //Query para eliminar un proyecto
  //Elimina las anotaciones, luego las escenas y finalmente el proyecto
  @delete
  Future<void> deleteProject(ProjectEntity project);
}
