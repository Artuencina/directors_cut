import 'package:directors_cut/features/scenes/data/repositories/database_repository_impl.dart';
import 'package:directors_cut/features/scenes/domain/entities/annotation_entity.dart';
import 'package:directors_cut/features/scenes/domain/usecases/annotations_usecases.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/resources/data_state.dart';

part 'annotation_event.dart';
part 'annotation_state.dart';

class AnnotationBloc extends Bloc<AnnotationEvent, AnnotationState> {
  final DatabaseRepositoryImpl repository;
  final GetAnnotationsUseCase getAnnotationsUseCase;
  final CreateAnnotationUseCase createAnnotationUseCase;
  final UpdateAnnotationUseCase updateAnnotationUseCase;
  final DeleteAnnotationUseCase deleteAnnotationUseCase;
  final UpdateAnnotationsUseCase updateAnnotationsUseCase;

  AnnotationBloc(
    this.getAnnotationsUseCase,
    this.createAnnotationUseCase,
    this.updateAnnotationUseCase,
    this.deleteAnnotationUseCase,
    this.updateAnnotationsUseCase,
    this.repository,
  ) : super(const AnnotationLoading()) {
    on<ChangeAnnotationsEvent>(onChangeAnnotations);
    on<CreateAnnotationEvent>(onCreateAnnotation);
    on<UpdateAnnotationEvent>(onUpdateAnnotation);
    on<DeleteAnnotationEvent>(onDeleteAnnotation);
    on<UpdateAnnotationsEvent>(onUpdateAnnotations);
    on<ReorderAnnotationsEvent>(onReorderAnnotations);
    on<GetAnnotationsEvent>(onGetAnnotations);
    on<ClearAnnotationsEvent>(onClearAnnotations);
  }

  void onClearAnnotations(
      ClearAnnotationsEvent event, Emitter<AnnotationState> emit) async {
    //emit(const AnnotationLoading());
    emit(const AnnotationDone(annotations: []));
  }

  void onGetAnnotations(
      GetAnnotationsEvent event, Emitter<AnnotationState> emit) async {
    emit(const AnnotationLoading());
    final dataState = await getAnnotationsUseCase(event.sceneId);

    if (dataState is DataSuccess) {
      emit(AnnotationDone(annotations: dataState.data!));
    }

    //Si falla, emitimos el estado de error
    if (dataState is DataFailed) {
      emit(AnnotationError(error: dataState.error!));
    }
  }

  void onUpdateAnnotations(
      UpdateAnnotationsEvent event, Emitter<AnnotationState> emit) async {
    //emit(const AnnotationLoading());
    final dataState = await updateAnnotationsUseCase(event.annotations);

    if (dataState is DataSuccess) {
      final dataState =
          await getAnnotationsUseCase(event.annotations[0].sceneId!);
      emit(AnnotationDone(annotations: dataState.data!));
    }

    //Si falla, emitimos el estado de error
    if (dataState is DataFailed) {
      emit(AnnotationError(error: dataState.error!));
    }
  }

  void onDeleteAnnotation(
      DeleteAnnotationEvent event, Emitter<AnnotationState> emit) async {
    //emit(const AnnotationLoading());
    final dataState = await deleteAnnotationUseCase(event.annotation);

    if (dataState is DataSuccess) {
      //Si se elimina una anotacion volvemos a obtener las anotaciones
      final dataState = await getAnnotationsUseCase(event.annotation.sceneId!);

      //Antes de emitir el estado, vamos a actualizar el orderId de las anotaciones
      //para que no haya huecos en el orden
      final annotations = dataState.data!;
      for (var i = 0; i < annotations.length; i++) {
        annotations[i].orderId = i + 1;
      }

      //Actualizamos las anotaciones
      await updateAnnotationsUseCase(annotations);

      emit(AnnotationDone(annotations: dataState.data!));
    }

    //Si falla, emitimos el estado de error
    if (dataState is DataFailed) {
      emit(AnnotationError(error: dataState.error!));
    }
  }

  void onUpdateAnnotation(
      UpdateAnnotationEvent event, Emitter<AnnotationState> emit) async {
    //emit(const AnnotationLoading());
    final dataState = await updateAnnotationUseCase(event.annotation);

    if (dataState is DataSuccess) {
      final dataState = await getAnnotationsUseCase(event.annotation.sceneId!);
      emit(AnnotationDone(annotations: dataState.data!));
    }

    //Si falla, emitimos el estado de error
    if (dataState is DataFailed) {
      emit(AnnotationError(error: dataState.error!));
    }
  }

  void onReorderAnnotations(
      ReorderAnnotationsEvent event, Emitter<AnnotationState> emit) async {
    //emit(const AnnotationLoading());
    //Obtener las anotaciones
    List<AnnotationEntity> annotations = event.annotations;

    final annotation = annotations[event.oldIndex];
    annotations.removeAt(event.oldIndex);
    annotations.insert(event.newIndex, annotation);

    //Actualizamos el orderId de las anotaciones
    for (var i = 0; i < annotations.length; i++) {
      annotations[i].orderId = i + 1;
    }

    //Actualizamos las anotaciones
    await updateAnnotationsUseCase(annotations);

    emit(AnnotationDone(annotations: annotations));
  }

  void onCreateAnnotation(
      CreateAnnotationEvent event, Emitter<AnnotationState> emit) async {
    //Antes de crear la escena, emitimos el estado de cargando
    //emit(const AnnotationLoading());

    final createdataState = await createAnnotationUseCase(event.annotation);

    if (createdataState is DataSuccess) {
      //Si se crea la escena, volvemos a obtener las escenas

      final dataState = await getAnnotationsUseCase(event.annotation.sceneId!);

      if (dataState is DataSuccess) {
        emit(AnnotationDone(annotations: dataState.data!));
      }

      //Si falla, emitimos el estado de error
      if (dataState is DataFailed) {
        emit(AnnotationError(error: dataState.error!));
      }
    }
  }

  void onChangeAnnotations(
      ChangeAnnotationsEvent event, Emitter<AnnotationState> emit) async {
    emit(const AnnotationLoading());
    final dataState = await getAnnotationsUseCase(event.sceneId);

    if (dataState is DataSuccess) {
      emit(AnnotationDone(annotations: dataState.data!));
    }

    //Si falla, emitimos el estado de error
    if (dataState is DataFailed) {
      emit(AnnotationError(error: dataState.error!));
    }
  }
}
