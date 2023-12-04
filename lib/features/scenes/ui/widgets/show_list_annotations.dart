//Widget scrollable con las anotaciones de las escenas
//Que utiliza el bloc de escenas para obtener las anotaciones
//Con un listener para actualizar la lista de anotaciones
//Que escuche el currentscenebloc

// import 'package:directors_cut/features/scenes/ui/bloc/scenes/local/bloc/local_scene_bloc.dart';
// import 'package:directors_cut/features/scenes/ui/bloc/scenes/local/bloc/local_scene_event.dart';
// import 'package:directors_cut/features/scenes/ui/bloc/scenes/local/bloc/local_scene_state.dart';
import 'package:directors_cut/features/scenes/domain/entities/annotation_entity.dart';
import 'package:directors_cut/features/scenes/ui/bloc/annotations/local/bloc/annotation_bloc.dart';
import 'package:directors_cut/features/scenes/ui/bloc/scenes/local/bloc/local_scene_bloc.dart';
import 'package:directors_cut/features/scenes/ui/widgets/annotation_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AnnotationList extends StatelessWidget {
  const AnnotationList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnnotationBloc, AnnotationState>(
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
              onReorder: (oldIndex, newIndex) {},
              itemCount: state.annotations!.length,
              itemBuilder: (context, index) {
                final annotation = state.annotations![index];
                return AnnotationItem(
                  key: ValueKey(annotation.id),
                  annotation: annotation,
                );
              },
              //En el footer, mostrar un boton para agregar anotaciones
              //temporalmente va a agregar un dummy
              footer: ListTile(
                leading: const Icon(Icons.add),
                title: const Text('Agregar anotacion'),
                onTap: () {
                  //Agregar anotacion
                  context.read<AnnotationBloc>().add(
                        CreateAnnotationEvent(
                          annotation: AnnotationEntity(
                            sceneId: context
                                .read<CurrentSceneBloc>()
                                .state
                                .scene!
                                .id,
                            orderId: state.annotations!.length + 1,
                            title: 'Anotacion',
                            description: 'Descripcion',
                            type: 'text',
                            color: '0xFF000000',
                          ),
                        ),
                      );
                },
              ));
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
