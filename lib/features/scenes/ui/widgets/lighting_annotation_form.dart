//Formulario para agregar una anotacion de iluminacion
//Tiene selector de luces que se pueden agregar (por implementar)
//Selector de colores con flutter_colorpicker
//Tiene un switch para seleccionar si es un apagado de luces

import 'package:directors_cut/features/scenes/domain/entities/annotation_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class LightingAnnotationForm extends StatefulWidget {
  const LightingAnnotationForm(
      {super.key, required this.sceneId, this.annotation});

  final int sceneId;

  final AnnotationEntity? annotation;

  @override
  State<LightingAnnotationForm> createState() => _LightingAnnotationFormState();
}

class _LightingAnnotationFormState extends State<LightingAnnotationForm> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  Color _selectedColor = Colors.blue;
  Color _lastSelectedColor = Colors.blue;

  bool _apagon = false;
  //Selector de luces
  // List<String> _lights = [];

  @override
  void initState() {
    super.initState();

    //Si es una anotacion existente, cargar los datos
    if (widget.annotation != null) {
      final annotation = widget.annotation!;

      _titleController.text = annotation.title;
      _descriptionController.text = annotation.description;
      _selectedColor = Color(int.parse(annotation.color!));
      _lastSelectedColor = Color(int.parse(annotation.color!));
      _apagon = annotation.title == 'Apagón';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Text(
              'Agregar anotacion de iluminacion',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 20),

            const Text('Color de iluminación'),
            const SizedBox(height: 10),
            //Sizedbox con color que al hacer tap abre un dialogo para
            //seleccionar un color
            SizedBox(
              height: 50,
              child: InkWell(
                onTap: () {
                  //Si es un apagon, no se puede seleccionar color
                  if (_apagon) {
                    return;
                  }
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Selecciona un color'),
                        content: SingleChildScrollView(
                          child: ColorPicker(
                            enableAlpha: false,
                            pickerColor: _selectedColor,
                            onColorChanged: (color) {
                              setState(() {
                                _selectedColor = color;
                              });
                            },
                            pickerAreaHeightPercent: 0.8,
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Aceptar'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: _selectedColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            //Selector de luces

            //Switch para seleccionar si es un apagado de luces
            Row(
              children: [
                const Text('Apagado de luces'),
                Switch(
                  value: _apagon,
                  onChanged: (value) {
                    setState(() {
                      _apagon = value;

                      if (_apagon) {
                        _titleController.text = 'Apagón';
                        _lastSelectedColor = _selectedColor;
                        _selectedColor = Colors.black;
                      } else {
                        _titleController.text = '';
                        _selectedColor = _lastSelectedColor;
                      }
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            //titulo y descripcion
            TextFormField(
              textCapitalization: TextCapitalization.sentences,
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Titulo',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese un titulo';
                }
                return null;
              },
            ),

            TextFormField(
              textCapitalization: TextCapitalization.sentences,
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Descripcion',
              ),
              maxLines: 5,
            ),

            const SizedBox(height: 20),

            //Boton para agregar la anotacion
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      //Crear la anotacion
                      final annotation = AnnotationEntity(
                        id: widget.annotation?.id,
                        title: _titleController.text,
                        description: _descriptionController.text,
                        sceneId: widget.sceneId,
                        type: 'lighting',
                        color: _selectedColor.value.toString(),
                      );

                      Navigator.of(context).pop(annotation);
                    }
                  },
                  child: const Text('Agregar'),
                ),

                //Boton para cancelar
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancelar'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
