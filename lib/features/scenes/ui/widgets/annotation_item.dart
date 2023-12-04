//Item de anotacion para una escena
//Puede ser texto, musica o iluminacion

import 'package:directors_cut/features/scenes/domain/entities/annotation_entity.dart';
import 'package:flutter/material.dart';
import 'package:string_to_color/string_to_color.dart';

class AnnotationItem extends StatelessWidget {
  final AnnotationEntity annotation;

  const AnnotationItem({
    Key? key,
    required this.annotation,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      key: ValueKey(annotation.id),
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      //Utilizar el color de la anotacion, que esta en string
      color: ColorUtils.stringToColor(annotation.color ?? '0xFF000000'),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
        //El icono depende del tipo de anotacion
        leading: annotation.type == 'text'
            ? const Icon(Icons.text_fields)
            : annotation.type == 'music'
                ? const Icon(Icons.music_note)
                : const Icon(Icons.lightbulb),
        title: Text(annotation.title),
        subtitle: Text(annotation.description),
        onTap: () => {},
        onLongPress: () {},
      ),
    );
  }
}
