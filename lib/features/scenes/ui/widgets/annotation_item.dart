//Item de anotacion para una escena
//Puede ser texto, musica o iluminacion

import 'package:directors_cut/features/scenes/domain/entities/annotation_entity.dart';
import 'package:directors_cut/features/scenes/ui/bloc/annotations/local/bloc/annotation_bloc.dart';
import 'package:directors_cut/features/scenes/ui/widgets/lighting_annotation_form.dart';
import 'package:directors_cut/features/scenes/ui/widgets/song_annotation_form.dart';
import 'package:directors_cut/features/scenes/ui/widgets/text_annotation_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AnnotationItem extends StatelessWidget {
  final AnnotationEntity annotation;
  const AnnotationItem({
    Key? key,
    required this.annotation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color textColor =
        Color(int.parse(annotation.color!)).computeLuminance() < 0.5
            ? Colors.white
            : Colors.black;
    return Card(
      key: ValueKey(annotation.id),
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      //Utilizar el color de la anotacion, que esta en string
      color: Color(int.parse(annotation.color!)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
        leading: ReorderableDragStartListener(
          key: ValueKey(annotation.id),
          index: annotation.orderId! - 1,
          child: const Icon(Icons.drag_handle),
        ),
        //El icono depende del tipo de anotacion

        trailing: annotation.type == 'text'
            ? Icon(Icons.text_fields, color: textColor)
            : annotation.type == 'music'
                ? Icon(
                    Icons.music_note,
                    color: textColor,
                  )
                //Si el color es negro, poner icono de luz apagada

                : annotation.color! == Colors.black.value.toString()
                    ? const Icon(Icons.lightbulb_outline, color: Colors.white)
                    : Icon(
                        Icons.lightbulb,
                        color: textColor,
                      ),

        title: Text(
          annotation.title,
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: textColor),
        ),
        subtitle: annotation.description.isNotEmpty
            ? Text(
                annotation.description,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: textColor),
              )
            : null,
        //onTap: () => {},
        onLongPress: () {
          //Abrir un modalbotomsheet donde pregunta si se quiere editar
          //Agregar un pie de anotacion //TODO: Implementar pie de anotacion
          //O eliminar la anotacion
          showModalBottomSheet(
              context: context,
              builder: (context) => Wrap(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.edit),
                        title: const Text('Editar'),
                        onTap: () => Navigator.of(context).pop('editar'),
                      ),
                      ListTile(
                        leading: const Icon(Icons.delete),
                        title: const Text('Eliminar'),
                        onTap: () => Navigator.of(context).pop('eliminar'),
                      ),
                    ],
                  )).then((value) {
            if (value == 'editar') {
              showModalBottomSheet(
                context: context,
                useSafeArea: true,
                isScrollControlled: true,
                builder: (context) {
                  //Abrir el formulario segun el tipo de anotacion
                  if (annotation.type == 'text') {
                    return TextAnnotationForm(
                        sceneId: annotation.sceneId!, annotation: annotation);
                  } else if (annotation.type == 'music') {
                    return SongAnnotationForm(
                        sceneId: annotation.sceneId!, annotation: annotation);
                  } else {
                    return LightingAnnotationForm(
                        sceneId: annotation.sceneId!, annotation: annotation);
                  }
                },
              ).then((value) {
                if (value != null) {
                  AnnotationEntity annotation = value as AnnotationEntity;

                  //Agregar la anotacion al bloc
                  context
                      .read<AnnotationBloc>()
                      .add(UpdateAnnotationEvent(annotation: annotation));
                }
              });
            } else if (value == 'eliminar') {
              context
                  .read<AnnotationBloc>()
                  .add(DeleteAnnotationEvent(annotation: annotation));
            }
          });
        },
      ),
    );
  }
}
