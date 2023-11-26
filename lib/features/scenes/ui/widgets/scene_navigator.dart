//Navegador para las escenas de un proyecto
//Tiene el titulo de la escena en el medio, y dos botones a los costados
//para navegar entre escenas, que desaparecen cuando se llega al final
//o al principio de la lista de escenas

import 'package:directors_cut/features/scenes/domain/entities/scene_entity.dart';
import 'package:directors_cut/features/scenes/ui/bloc/scenes/local/bloc/local_scene_bloc.dart';
import 'package:directors_cut/features/scenes/ui/bloc/scenes/local/bloc/local_scene_event.dart';
import 'package:directors_cut/features/scenes/ui/bloc/scenes/local/bloc/local_scene_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SceneNavigator extends StatefulWidget {
  const SceneNavigator({super.key});

  @override
  State<SceneNavigator> createState() => _SceneNavigatorState();
}

class _SceneNavigatorState extends State<SceneNavigator> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade300,
      child: BlocBuilder<LocalScenesBloc, LocalSceneState>(
        builder: (context, state) {
          if (state is LocalScenesDone) {
            final scenes = state.scenes;
            final currentScene = state.currentScene;
            final index = scenes!.indexOf(currentScene!);

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (index != 0)
                  IconButton(
                    onPressed: () {
                      context.read<LocalScenesBloc>().add(
                            const ChangeToPreviousSceneEvent(),
                          );
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                Text(
                  currentScene.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (index != scenes.length - 1)
                  IconButton(
                    onPressed: () {
                      context.read<LocalScenesBloc>().add(
                            const ChangeToNextSceneEvent(),
                          );
                    },
                    icon: const Icon(Icons.arrow_forward),
                  ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
