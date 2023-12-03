//Pagina de escenas

/* 
- Contiene un paginador para cambiar la escena actual
 - Al cambiar la escena actual obtiene todas las anotaciones

- El paginador, a la izquierda tiene un boton para retroceder,
a la derecha de avanzar y en el centro el numero de la escena actual,
que al presionarlo muestra un dialogo para cambiar la escena actual

- En el appbar se tienen tres botones, uno para crear una nueva escena, otro para eliminar la escena actual y uno para mirar todas las escenas
*/

import 'package:directors_cut/features/scenes/ui/bloc/projects/local/local_project_bloc.dart';
import 'package:directors_cut/features/scenes/ui/bloc/scenes/local/bloc/local_scene_bloc.dart';
import 'package:directors_cut/features/scenes/ui/bloc/scenes/local/bloc/local_scene_event.dart';
import 'package:directors_cut/features/scenes/ui/bloc/scenes/local/bloc/local_scene_state.dart';
import 'package:directors_cut/features/scenes/ui/widgets/scene_navigator.dart';
import 'package:directors_cut/features/scenes/ui/widgets/show_list_scenes.dart';
import 'package:directors_cut/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SceneSceen extends StatelessWidget {
  const SceneSceen({super.key, required this.idProyecto});

  final int? idProyecto;

  @override
  Widget build(BuildContext context) {
    //Obtener titulo del proyecto con el id
    String? tituloProyecto = context
        .read<LocalProjectsBloc>()
        .state
        .projects
        ?.firstWhere((element) => element.id == idProyecto)
        .name;

    return Scaffold(
      appBar: _buildAppBar(context, tituloProyecto, idProyecto),
      body: BlocBuilder<LocalScenesBloc, LocalSceneState>(builder: (_, state) {
        if (state is LocalScenesLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is LocalScenesError) {
          return const Center(
            child: IconButton(
              icon: Icon(Icons.refresh),
              onPressed: null,
            ),
          );
        }

        if (state is LocalScenesDone) {
          return state.scenes!.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('No hay escenas', style: TextStyle(fontSize: 20)),
                      SizedBox(height: 20),
                      //Mostrar el icono de agregar escena
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Pulsa en '),
                          Icon(Icons.list),
                          Text(' para agregar una escena')
                        ],
                      )
                    ],
                  ),
                )
              : const Column(
                  children: [SceneNavigator()],
                );
        }

        return const Center(
          child: Text('Error'),
        );
      }),
    );
  }
}

_buildAppBar(BuildContext context, String? tituloProyecto, int? idProyecto) {
  return AppBar(
    title: Text(tituloProyecto ?? 'Sin titulo'),
    actions: [
      IconButton(
        onPressed: () {
          //Abrir pagina para ver todas las escenas
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<LocalScenesBloc>(),
                child: ListScenesScreen(idProyecto: idProyecto),
              ),
            ),
          );
        },
        icon: const Icon(Icons.list),
      ),
    ],
  );
}
