//Barra de progreso de la cancion que permite ver y mover la posicion
//de la cancion

import 'package:flutter/material.dart';

class SeekBar extends StatefulWidget {
  const SeekBar({
    Key? key,
    required this.duration,
    required this.position,
    required this.onChangeEnd,
  }) : super(key: key);

  final Duration duration;
  final Duration position;
  final ValueChanged<Duration> onChangeEnd;

  @override
  SeekBarState createState() => SeekBarState();
}

class SeekBarState extends State<SeekBar> {
  double? _dragValue;

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: const SliderThemeData(
        trackHeight: 2,
        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6),
        overlayShape: RoundSliderOverlayShape(overlayRadius: 14),
      ),
      child: Slider(
        min: 0.0,
        max: widget.duration.inMilliseconds.toDouble(),
        value: _dragValue ?? widget.position.inMilliseconds.toDouble(),
        onChanged: (value) {
          setState(() {
            _dragValue = value;
          });
        },
        onChangeEnd: (value) {
          widget.onChangeEnd(Duration(milliseconds: value.round()));
          setState(() {
            _dragValue = null;
          });
        },
      ),
    );
  }
}
