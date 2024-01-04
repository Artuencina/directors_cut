//Item de cancion para una escena
//Item de anotacion para una escena
//Puede ser texto, musica o iluminacion

import 'package:directors_cut/features/scenes/domain/entities/annotation_entity.dart';
import 'package:directors_cut/features/scenes/ui/bloc/annotations/local/bloc/annotation_bloc.dart';
import 'package:directors_cut/features/scenes/ui/widgets/audio_player.dart';
import 'package:directors_cut/features/scenes/ui/widgets/song_annotation_form.dart';
import 'package:directors_cut/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';

class SongAnnotationItem extends StatefulWidget {
  final AnnotationEntity annotation;
  const SongAnnotationItem({
    Key? key,
    required this.annotation,
  }) : super(key: key);

  @override
  State<SongAnnotationItem> createState() => _SongAnnotationItemState();
}

class _SongAnnotationItemState extends State<SongAnnotationItem> {
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    //Cargar el archivo de audio
    _audioPlayer.setAudioSource(AudioSource.file(widget.annotation.url!));
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  //Botones de play/pause y stop
  Widget _playerButton(PlayerState playerState, Color iconColor) {
    final proccesingState = playerState.processingState;

    //Cambiar de estado segun el estado del reproductor
    //Si esta cargando, mostrar un icono de cargando
    if (proccesingState == ProcessingState.loading ||
        _audioPlayer.processingState == ProcessingState.buffering) {
      return const CircularProgressIndicator();
    }

    if (_audioPlayer.playing != true ||
        proccesingState == ProcessingState.idle) {
      return IconButton(
          onPressed: () {
            _audioPlayer.play();
          },
          icon: Icon(Icons.play_arrow, color: iconColor));
    } else if (proccesingState == ProcessingState.completed) {
      return IconButton(
          onPressed: () {
            _audioPlayer.seek(Duration.zero);
          },
          icon: Icon(Icons.replay, color: iconColor));
    } else {
      return IconButton(
          onPressed: () {
            //El reproductor que se pausa es el de ambiente o el personal de efecta
            _audioPlayer.pause();
          },
          icon: Icon(Icons.pause, color: iconColor));
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color textColor =
        Color(int.parse(widget.annotation.color!)).computeLuminance() < 0.5
            ? Colors.white
            : Colors.black;
    return Card(
      key: ValueKey(widget.annotation.id),
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      //Utilizar el color de la anotacion, que esta en string
      color: Color(int.parse(widget.annotation.color!)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
            leading: ReorderableDragStartListener(
              key: ValueKey(widget.annotation.id),
              index: widget.annotation.orderId! - 1,
              child: const Icon(Icons.drag_handle),
            ),
            //El icono final es un boton de play/pause y otro de stop
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      _audioPlayer.stop();
                      _audioPlayer.seek(Duration.zero);
                    });
                  },
                  icon: Icon(
                    Icons.stop,
                    color: textColor,
                    size: 30,
                  ),
                ),
                StreamBuilder<PlayerState>(
                  stream: _audioPlayer.playerStateStream,
                  builder: (context, snapshot) {
                    final playerState = snapshot.data;
                    //Si el estado es null, no mostrar nada
                    if (playerState == null) {
                      return const SizedBox.shrink();
                    } else {
                      return _playerButton(playerState, textColor);
                    }
                  },
                ),
              ],
            ),
            title: Text(
              widget.annotation.title,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: textColor),
            ),
            subtitle: widget.annotation.description.isNotEmpty
                ? Text(
                    widget.annotation.description,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: textColor),
                  )
                : null,
            onTap: () => {
              //Abrir modal de player
              showModalBottomSheet(
                context: context,
                useSafeArea: true,
                isScrollControlled: true,
                builder: (context) {
                  return BlocProvider<AnnotationBloc>(
                    create: (context) => sl(),
                    child: AudioPlayerScreen(
                        audioPlayer: _audioPlayer,
                        annotation: widget.annotation),
                  );
                },
              )
            },
            onLongPress: () {
              //Abrir un modalbotomsheet donde pregunta si se quiere editar
              //Agregar un pie de anotacion
              //O eliminar la anotacion
              showModalBottomSheet(
                  context: context,
                  builder: (context) => Wrap(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.edit),
                            title: const Text('Editar'),
                            onTap: () => Navigator.of(context).pop('editar'),
                          ),
                          ListTile(
                            leading: const Icon(Icons.delete),
                            title: const Text('Eliminar'),
                            onTap: () => Navigator.of(context).pop('eliminar'),
                          ),
                        ],
                      )).then((value) {
                if (value == 'editar') {
                  showModalBottomSheet(
                    context: context,
                    useSafeArea: true,
                    isScrollControlled: true,
                    builder: (context) {
                      //Abrir el formulario segun el tipo de anotacion

                      return SongAnnotationForm(
                          sceneId: widget.annotation.sceneId!,
                          annotation: widget.annotation);
                    },
                  ).then((value) {
                    if (value != null) {
                      AnnotationEntity annotation = value as AnnotationEntity;

                      //Agregar la anotacion al bloc
                      context
                          .read<AnnotationBloc>()
                          .add(UpdateAnnotationEvent(annotation: annotation));

                      setState(() {
                        //Cambiar el audio source del reproductor
                        _audioPlayer.stop();
                        _audioPlayer
                            .setAudioSource(AudioSource.file(annotation.url!));
                      });
                    }
                  });
                } else if (value == 'eliminar') {
                  context.read<AnnotationBloc>().add(
                      DeleteAnnotationEvent(annotation: widget.annotation));
                }
              });
            },
          ),
          //Indicador de progreso de la cancion
          //Si hay una cancion, mostrar el indicador de progreso
          //Si no hay una cancion, no mostrar nada
          StreamBuilder<PlayerState>(
              stream: _audioPlayer.playerStateStream,
              builder: (context, snapshot) {
                final playerState = snapshot.data;
                //Si el estado es null, no mostrar nada
                if (playerState == null ||
                    playerState.processingState == ProcessingState.idle) {
                  return const SizedBox.shrink();
                } else {
                  final processingState = playerState.processingState;
                  //Si el estado es null, no mostrar nada
                  if (processingState == ProcessingState.loading ||
                      processingState == ProcessingState.buffering) {
                    return const SizedBox.shrink();
                  } else {
                    return StreamBuilder<Duration?>(
                        stream: _audioPlayer.positionStream,
                        builder: (context, snapshot) {
                          final position = snapshot.data ?? Duration.zero;
                          final duration =
                              _audioPlayer.duration ?? Duration.zero;
                          return LinearProgressIndicator(
                            value: position.inMilliseconds /
                                duration.inMilliseconds,
                            color: textColor,
                            backgroundColor: textColor.withOpacity(0.3),
                          );
                        });
                  }
                }
              })
        ],
      ),
    );
  }
}
