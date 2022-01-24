import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:stockbit_bibit_test/widgets/clock_painter.dart';

class Clock extends StatefulWidget {
  final int minuteClock;
  final int hourClock;
  final bool isAm;
  final double initialValue;
  final double max;
  final Function(double value) onChange;

  const Clock({
    Key? key,
    required this.minuteClock,
    required this.hourClock,
    required this.isAm,
    required this.initialValue,
    required this.max,
    required this.onChange,
  }) : super(key: key);

  @override
  State<Clock> createState() => _ClockState();
}

class _ClockState extends State<Clock> {
  int secondClock = 0;
  late Timer timer;

  setSecondClock() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      var now = DateTime.now();
      setState(() {
        secondClock = now.second;
      });
    });
  }

  @override
  void initState() {
    setSecondClock();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.zero,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            margin: EdgeInsets.zero,
            width: Get.width,
            height: Get.height,
            child: Transform.rotate(
              angle: -pi / 2,
              child: CustomPaint(
                painter: ClockPainter(
                  second: secondClock,
                  minute: widget.minuteClock,
                  hour: widget.hourClock,
                  isAM: widget.isAm,
                ),
              ),
            ),
          ),
          Container(
            width: Get.width,
            height: Get.width,
            margin: EdgeInsets.zero,
            child: SleekCircularSlider(
              initialValue: widget.initialValue,
              min: 0,
              max: widget.max,
              onChange: widget.onChange,
              appearance: CircularSliderAppearance(
                  startAngle: 270,
                  angleRange: 360,
                  size: 300,
                  customColors: CustomSliderColors(
                    shadowMaxOpacity: 0,
                    dotColor: Colors.transparent,
                    progressBarColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    trackColor: Colors.transparent,
                    dynamicGradient: false,
                  )),
              innerWidget: (value) {
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }
}
