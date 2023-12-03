import 'package:dio/dio.dart';
import 'package:directors_cut/features/scenes/data/datasources/local/app_database.dart';
//import 'package:directors_cut/features/scenes/data/datasources/local/migrations.dart';
import 'package:directors_cut/features/scenes/data/repositories/database_repository_impl.dart';
import 'package:directors_cut/features/scenes/domain/repositories/database_repository.dart';
import 'package:directors_cut/features/scenes/domain/usecases/projects_usecases.dart';
import 'package:directors_cut/features/scenes/domain/usecases/scenes_usecases.dart';
import 'package:directors_cut/features/scenes/ui/bloc/projects/local/local_project_bloc.dart';
import 'package:directors_cut/features/scenes/ui/bloc/scenes/local/bloc/local_scene_bloc.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  final database =
      await $FloorAppDatabase.databaseBuilder('app_database.db').build();

  sl.registerSingleton<AppDatabase>(database);

  sl.registerSingleton<Dio>(Dio());

  //Dependencies
  sl.registerSingleton<DatabaseRepository>(DatabaseRepositoryImpl(sl()));

  sl.registerSingleton<DatabaseRepositoryImpl>(DatabaseRepositoryImpl(sl()));

  //Usecases
  sl.registerSingleton<GetProjectsUseCase>(GetProjectsUseCase(sl()));

  sl.registerSingleton<CreateProjectuseCase>(CreateProjectuseCase(sl()));

  sl.registerSingleton<UpdateProjectUseCase>(UpdateProjectUseCase(sl()));

  sl.registerSingleton<DeleteProjectUseCase>(DeleteProjectUseCase(sl()));

  sl.registerSingleton<GetProjectUseCase>(GetProjectUseCase(sl()));

  sl.registerSingleton<GetScenesUseCase>(GetScenesUseCase(sl()));

  sl.registerSingleton<CreateSceneUseCase>(CreateSceneUseCase(sl()));

  sl.registerSingleton<UpdateSceneUseCase>(UpdateSceneUseCase(sl()));

  sl.registerSingleton<UpdateScenesUseCase>(UpdateScenesUseCase(sl()));

  sl.registerSingleton<DeleteSceneUseCase>(DeleteSceneUseCase(sl()));

  //Blocs
  sl.registerFactory<LocalProjectsBloc>(() => LocalProjectsBloc(
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
      ));
  sl.registerFactory<CurrentSceneBloc>(() => CurrentSceneBloc());
  sl.registerFactory<LocalScenesBloc>(() => LocalScenesBloc(
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
      ));
}
