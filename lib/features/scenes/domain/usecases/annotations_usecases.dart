//Usecases para anotaciones

import 'package:directors_cut/core/resources/data_state.dart';
import 'package:directors_cut/core/usecase/usecase.dart';
import 'package:directors_cut/features/scenes/domain/entities/annotation_entity.dart';
import 'package:directors_cut/features/scenes/domain/repositories/database_repository.dart';

class CreateAnnotationUseCase
    implements UseCase<DataState<void>, AnnotationEntity> {
  final DatabaseRepository repository;

  CreateAnnotationUseCase(this.repository);

  @override
  Future<DataState<void>> call(AnnotationEntity params) async {
    return repository.createAnnotation(params);
  }
}

class GetAnnotationsUseCase
    implements UseCase<DataState<List<AnnotationEntity>>, int> {
  final DatabaseRepository repository;

  GetAnnotationsUseCase(this.repository);

  @override
  Future<DataState<List<AnnotationEntity>>> call(int param) {
    //Obtener en el orderId
    return repository.getAnnotations(param);
  }
}

class UpdateAnnotationUseCase
    implements UseCase<DataState<void>, AnnotationEntity> {
  final DatabaseRepository repository;

  UpdateAnnotationUseCase(this.repository);

  @override
  Future<DataState<void>> call(AnnotationEntity params) async {
    return await repository.updateAnnotation(params);
  }
}

class UpdateAnnotationsUseCase
    implements UseCase<DataState<void>, List<AnnotationEntity>> {
  final DatabaseRepository repository;

  UpdateAnnotationsUseCase(this.repository);

  @override
  Future<DataState<void>> call(List<AnnotationEntity> params) async {
    return await repository.updateAnnotations(params);
  }
}

class DeleteAnnotationUseCase
    implements UseCase<DataState<void>, AnnotationEntity> {
  final DatabaseRepository repository;

  DeleteAnnotationUseCase(this.repository);

  @override
  Future<DataState<void>> call(AnnotationEntity params) async {
    return await repository.deleteAnnotation(params);
  }
}
