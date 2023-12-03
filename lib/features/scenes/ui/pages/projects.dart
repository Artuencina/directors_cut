//Vista de los projectos en grid view

import 'package:directors_cut/features/scenes/ui/bloc/projects/local/local_project_bloc.dart';
import 'package:directors_cut/features/scenes/ui/bloc/projects/local/local_project_event.dart';
import 'package:directors_cut/features/scenes/ui/bloc/projects/local/local_project_state.dart';
import 'package:directors_cut/features/scenes/ui/bloc/scenes/local/bloc/local_scene_bloc.dart';
import 'package:directors_cut/features/scenes/ui/bloc/scenes/local/bloc/local_scene_event.dart';
import 'package:directors_cut/features/scenes/ui/bloc/scenes/local/bloc/local_scene_state.dart';
import 'package:directors_cut/features/scenes/ui/pages/scenes.dart';
import 'package:directors_cut/features/scenes/ui/widgets/show_project_form.dart';
import 'package:directors_cut/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProjectScreen extends StatelessWidget {
  const ProjectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }

  _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Proyectos'),
      //Boton de agregar proyecto
      actions: [
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            //Abrir el modal para agregar proyecto
            showModalBottomSheet(
              context: context,
              useSafeArea: true,
              isScrollControlled: true,
              builder: (_) {
                return const ProjectFormScreen();
              },
            );
          },
        ),
      ],
    );
  }

  _buildBody(BuildContext context) {
    //Vista de grilla para mostrar los proyectos
    return BlocBuilder<LocalProjectsBloc, LocalProjectState>(
      builder: (_, state) {
        //Cargando
        if (state is LocalProjectsLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        //Error
        if (state is LocalProjectsError) {
          //Mostrar Iconbutton refresh
          return const Center(
            child: IconButton(
              icon: Icon(Icons.refresh),
              onPressed: null,
            ),
          );
        }

        //Mostrar grilla de proyectos
        if (state is LocalProjectsDone) {
          return state.projects!.isEmpty
              ? const Center(
                  child: Text('No hay proyectos'),
                )
              : ListView.builder(
                  itemCount: state.projects!.length,
                  itemBuilder: (_, index) {
                    final project = state.projects![index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 5),
                      child: InkWell(
                        splashColor: Colors.indigo,
                        onTap: () {
                          //Abrir la pantalla de escenas de ese proyecto
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) {
                                //
                                return MultiBlocProvider(
                                  providers: [
                                    //Providers para las escenas
                                    BlocProvider<LocalScenesBloc>(
                                      create: (context) => sl()
                                        ..add(GetScenesEvent(
                                            projectId: project.id.toString())),
                                    ),
                                    //Providers para la escena actual
                                    BlocProvider<CurrentSceneBloc>(
                                      create: (context) => sl(),
                                    ),
                                  ],
                                  child: BlocListener<LocalScenesBloc,
                                      LocalSceneState>(
                                    listener: (context, state) {
                                      if (state is LocalScenesDone) {
                                        //Si hay escenas, establecer la primera como la escena actual
                                        if (state.scenes!.isNotEmpty) {
                                          context.read<CurrentSceneBloc>().add(
                                              ChangeCurrentSceneEvent(
                                                  scene: state.scenes![0]));
                                        }
                                      }
                                    },
                                    child: SceneSceen(
                                      idProyecto: project.id,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                        child: ListTile(
                          key: ValueKey(project.id),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          tileColor: Theme.of(context).cardTheme.color,

                          leading: const Icon(Icons.movie, size: 40),
                          //A la derecha ponemos un boton que despliega las opciones
                          //de editar y eliminar
                          trailing: PopupMenuButton(
                            itemBuilder: (_) {
                              return [
                                const PopupMenuItem(
                                  value: 'edit',
                                  child: Text('Editar'),
                                ),
                                const PopupMenuItem(
                                  value: 'delete',
                                  child: Text('Eliminar'),
                                ),
                              ];
                            },
                            onSelected: (value) {
                              if (value == 'edit') {
                                //Abrir el modal para editar proyecto
                                showModalBottomSheet(
                                  context: context,
                                  useSafeArea: true,
                                  isScrollControlled: true,
                                  builder: (_) {
                                    return ProjectFormScreen(
                                      project: project,
                                    );
                                  },
                                );
                              } else if (value == 'delete') {
                                //Eliminar proyecto
                                //Mostrar dialogo de confirmacion
                                showDialog(
                                  context: context,
                                  builder: (_) {
                                    return AlertDialog(
                                      title: const Text('Eliminar proyecto'),
                                      content: const Text(
                                          '¿Está seguro que desea eliminar el proyecto?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            //Cerrar dialogo
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Cancelar'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            //Eliminar proyecto
                                            context
                                                .read<LocalProjectsBloc>()
                                                .add(DeleteProjectEvent(
                                                    project: project));
                                            //Cerrar dialogo
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Eliminar'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                          ),
                          title: Text(project.name),
                          subtitle: Text(project.description),
                        ),
                      ),
                    );
                  },
                );
        }

        //Si no es ninguno de los anteriores, no mostrar nada
        return const SizedBox();
      },
    );
  }
}
