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
    on<CreateAnnotationEvent>(onAddAnnotation);
    on<UpdateAnnotationEvent>(onUpdateAnnotation);
    on<DeleteAnnotationEvent>(onDeleteAnnotation);
    on<UpdateAnnotationsEvent>(onUpdateAnnotations);
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
    emit(const AnnotationLoading());
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
    emit(const AnnotationLoading());
    final dataState = await deleteAnnotationUseCase(event.annotation);

    if (dataState is DataSuccess) {
      final dataState = await getAnnotationsUseCase(event.annotation.sceneId!);
      emit(AnnotationDone(annotations: dataState.data!));
    }

    //Si falla, emitimos el estado de error
    if (dataState is DataFailed) {
      emit(AnnotationError(error: dataState.error!));
    }
  }

  void onUpdateAnnotation(
      UpdateAnnotationEvent event, Emitter<AnnotationState> emit) async {
    emit(const AnnotationLoading());
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

  void onAddAnnotation(
      CreateAnnotationEvent event, Emitter<AnnotationState> emit) async {
    //Antes de crear la escena, emitimos el estado de cargando
    emit(const AnnotationLoading());
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
