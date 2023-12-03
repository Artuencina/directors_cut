//Entidad para escenas que contiene anotaciones de musica y texto
// ignore_for_file: must_be_immutable

import 'package:directors_cut/core/constants/strings.dart';
import 'package:directors_cut/features/scenes/domain/entities/project_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:floor/floor.dart';

@Entity(
  tableName: scenesTable,
  foreignKeys: [
    ForeignKey(
      childColumns: ['projectId'],
      parentColumns: ['id'],
      entity: ProjectEntity,
    )
  ],
)
class SceneEntity extends Equatable {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final int? projectId;
  String name;
  int orderId;

  SceneEntity({
    this.id,
    required this.projectId,
    required this.name,
    required this.orderId,
  });

  @override
  List<Object?> get props => [
        id,
        projectId,
        name,
        orderId,
      ];
  //Serializacion
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'projectId': projectId,
      'name': name,
      'orderId': orderId,
    };
  }

  //Deserializacion
  factory SceneEntity.fromJson(Map<String, dynamic> json) {
    return SceneEntity(
      id: json['id'] as int,
      projectId: json['projectId'] as int,
      name: json['name'] as String,
      orderId: json['orderId'] as int,
    );
  }

  //ToMap
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'projectId': projectId,
      'name': name,
      'orderId': orderId,
    };
  }
}
