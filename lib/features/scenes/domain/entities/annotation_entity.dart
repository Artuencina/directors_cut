//Entidad para una anotacion de una escena que puede ser
//musica, texto o anotacion de iluminacion
// ignore_for_file: must_be_immutable

import 'package:directors_cut/features/scenes/domain/entities/scene_entity.dart';
import 'package:floor/floor.dart';
import 'package:directors_cut/core/constants/strings.dart';
import 'package:equatable/equatable.dart';

@Entity(
  tableName: annotationsTable,
  foreignKeys: [
    ForeignKey(
      childColumns: ['sceneId'],
      parentColumns: ['id'],
      entity: SceneEntity,
    )
  ],
)
class AnnotationEntity extends Equatable {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final int? sceneId;
  String title;
  String description; //En texto e iluminacion se toma este campo como el texto
  final String type; //Tipo de anotacion (texto, musica, iluminacion)
  int? orderId;
  String? color; //Color de la anotacion, tambien se usa para iluminacion

  //Musica
  String? url; //Url de la cancion
  int? songStart; //Entrada y salida de musica
  int? songEnd;

  String? playType; //Tipo de reproduccion (loop, play_once)
  String? soundType; //Tipo de sonido (ambiente, efecto)
  int? volume; //Volumen de la cancion

  AnnotationEntity({
    this.id,
    required this.sceneId,
    required this.title,
    required this.description,
    this.orderId,
    this.color,
    this.url,
    this.songStart,
    this.songEnd,
    required this.type,
    this.playType,
    this.soundType,
    this.volume,
  });

  @override
  List<Object?> get props => [
        id,
        sceneId,
        title,
        description,
        orderId,
        color,
        url,
        songStart,
        songEnd,
        type,
        playType,
        soundType,
        volume,
      ];

  //Serializacion
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sceneId': sceneId,
      'title': title,
      'description': description,
      'orderId': orderId,
      'color': color,
      'url': url,
      'songStart': songStart,
      'songEnd': songEnd,
      'type': type,
      'playType': playType,
      'soundType': soundType,
      'volume': volume,
    };
  }

  //Deserializacion
  factory AnnotationEntity.fromJson(Map<String, dynamic> json) {
    return AnnotationEntity(
      id: json['id'] as int,
      sceneId: json['sceneId'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      orderId: json['orderId'] as int,
      color: json['color'] as String?,
      url: json['url'] as String?,
      songStart: json['songStart'] as int?,
      songEnd: json['songEnd'] as int?,
      type: json['type'] as String,
      playType: json['playType'] as String?,
      soundType: json['soundType'] as String?,
      volume: json['volume'] as int?,
    );
  }

  //ToMap
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sceneId': sceneId,
      'title': title,
      'description': description,
      'orderId': orderId,
      'color': color,
      'url': url,
      'songStart': songStart,
      'songEnd': songEnd,
      'type': type,
      'playType': playType,
      'soundType': soundType,
      'volume': volume,
    };
  }
}
