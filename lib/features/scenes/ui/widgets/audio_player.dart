//Vista que contiene los controles de audio
//Play/pause, stop, volumen, loop,
//Y una barra de progreso para ver e ir a una posicion especifica

import 'package:directors_cut/features/scenes/domain/entities/annotation_entity.dart';
import 'package:directors_cut/features/scenes/ui/bloc/annotations/local/bloc/annotation_bloc.dart';
import 'package:directors_cut/features/scenes/ui/widgets/seekbar.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerScreen extends StatelessWidget {
  const AudioPlayerScreen(
      {super.key, required AudioPlayer audioPlayer, required this.annotation})
      : _audioPlayer = audioPlayer;

  final AudioPlayer _audioPlayer;
  final AnnotationEntity annotation;

  //Botones de play/pause y stop
  Widget _playerButton(PlayerState playerState, Color iconColor) {
    final proccesingState = playerState.processingState;
    print(proccesingState);

    //Cambiar de estado segun el estado del reproductor
    //Si esta cargando, mostrar un icono de cargando
    if (_audioPlayer.processingState == ProcessingState.loading ||
        _audioPlayer.processingState == ProcessingState.buffering) {
      return const CircularProgressIndicator();
    }

    if (_audioPlayer.playing != true ||
        proccesingState == ProcessingState.idle) {
      return IconButton(
          onPressed: () {
            _audioPlayer.play();
          },
          icon: Icon(
            Icons.play_arrow,
            color: iconColor,
            size: 40,
          ));
    } else if (proccesingState == ProcessingState.completed) {
      return IconButton(
          onPressed: () {
            _audioPlayer.seek(Duration.zero);
          },
          icon: Icon(
            Icons.replay,
            color: iconColor,
            size: 40,
          ));
    } else {
      return IconButton(
          onPressed: () {
            _audioPlayer.pause();
          },
          icon: Icon(
            Icons.pause,
            color: iconColor,
            size: 40,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(annotation.title),
      ),
      body: Column(
        children: [
          const Spacer(),
          //Icono de nota musical, abajo el titulo y la descripcion
          const Icon(Icons.music_note, size: 150, color: Colors.grey),
          Text(
            annotation.title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Text(
            annotation.description,
            style: Theme.of(context).textTheme.bodyLarge,
          ),

          const Spacer(),
          //Botones de play/pause y stop
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //Boton de fundido
              IconButton(
                  onPressed: () {
                    //TODO: Fade in y fade out
                  },
                  icon: const Icon(
                    Icons.music_off_outlined,
                    color: Colors.black,
                    size: 40,
                  )),
              //Loop
              StreamBuilder<LoopMode>(
                stream: _audioPlayer.loopModeStream,
                builder: (context, snapshot) {
                  final loop = snapshot.data ?? LoopMode.off;
                  return IconButton(
                      onPressed: () {
                        loop == LoopMode.one
                            ? _audioPlayer.setLoopMode(LoopMode.off)
                            : _audioPlayer.setLoopMode(LoopMode.one);
                        //Actualizar el bloc de la anotacion
                        annotation.playType =
                            loop == LoopMode.one ? 'loop' : 'play_once';
                        BlocProvider.of<AnnotationBloc>(context)
                            .add(UpdateAnnotationEvent(annotation: annotation));
                      },
                      icon: loop == LoopMode.one
                          ? const Icon(
                              Icons.loop,
                              color: Colors.black,
                              size: 40,
                            )
                          : const Icon(
                              Icons.arrow_forward,
                              color: Colors.black,
                              size: 40,
                            ));
                },
              ),
              StreamBuilder<PlayerState>(
                  stream: _audioPlayer.playerStateStream,
                  builder: (context, snapshot) {
                    final playerState = snapshot.data;
                    //Si el estado es null, no mostrar nada
                    if (playerState == null) {
                      return const SizedBox.shrink();
                    } else {
                      return _playerButton(playerState, Colors.black);
                    }
                  }),
              IconButton(
                onPressed: () {
                  _audioPlayer.stop();
                  _audioPlayer.seek(Duration.zero);
                },
                icon: const Icon(
                  Icons.stop,
                  size: 40,
                ),
              ),
              //Boton para abrir el selector de volumen
              IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              title: Text(
                                'Volumen',
                                textAlign: TextAlign.center,
                              ),
                            ),
                            ListTile(
                              title: StreamBuilder<double>(
                                stream: _audioPlayer.volumeStream,
                                builder: (context, snapshot) {
                                  final volume = snapshot.data ?? 0;
                                  return Slider(
                                    value: volume,
                                    min: 0,
                                    max: 1.0,
                                    onChanged: (value) {
                                      _audioPlayer.setVolume(value);
                                    },
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 30),
                          ],
                        );
                      },
                    );
                  },
                  icon: const Icon(
                    Icons.volume_up,
                    color: Colors.black,
                    size: 40,
                  )),
            ],
          ),
          //Barra de progreso
          StreamBuilder<Duration?>(
            stream: _audioPlayer.durationStream,
            builder: (context, snapshot) {
              final duration = snapshot.data ?? Duration.zero;
              return StreamBuilder<Duration>(
                stream: _audioPlayer.positionStream,
                builder: (context, snapshot) {
                  var position = snapshot.data ?? Duration.zero;
                  if (position > duration) {
                    position = duration;
                  }
                  return SeekBar(
                    duration: duration,
                    position: position,
                    onChangeEnd: (newPosition) {
                      _audioPlayer.seek(newPosition);
                    },
                  );
                },
              );
            },
          ),

          //En un row vamos a poner dos textos indicando el inicio y el final de la cancion

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '00:00',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Text(
                  '${_audioPlayer.duration!.inMinutes}:${(_audioPlayer.duration!.inSeconds % 60).toString().padLeft(2, '0')}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
