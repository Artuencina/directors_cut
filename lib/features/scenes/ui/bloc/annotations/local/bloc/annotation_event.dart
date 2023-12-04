part of 'annotation_bloc.dart';

//Eventos

abstract class AnnotationEvent {
  const AnnotationEvent();
}

//Evento de obtener anotaciones
class GetAnnotationsEvent extends AnnotationEvent {
  const GetAnnotationsEvent({required this.sceneId});
  final int sceneId;
}

//Evento de crear anotación
class CreateAnnotationEvent extends AnnotationEvent {
  const CreateAnnotationEvent({required this.annotation});
  final AnnotationEntity annotation;
}

//Evento de actualizar anotación
class UpdateAnnotationEvent extends AnnotationEvent {
  const UpdateAnnotationEvent({required this.annotation});
  final AnnotationEntity annotation;
}

//Evento de actualizar anotaciones
class UpdateAnnotationsEvent extends AnnotationEvent {
  const UpdateAnnotationsEvent({required this.annotations});
  final List<AnnotationEntity> annotations;
}

//Evento de eliminar anotación
class DeleteAnnotationEvent extends AnnotationEvent {
  const DeleteAnnotationEvent({required this.annotation});
  final AnnotationEntity annotation;
}

//Evento de cambiar anotaciones
class ChangeAnnotationsEvent extends AnnotationEvent {
  const ChangeAnnotationsEvent({required this.sceneId});
  final int sceneId;
}

//Evento de vaciar anotaciones
class ClearAnnotationsEvent extends AnnotationEvent {
  const ClearAnnotationsEvent();
}
