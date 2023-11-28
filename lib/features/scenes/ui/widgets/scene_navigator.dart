//Navegador para las escenas de un proyecto
//Tiene el titulo de la escena en el medio, y dos botones a los costados
//para navegar entre escenas, que desaparecen cuando se llega al final
//o al principio de la lista de escenas

import 'package:directors_cut/features/scenes/ui/bloc/scenes/local/bloc/local_scene_bloc.dart';
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
      //Leer la escena actual de su bloc
      child: BlocBuilder<CurrentSceneBloc, CurrentSceneState>(
        builder: (context, state) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //Boton para ir a la escena anterior
              if (state.scene!.id! > 1)
                IconButton(
                  onPressed: () {
                    //  context.read<CurrentSceneBloc>().add(
                    //        PreviousSceneEvent(
                    //          state.scene!.id! - 1,
                    //        ),
                    //      );
                  },
                  icon: const Icon(Icons.arrow_back_ios),
                ),
              //Titulo de la escena actual
              Text(
                state.scene!.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              //Boton para ir a la escena siguiente
              if (state.scene!.id! <
                  context.read<LocalScenesBloc>().state.scenes!.length)
                IconButton(
                  onPressed: () {
                    //  context.read<CurrentSceneBloc>().add(
                    //        NextSceneEvent(
                    //          state.scene!.id! + 1,
                    //        ),
                    //      );
                  },
                  icon: const Icon(Icons.arrow_forward_ios),
                ),
            ],
          );
        },
      ),
    );
  }
}
