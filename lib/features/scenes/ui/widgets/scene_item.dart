//Widget de item para las escenas que se muestra en la lista de escenas
//Es un listile con el orden de escena, el titulo, un icono a la izquierda que sirve para arrastrar y poder reordenar las escenas
//Ademas, al presionar el texto, el widget se transforma en un textfield para poder editar el titulo de la escena
//Y si se presiona por un tiempo largo, se muestran las opciones de eliminar, agregar nueva escena antes y despues de la escena actual

import 'package:directors_cut/features/scenes/domain/entities/scene_entity.dart';
import 'package:directors_cut/features/scenes/ui/bloc/scenes/local/bloc/local_scene_bloc.dart';
import 'package:directors_cut/features/scenes/ui/bloc/scenes/local/bloc/local_scene_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SceneItem extends StatelessWidget {
  const SceneItem({
    super.key,
    required this.scene,
    required this.isEdit,
  });

  final SceneEntity scene;
  final bool isEdit;

  @override
  Widget build(BuildContext context) {
    String nuevoTitulo = scene.name;

    return Card(
      elevation: 5,
      child: ListTile(
        key: ValueKey(scene.id),
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
        leading: isEdit
            ? ReorderableDragStartListener(
                key: ValueKey(scene.id),
                index: scene.orderId - 1,
                child: const Icon(Icons.drag_handle),
              )
            : null,
        title: Text('[${scene.id}] ${scene.name} : ${scene.orderId}',
            style: Theme.of(context).textTheme.titleLarge),
        onTap: () {
          //Abrir dialogo para cambiar el titulo de la escena
          if (isEdit) return;
          showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: const Text('Cambiar titulo'),
                content: TextField(
                  controller: TextEditingController(text: nuevoTitulo),
                  onChanged: (value) {
                    nuevoTitulo = value;
                  },
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancelar'),
                  ),
                  TextButton(
                    onPressed: () {
                      //Actualizar el titulo de la escena
                      scene.name = nuevoTitulo;

                      context.read<LocalScenesBloc>().add(
                            UpdateSceneEvent(scene: scene),
                          );

                      Navigator.pop(context);
                    },
                    child: const Text('Aceptar'),
                  ),
                ],
              );
            },
          );
        },
        onLongPress: () {
          //Mostrar opciones de eliminar, agregar escena antes y despues
          if (isEdit) return;
          showModalBottomSheet(
            context: context,
            builder: (_) {
              return Wrap(
                children: [
                  ListTile(
                    leading: const Icon(Icons.subdirectory_arrow_left),
                    title: const Text('Agregar escena antes'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.subdirectory_arrow_right),
                    title: const Text('Agregar escena despues'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.delete),
                    title: const Text('Eliminar'),
                    onTap: () {
                      //Eliminar la escena
                      context.read<LocalScenesBloc>().add(
                            DeleteSceneEvent(scene: scene),
                          );
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
