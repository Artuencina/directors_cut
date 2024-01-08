//Navegador para las escenas de un proyecto
//Tiene el titulo de la escena en el medio, y dos botones a los costados
//para navegar entre escenas, que desaparecen cuando se llega al final
//o al principio de la lista de escenas

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
      //Leer la escena actual de su bloc
      child: BlocListener<LocalScenesBloc, LocalSceneState>(
        listener: (context, state) {
          //Si hay un cambio de escenas, recargar
          if (state is LocalScenesDone) {
            setState(() {});
          }
        },
        child: BlocBuilder<CurrentSceneBloc, CurrentSceneState>(
          builder: (context, state) {
            //Si la escena es  null, mostrar un contenedor vacio
            return (state is CurrentSceneNone || state.scene == null)
                ? const SizedBox(
                    height: 10,
                  )
                : Wrap(
                    runAlignment: WrapAlignment.center,
                    alignment: WrapAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //Boton para ir a la escena anterior

                          IconButton(
                            onPressed: state.scene!.orderId > 1
                                ? () {
                                    context.read<CurrentSceneBloc>().add(
                                          PreviousSceneEvent(
                                            context
                                                .read<LocalScenesBloc>()
                                                .state
                                                .scenes!,
                                          ),
                                        );
                                  }
                                : null,
                            icon: const Icon(Icons.arrow_back_ios),
                          ),
                          //Titulo de la escena actual
                          Text(
                            'Escena ${state.scene!.orderId}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          //Boton para ir a la escena siguiente

                          IconButton(
                            onPressed: state.scene!.orderId <
                                    context
                                        .read<LocalScenesBloc>()
                                        .state
                                        .scenes!
                                        .length
                                ? () {
                                    context.read<CurrentSceneBloc>().add(
                                          NextSceneEvent(
                                            context
                                                .read<LocalScenesBloc>()
                                                .state
                                                .scenes!,
                                          ),
                                        );
                                  }
                                : null,
                            icon: const Icon(Icons.arrow_forward_ios),
                          )
                        ],
                      ),
                      Text(state.scene!.name,
                          style: Theme.of(context).textTheme.titleMedium),
                    ],
                  );
          },
        ),
      ),
    );
  }
}
