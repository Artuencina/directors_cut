//Formulario para agregar una anotacion de texto
//Tiene titulo, descripcion y color
//La descripcion es de varias lineas

import 'package:directors_cut/features/scenes/domain/entities/annotation_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class TextAnnotationForm extends StatefulWidget {
  const TextAnnotationForm({super.key, required this.sceneId, this.annotation});

  final int sceneId;
  final AnnotationEntity? annotation;

  @override
  State<TextAnnotationForm> createState() => _TextAnnotationFormState();
}

class _TextAnnotationFormState extends State<TextAnnotationForm> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  Color _selectedColor = Colors.blue;

  @override
  void initState() {
    super.initState();

    //Si es una anotacion existente, cargar los datos
    if (widget.annotation != null) {
      final annotation = widget.annotation!;

      _titleController.text = annotation.title;
      _descriptionController.text = annotation.description;
      _selectedColor = Color(int.parse(annotation.color!));
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
              'Agregar anotacion de texto',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 20),

            const Text('Selecciona un color'),
            const SizedBox(height: 10),
            //Sizedbox con color que al hacer tap abre un dialogo para
            //elegir color utilizando la libreria flutter_colorpicker
            SizedBox(
              height: 50,
              child: InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Selecciona un color'),
                        content: SingleChildScrollView(
                          child: BlockPicker(
                            pickerColor: _selectedColor,
                            onColorChanged: (color) {
                              setState(() {
                                _selectedColor = color;
                              });
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Container(
                  color: _selectedColor,
                ),
              ),
            ),
            const Divider(),
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
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese una descripcion';
                }
                return null;
              },
              maxLines: 5,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final annotation = AnnotationEntity(
                        id: widget.annotation?.id,
                        title: _titleController.text,
                        sceneId: widget.sceneId,
                        orderId: widget.annotation?.orderId,
                        description: _descriptionController.text,
                        type: 'text',
                        color: _selectedColor.value.toString(),
                      );
                      //Para agregar al bloc
                      Navigator.of(context).pop(annotation);
                    }
                  },
                  child: const Text('Agregar'),
                ),
                //Boton para cancelar
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancelar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
