part of 'annotation_bloc.dart';

//Estados

abstract class AnnotationState extends Equatable {
  const AnnotationState({
    this.annotations,
    this.error,
  });

  final List<AnnotationEntity>? annotations;
  final Exception? error;

  @override
  List<Object> get props => [annotations ?? [], error ?? []];
}

class AnnotationLoading extends AnnotationState {
  const AnnotationLoading();
}

class AnnotationDone extends AnnotationState {
  const AnnotationDone({required List<AnnotationEntity> annotations})
      : super(annotations: annotations);
}

class AnnotationError extends AnnotationState {
  const AnnotationError({required Exception error}) : super(error: error);
}
