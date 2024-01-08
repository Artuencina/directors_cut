//Formulario para agregar una cancion
//Color
//Archivo de audio, entrada y salida
//Tipo de reproduccion (loop, play_once)
//Tipo de sonido (ambiente, efecto)
//Volumen
//titulo y descripcion

import 'dart:io';

import 'package:directors_cut/features/scenes/domain/entities/annotation_entity.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class SongAnnotationForm extends StatefulWidget {
  const SongAnnotationForm({super.key, required this.sceneId, this.annotation});

  final int sceneId;
  final AnnotationEntity? annotation;

  @override
  State<SongAnnotationForm> createState() => _SongAnnotationFormState();
}

class _SongAnnotationFormState extends State<SongAnnotationForm> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  Color _selectedColor = Colors.blue;

  //Archivo de audio
  String? _url;

  //Tipo de reproduccion (loop, play_once)
  bool _loop = false;

  //Tipo de sonido (ambiente, efecto)
  bool _ambient = false;

  //Volumen
  int _volume = 100;

  @override
  void initState() {
    super.initState();
    if (widget.annotation != null) {
      _titleController.text = widget.annotation!.title;
      _descriptionController.text = widget.annotation!.description;
      _selectedColor = Color(int.parse(widget.annotation!.color!));
      _url = widget.annotation!.url;
      _loop = widget.annotation!.playType == 'loop';
      _ambient = widget.annotation!.soundType == 'ambient';
      _volume = widget.annotation!.volume!;
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
              widget.annotation == null
                  ? 'Agregar anotacion de audio'
                  : 'Editar anotacion de audio',
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
                            },
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

            //Para elegir el audio vamos a utilizar un filepicker
            //O un textformfield para ingresar la url

            //Boton para elegir archivo de audio
            ElevatedButton.icon(
              icon: const Icon(Icons.music_note),
              onPressed: () async {
                //Abrir el filepicker
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                    allowMultiple: false,
                    type: FileType.audio,
                    //allowedExtensions: ['mp3', 'wav', 'ogg', 'aac'],
                    dialogTitle: 'Selecciona un archivo de audio');

                if (result != null) {
                  File file = File(result.files.single.path!);

                  setState(() {
                    _url = file.path;
                  });
                } else {
                  // User canceled the picker
                }
              },
              label: const Text('Seleccionar archivo de audio'),
            ),
            //Mostrar el nombre del archivo seleccionado
            if (_url != null)
              Text(
                //Mostrar solo el nombre del archivo
                _url!.split('/').last,
                overflow: TextOverflow.ellipsis,
              ),

            const SizedBox(height: 20),

            //Tipo de sonido (ambiente, efecto)
            Row(
              children: [
                const Text('Sonido de ambiente'),
                const SizedBox(width: 20),
                Switch(
                  value: _ambient,
                  onChanged: (value) {
                    setState(() {
                      _ambient = value;
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 20),

            //Volumen
            Row(
              children: [
                const Text('Volumen'),
                const SizedBox(width: 20),
                Expanded(
                  child: Slider(
                    value: _volume.toDouble(),
                    min: 0,
                    max: 100,
                    divisions: 100,
                    label: _volume.toString(),
                    onChanged: (value) {
                      setState(() {
                        _volume = value.toInt();
                      });
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            //Boton para agregar anotacion
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  //Agregar anotacion
                  final annotation = AnnotationEntity(
                    id: widget.annotation?.id,
                    title: _titleController.text,
                    sceneId: widget.sceneId,
                    orderId: widget.annotation?.orderId,
                    description: _descriptionController.text,
                    type: 'music',
                    color: _selectedColor.value.toString(),
                    url: _url,
                    soundType: _ambient ? 'ambient' : 'effect',
                    playType: _loop ? 'loop' : 'play_once',
                    volume: _volume,
                  );
                  //Para agregar al bloc
                  Navigator.of(context).pop(annotation);
                }
              },
              child: widget.annotation == null
                  ? const Text('Agregar anotacion')
                  : const Text('Editar anotacion'),
            ),
          ],
        ),
      ),
    );
  }
}
