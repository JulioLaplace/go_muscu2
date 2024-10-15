import 'package:flutter/material.dart';
import 'package:go_muscu2/providers/chronometer_provider.dart';
import 'package:provider/provider.dart';

class Chronometer extends StatefulWidget {
  const Chronometer({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ChronometerState createState() => _ChronometerState();
}

class _ChronometerState extends State<Chronometer>
    with TickerProviderStateMixin {
  // -------------------- ATTRIBUTES --------------------
  // stop button
  double turns = 0.0;

  // -------------------- INIT STATE --------------------
  @override
  initState() {
    super.initState();
    Provider.of<ChronometerProvider>(context, listen: false).updateTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChronometerProvider>(
      builder: (context, chronometerProvider, child) => Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Play / Pause and Reset buttons
          Row(
            children: [
              // play / pause button
              FloatingActionButton(
                heroTag: 'play/pause Button',
                backgroundColor: Theme.of(context).colorScheme.tertiary,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (child, anim) => RotationTransition(
                    turns: child.key == const ValueKey('icon1')
                        ? Tween<double>(begin: 1, end: 0.5).animate(anim)
                        : Tween<double>(begin: 0.5, end: 1).animate(anim),
                    child: ScaleTransition(scale: anim, child: child),
                  ),
                  child: chronometerProvider.isPlaying
                      ? const Icon(
                          Icons.pause_rounded,
                          key: ValueKey('icon1'),
                          size: 30,
                        )
                      : const Icon(
                          Icons.play_arrow_rounded,
                          key: ValueKey('icon2'),
                          size: 35,
                        ),
                ),
                onPressed: () {
                  if (chronometerProvider.isPlaying) {
                    chronometerProvider.pauseTime = DateTime.now();
                  }
                  chronometerProvider
                      .setIsPlaying(!chronometerProvider.isPlaying);
                  chronometerProvider.isPlaying
                      ? chronometerProvider.setIsVisible(true)
                      : null;
                  chronometerProvider.startTimer();
                },
              ),
              const SizedBox(width: 10),

              // reset button
              FloatingActionButton(
                  heroTag: 'reset Button',
                  backgroundColor: Theme.of(context).colorScheme.error,
                  child: AnimatedRotation(
                    turns: turns,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(
                      Icons.stop_rounded,
                      size: 30,
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      turns += 0.5;
                    });
                    chronometerProvider.resetTimer();
                  }),
            ],
          ),
        ],
      ),
    );
  }
}
