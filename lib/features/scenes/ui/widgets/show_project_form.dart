//Formulario para agregar o editar un proyecto

import 'package:directors_cut/features/scenes/domain/entities/project_entity.dart';
import 'package:directors_cut/features/scenes/ui/bloc/projects/local/local_project_bloc.dart';
import 'package:directors_cut/features/scenes/ui/bloc/projects/local/local_project_event.dart';
import 'package:directors_cut/features/scenes/ui/bloc/projects/local/local_project_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProjectFormScreen extends StatefulWidget {
  const ProjectFormScreen({super.key, this.project});

  final ProjectEntity? project;

  @override
  State<ProjectFormScreen> createState() => _ProjectFormScreenState();
}

class _ProjectFormScreenState extends State<ProjectFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool _loading = false;

  @override
  void initState() {
    super.initState();
    if (widget.project != null) {
      _titleController.text = widget.project!.name;
      _descriptionController.text = widget.project!.description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
              widget.project == null ? 'Agregar Proyecto' : 'Editar Proyecto'),
        ),
        body: BlocConsumer<LocalProjectsBloc, LocalProjectState>(
          listener: (context, state) {
            if (state is LocalProjectsLoading) {
              //Mostrar loading
              setState(() {
                _loading = true;
              });
            }

            if (state is LocalProjectsDone) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Proyecto guardado'),
                ),
              );
              context.read<LocalProjectsBloc>().add(const GetProjectsEvent());
            }

            //Si da error
            if (state is LocalProjectsError) {
              //Mostrar error
              setState(() {
                _loading = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Error al guardar el proyecto'),
                ),
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        textCapitalization: TextCapitalization.words,
                        controller: _titleController,
                        decoration: const InputDecoration(
                          labelText: 'Titulo',
                          icon: Icon(Icons.title),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingrese un titulo';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        textCapitalization: TextCapitalization.sentences,
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                            labelText: 'Descripcion',
                            icon: Icon(Icons.description)),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingrese una descripcion';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            //Guardar proyecto
                            final project = ProjectEntity(
                              id: widget.project == null
                                  ? null
                                  : widget.project!.id,
                              name: _titleController.text,
                              description: _descriptionController.text,
                            );

                            if (widget.project == null) {
                              context
                                  .read<LocalProjectsBloc>()
                                  .add(CreateProjectEvent(project: project));
                            } else {
                              context.read<LocalProjectsBloc>().add(
                                    UpdateProjectEvent(
                                      project: project,
                                    ),
                                  );
                            }
                          }
                        },
                        child: _loading
                            ? const CircularProgressIndicator()
                            : const Text('Guardar'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
