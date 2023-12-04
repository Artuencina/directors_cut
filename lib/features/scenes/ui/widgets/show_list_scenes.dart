//Pagina para ver todas las escenas de un proyecto como listtiles
//Y poder crear, modificar, eliminar, reordenar y ver las escenas

import 'package:directors_cut/features/scenes/domain/entities/scene_entity.dart';
import 'package:directors_cut/features/scenes/ui/bloc/scenes/local/bloc/local_scene_bloc.dart';
import 'package:directors_cut/features/scenes/ui/bloc/scenes/local/bloc/local_scene_event.dart';
import 'package:directors_cut/features/scenes/ui/bloc/scenes/local/bloc/local_scene_state.dart';
import 'package:directors_cut/features/scenes/ui/widgets/scene_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListScenesScreen extends StatefulWidget {
  const ListScenesScreen({super.key, required this.idProyecto});

  final int? idProyecto;

  @override
  State<ListScenesScreen> createState() => _ListScenesScreenState();
}

class _ListScenesScreenState extends State<ListScenesScreen> {
  //El modo edición es para poder reordenar las escenas
  bool isEdit = false;

  //Para poder reordenar las escenas, se crea una lista temporal
  List<SceneEntity> scenes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Escenas'),
          elevation: 3,
          actions: [
            //Boton para cancelar la edición
            isEdit
                ? IconButton(
                    onPressed: () {
                      //Cancelar la edición
                      setState(() {
                        isEdit = false;
                        //Vaciar la lista temporal
                        scenes = [];
                      });
                    },
                    icon: const Icon(
                      Icons.close,
                    ),
                  )
                : const SizedBox(),
            //Boton para cambiar el modo de edición
            IconButton(
              onPressed: () {
                //Cambiar el modo de edición
                setState(() {
                  isEdit = !isEdit;
                });

                //Si se desactiva el modo edición, actualizar el orden de las escenas
                if (isEdit) {
                  //Guardar el orden de las escenas en la lista temporal
                  scenes =
                      context.read<LocalScenesBloc>().state.scenes!.toList();
                } else {
                  //Actualizar el orden de las escenas si hay al menos una escena
                  if (scenes.isNotEmpty) {
                    //Actualizar el orden de las escenas locales
                    //De modo que el orderId coincida con el indice de la lista + 1
                    for (var i = 0; i < scenes.length; i++) {
                      scenes[i].orderId = i + 1;
                    }

                    context.read<LocalScenesBloc>().add(
                          UpdateScenesEvent(scenes: scenes),
                        );
                  }
                }
              },
              icon: Icon(
                isEdit ? Icons.check : Icons.edit,
              ),
            ),
          ],
        ),
        body:
            BlocBuilder<LocalScenesBloc, LocalSceneState>(builder: (_, state) {
          if (state is LocalScenesLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is LocalScenesDone) {
            return isEdit
                //Si es edición, mostrar las escenas en un reorderablelistview
                //Y actualizar la lista de escenas temporales
                ? ReorderableListView.builder(
                    onReorder: (oldIndex, newIndex) {
                      //Utilidad
                      if (newIndex > scenes.length) {
                        newIndex = scenes.length;
                      }
                      if (oldIndex < newIndex) newIndex--;

                      //Actualizar el orden de las escenas
                      setState(() {
                        final scene = scenes[oldIndex];
                        scenes.removeAt(oldIndex);
                        scenes.insert(newIndex, scene);
                      });
                    },
                    itemCount: scenes.length,
                    itemBuilder: (_, index) {
                      return SceneItem(
                        key: ValueKey(scenes[index].id),
                        scene: scenes[index],
                        isEdit: isEdit,
                      );
                    },
                  )
                //Si no es edición, mostrar las escenas en un listview normal
                : ListView.builder(
                    itemCount: state.scenes!.length + 1,
                    itemBuilder: (_, index) {
                      //El ultimo elemento es el boton para agregar una escena
                      return index == state.scenes!.length
                          ? ListTile(
                              key: const ValueKey('add'),
                              leading: const Icon(Icons.add),
                              title: const Text('Agregar escena'),
                              titleAlignment: ListTileTitleAlignment.center,
                              onTap: () {
                                //Agregar nueva escena
                                final scene = SceneEntity(
                                  name: '',
                                  projectId: widget.idProyecto,
                                  orderId: state.scenes!.length + 1,
                                );
                                context
                                    .read<LocalScenesBloc>()
                                    .add(CreateSceneEvent(scene: scene));
                              },
                            )
                          : SceneItem(
                              key: ValueKey(state.scenes![index].id),
                              scene: state.scenes![index],
                              isEdit: isEdit,
                            );
                    },
                  );
          }

          return const Center(child: Text('Error'));
        }));
  }
}
