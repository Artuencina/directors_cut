//Entidad para una anotacion de una escena que puede ser
//musica o texto

import 'package:flutter/material.dart';

class Annotation {
  final String id;
  final IconData icon;
  final String title;
  final String description;

  const Annotation({
    required this.id,
    required this.icon,
    required this.title,
    required this.description,
  });
}

class SongAnnotationEntity extends Annotation {
  final String songId;

  const SongAnnotationEntity({
    required String id,
    required IconData icon,
    required String title,
    required String description,
    required this.songId,
  }) : super(
          id: id,
          icon: icon,
          title: title,
          description: description,
        );

  //Serializacion
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'icon': icon,
      'title': title,
      'description': description,
      'songId': songId,
    };
  }

  //Deserializacion
  factory SongAnnotationEntity.fromJson(Map<String, dynamic> json) {
    return SongAnnotationEntity(
      id: json['id'] as String,
      icon: json['icon'] as IconData,
      title: json['title'] as String,
      description: json['description'] as String,
      songId: json['songId'] as String,
    );
  }

  //ToMap
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'icon': icon,
      'title': title,
      'description': description,
      'songId': songId,
    };
  }
}

class TextAnnotationEntity extends Annotation {
  const TextAnnotationEntity({
    required String id,
    required IconData icon,
    required String title,
    required String description,
  }) : super(
          id: id,
          icon: icon,
          title: title,
          description: description,
        );

  //Serializacion
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'icon': icon,
      'title': title,
      'description': description,
    };
  }

  //Deserializacion
  factory TextAnnotationEntity.fromJson(Map<String, dynamic> json) {
    return TextAnnotationEntity(
      id: json['id'] as String,
      icon: json['icon'] as IconData,
      title: json['title'] as String,
      description: json['description'] as String,
    );
  }

  //ToMap
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'icon': icon,
      'title': title,
      'description': description,
    };
  }
}
