//Entidad para los proyectos cuyo id se genera con uuid

import 'package:directors_cut/core/constants/strings.dart';
import 'package:equatable/equatable.dart';
import 'package:floor/floor.dart';

@Entity(tableName: projectsTable)
class ProjectEntity extends Equatable {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String name;
  final String description;

  const ProjectEntity({
    required this.name,
    this.id,
    required this.description,
  });

  //Serializacion
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
      'description': description,
    };
  }

  //Deserializacion
  factory ProjectEntity.fromJson(Map<String, dynamic> json) {
    return ProjectEntity(
      name: json['name'] as String,
      id: json['id'] as int,
      description: json['description'] as String,
    );
  }

  @override
  List<Object?> get props => [
        name,
        id,
        description,
      ];

  //ToMap
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'id': id,
      'description': description,
    };
  }
}
