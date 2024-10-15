import 'package:flutter/material.dart';
import 'package:go_muscu2/components/constants.dart';
import 'package:go_muscu2/components/home/floating_buttons/blur_widget.dart';
import 'package:go_muscu2/components/home/floating_buttons/chronometer.dart';
import 'package:go_muscu2/components/home/floating_buttons/current_training_button.dart';
import 'package:go_muscu2/components/home/floating_buttons/main_floating_button.dart';
import 'package:go_muscu2/providers/chronometer_provider.dart';
import 'package:go_muscu2/providers/current_workout/current_workout_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class FloatingButtons extends StatefulWidget {
  const FloatingButtons({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FloatingButtonsState createState() => _FloatingButtonsState();
}

class _FloatingButtonsState extends State<FloatingButtons>
    with TickerProviderStateMixin {
  // Main floating button is open
  bool isOpen = false;

  void openSpeedDial() {
    setState(() {
      isOpen = true;
    });
  }

  void closeSpeedDial() {
    setState(() {
      isOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Chronometer text above chronometer buttons
          Consumer<ChronometerProvider>(
            builder: (context, chronometerProvider, child) => Center(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                height: chronometerProvider.isVisible ? 40 : 0,
                // style : blur background
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(doubleRadius),
                  ),
                  color: Color.fromARGB(255, 226, 226, 226).withOpacity(0.9),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      '${chronometerProvider.minutesStr}:${chronometerProvider.secondsStr}:${chronometerProvider.millisecondsStr}',
                      style: GoogleFonts.courierPrime(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 39, 39, 39),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          // Floating buttons
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Current training button
              Consumer<CurrentWorkoutProvider>(
                builder: (context, currentTrainingProvider, child) =>
                    currentTrainingProvider.isOnTraining
                        ? const CurrentTrainingButton()
                        : const Expanded(
                            child: SizedBox(),
                          ),
              ),
              Expanded(child: Container()),
              // Chronometer
              const Chronometer(),
              Expanded(child: Container()),
              isOpen ? const BlurWidget() : const SizedBox.shrink(),
              // Main floating button
              MainFloatingButton(
                openSpeedDial: openSpeedDial,
                closeSpeedDial: closeSpeedDial,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
