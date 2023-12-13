//Bloc para escenas
//Donde se maneja la escena actual y se obtienen las escenas de un proyecto

import 'package:directors_cut/core/resources/data_state.dart';
import 'package:directors_cut/features/scenes/data/repositories/database_repository_impl.dart';
import 'package:directors_cut/features/scenes/domain/usecases/scenes_usecases.dart';
import 'package:directors_cut/features/scenes/ui/bloc/scenes/local/bloc/local_scene_event.dart';
import 'package:directors_cut/features/scenes/ui/bloc/scenes/local/bloc/local_scene_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LocalScenesBloc extends Bloc<LocalSceneEvent, LocalSceneState> {
  final DatabaseRepositoryImpl repository;
  final GetScenesUseCase getScenesUseCase;
  final CreateSceneUseCase createSceneUseCase;
  final UpdateSceneUseCase updateSceneUseCase;
  final DeleteSceneUseCase deleteSceneUseCase;
  final UpdateScenesUseCase updateScenesUseCase;

  LocalScenesBloc(
    this.getScenesUseCase,
    this.createSceneUseCase,
    this.updateSceneUseCase,
    this.deleteSceneUseCase,
    this.updateScenesUseCase,
    this.repository,
  ) : super(const LocalScenesLoading()) {
    on<GetScenesEvent>(onGetScenes);
    on<CreateSceneEvent>(onCreateScene);
    on<UpdateSceneEvent>(onUpdateScene);
    on<DeleteSceneEvent>(onDeleteScene);
    on<UpdateScenesEvent>(onUpdateScenes);
  }

  void onGetScenes(
    GetScenesEvent event,
    Emitter<LocalSceneState> emit,
  ) async {
    final dataState = await getScenesUseCase(event.projectId);

    if (dataState is DataSuccess) {
      emit(LocalScenesDone(scenes: dataState.data!));
    }

    //Si falla, emitimos el estado de error
    if (dataState is DataFailed) {
      emit(LocalScenesError(error: dataState.error!));
    }
  }

  void onCreateScene(
    CreateSceneEvent event,
    Emitter<LocalSceneState> emit,
  ) async {
    //Antes de crear la escena, emitimos el estado de cargando
    emit(const LocalScenesLoading());
    final createdataState = await createSceneUseCase(event.scene);

    if (createdataState is DataSuccess) {
      //Si se crea la escena, volvemos a obtener las escenas

      final dataState =
          await getScenesUseCase(event.scene.projectId.toString());
      emit(LocalScenesDone(scenes: dataState.data!));
    }

    //Si falla, emitimos el estado de error
    if (createdataState is DataFailed) {
      emit(LocalScenesError(error: createdataState.error!));
    }
  }

  void onUpdateScene(
    UpdateSceneEvent event,
    Emitter<LocalSceneState> emit,
  ) async {
    //Antes de crear la escena, emitimos el estado de cargando
    emit(const LocalScenesLoading());
    final updatedataState = await updateSceneUseCase(event.scene);

    if (updatedataState is DataSuccess) {
      //Si se crea la escena, volvemos a obtener las escenas
      final dataState =
          await getScenesUseCase(event.scene.projectId.toString());
      emit(LocalScenesDone(scenes: dataState.data!));
    }

    //Si falla, emitimos el estado de error
    if (updatedataState is DataFailed) {
      emit(LocalScenesError(error: updatedataState.error!));
    }
  }

  void onDeleteScene(
    DeleteSceneEvent event,
    Emitter<LocalSceneState> emit,
  ) async {
    emit(const LocalScenesLoading());
    final deletedataState = await deleteSceneUseCase(event.scene);

    if (deletedataState is DataSuccess) {
      //Si se elimina la escena, volvemos a obtener las escenas
      final dataState =
          await getScenesUseCase(event.scene.projectId.toString());

      //Antes de emitir el estado vamos a actualizar el orden de las escenas
      //para que no haya huecos en el orden
      final scenes = dataState.data!;
      for (var i = 0; i < scenes.length; i++) {
        scenes[i].orderId = i + 1;
      }

      //Actualizamos las escenas
      await updateScenesUseCase(scenes);

      //Emitimos el estado
      emit(LocalScenesDone(scenes: dataState.data!));
    }

    //Si falla, emitimos el estado de error
    if (deletedataState is DataFailed) {
      emit(LocalScenesError(error: deletedataState.error!));
    }
  }

  void onUpdateScenes(
    UpdateScenesEvent event,
    Emitter<LocalSceneState> emit,
  ) async {
    emit(const LocalScenesLoading());
    final updatedataState = await updateScenesUseCase(event.scenes);

    if (updatedataState is DataSuccess) {
      //Si se crea la escena, volvemos a obtener las escenas
      final dataState =
          await getScenesUseCase(event.scenes[0].projectId.toString());
      emit(LocalScenesDone(scenes: dataState.data!));
    }

    //Si falla, emitimos el estado de error
    if (updatedataState is DataFailed) {
      emit(LocalScenesError(error: updatedataState.error!));
    }
  }
}

//Bloc para la escena actual
class CurrentSceneBloc extends Bloc<CurrentSceneEvent, CurrentSceneState> {
  //Bloc de escenas para obtener la lista de escenas de un proyecto

  CurrentSceneBloc() : super(const CurrentSceneNone()) {
    on<ChangeCurrentSceneEvent>(onChangeCurrentScene);
    on<EmptyCurrentSceneEvent>(onEmptyCurrentScene);
  }

  void onEmptyCurrentScene(
    EmptyCurrentSceneEvent event,
    Emitter<CurrentSceneState> emit,
  ) async {
    emit(const CurrentSceneNone());
  }

  void onChangeCurrentScene(
    ChangeCurrentSceneEvent event,
    Emitter<CurrentSceneState> emit,
  ) async {
    emit(CurrentSceneDone(scene: event.scene));
  }
}
