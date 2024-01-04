//Widget scrollable con las anotaciones de las escenas
//Que utiliza el bloc de escenas para obtener las anotaciones
//Con un listener para actualizar la lista de anotaciones
//Que escuche el currentscenebloc

import 'package:directors_cut/features/scenes/domain/entities/annotation_entity.dart';
import 'package:directors_cut/features/scenes/ui/bloc/annotations/local/bloc/annotation_bloc.dart';
import 'package:directors_cut/features/scenes/ui/bloc/scenes/local/bloc/local_scene_bloc.dart';
import 'package:directors_cut/features/scenes/ui/bloc/scenes/local/bloc/local_scene_state.dart';
import 'package:directors_cut/features/scenes/ui/widgets/annotation_item.dart';
import 'package:directors_cut/features/scenes/ui/widgets/lighting_annotation_form.dart';
import 'package:directors_cut/features/scenes/ui/widgets/song_annotation_form.dart';
import 'package:directors_cut/features/scenes/ui/widgets/song_annotation_item.dart';
import 'package:directors_cut/features/scenes/ui/widgets/text_annotation_form.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AnnotationList extends StatefulWidget {
  const AnnotationList({super.key});

  @override
  State<AnnotationList> createState() => _AnnotationListState();
}

class _AnnotationListState extends State<AnnotationList> {
  //Lista temporal para editar
  List<AnnotationEntity> annotations = [];

  //Utilizamos un player que le vamos a pasar como argumento
  //A los items de anotaciones que sean del tipo ambient
  //Para que utilicen el mismo player
  final AudioPlayer ambientPlayer = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return BlocListener<CurrentSceneBloc, CurrentSceneState>(
      listener: (context, state) {
        //Si la escena no es null, obtener las anotaciones
        if (state.scene != null) {
          context
              .read<AnnotationBloc>()
              .add(GetAnnotationsEvent(sceneId: state.scene!.id!));
        }
      },
      child: BlocBuilder<AnnotationBloc, AnnotationState>(
        builder: (context, state) {
          //Cargando
          if (state is AnnotationLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          //Error
          if (state is AnnotationError) {
            return Center(
              child: Text(state.error.toString()),
            );
          }

          //Lista de anotaciones
          if (state is AnnotationDone) {
            return ReorderableListView.builder(
              onReorder: (oldIndex, newIndex) {
                //Utilidad
                if (newIndex > state.annotations!.length) {
                  newIndex = state.annotations!.length;
                }
                if (oldIndex < newIndex) newIndex--;

                //Pasar los indices al bloc de anotaciones
                //Con el evento de reordenar
                context.read<AnnotationBloc>().add(ReorderAnnotationsEvent(
                    annotations: state.annotations!,
                    oldIndex: oldIndex,
                    newIndex: newIndex));
              },
              itemCount: state.annotations!.length,
              itemBuilder: (context, index) {
                final annotation = state.annotations![index];
                return annotation.type == 'music'
                    ? SongAnnotationItem(
                        key: ValueKey(annotation.id),
                        annotation: annotation,
                      )
                    : AnnotationItem(
                        key: ValueKey(annotation.id), annotation: annotation);
              },
              footer: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () {
                      //Obtener la escena actual del bloc
                      final scene = BlocProvider.of<CurrentSceneBloc>(context)
                          .state
                          .scene;
                      showModalBottomSheet(
                          context: context,
                          useSafeArea: true,
                          isScrollControlled: true,
                          builder: (context) {
                            //Si la escena actual es null, no se puede agregar anotacion
                            if (scene == null) {
                              return const Center(
                                child: Text('No hay escena seleccionada'),
                              );
                            }
                            return TextAnnotationForm(sceneId: scene.id!);
                          }).then((value) {
                        if (value != null) {
                          AnnotationEntity annotation =
                              value as AnnotationEntity;

                          //Agregar el orderId al valor de la anotacion
                          annotation.orderId = state.annotations!.length + 1;

                          //Agregar la anotacion al bloc
                          context.read<AnnotationBloc>().add(
                              CreateAnnotationEvent(annotation: annotation));
                        }
                      });
                    },
                    icon: const Icon(Icons.text_fields),
                  ),
                  IconButton(
                    onPressed: () {
                      //Obtener la escena actual del bloc
                      final scene = BlocProvider.of<CurrentSceneBloc>(context)
                          .state
                          .scene;
                      showModalBottomSheet(
                          context: context,
                          useSafeArea: true,
                          isScrollControlled: true,
                          builder: (context) {
                            //Si la escena actual es null, no se puede agregar anotacion
                            if (scene == null) {
                              return const Center(
                                child: Text('No hay escena seleccionada'),
                              );
                            }

                            return SongAnnotationForm(sceneId: scene.id!);
                          }).then((value) {
                        if (value != null) {
                          AnnotationEntity annotation =
                              value as AnnotationEntity;

                          //Agregar el orderId al valor de la anotacion
                          annotation.orderId = state.annotations!.length + 1;

                          //Agregar la anotacion al bloc
                          context.read<AnnotationBloc>().add(
                              CreateAnnotationEvent(annotation: annotation));
                        }
                      });
                    },
                    icon: const Icon(Icons.music_note),
                  ),
                  IconButton(
                    onPressed: () {
                      //Obtener la escena actual del bloc
                      final scene = BlocProvider.of<CurrentSceneBloc>(context)
                          .state
                          .scene;
                      showModalBottomSheet(
                          context: context,
                          useSafeArea: true,
                          isScrollControlled: true,
                          builder: (context) {
                            //Si la escena actual es null, no se puede agregar anotacion
                            if (scene == null) {
                              return const Center(
                                child: Text('No hay escena seleccionada'),
                              );
                            }

                            return LightingAnnotationForm(sceneId: scene.id!);
                          }).then((value) {
                        if (value != null) {
                          //Agregar el orderId al valor de la anotacion
                          AnnotationEntity annotation =
                              value as AnnotationEntity;

                          annotation.orderId = state.annotations!.length + 1;

                          //Agregar la anotacion al bloc
                          context.read<AnnotationBloc>().add(
                              CreateAnnotationEvent(annotation: annotation));
                        }
                      });
                    },
                    icon: const Icon(Icons.lightbulb),
                  ),
                ],
              ),
              //En el footer, mostrar tres botones para agregar anotaciones
              //De texto, musica e iluminacion
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
