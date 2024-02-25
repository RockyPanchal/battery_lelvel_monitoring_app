import 'package:flutter/material.dart';
import 'battery_display_painter.dart';

class BatteryIndicator extends StatelessWidget {

  /// widget`s width / height , default to 2.5：1
  final double ratio;

  /// color of borderline , and fill color when colorful is false
  final Color mainColor;

  /// if colorful = true , then the fill color will automatic change depend on battery value
  final bool colorful;

  /// whether paint fill color
  final bool showPercentSlide;

  /// whether show battery value , Recommended [NOT] set to True when colorful = false
  final bool showPercentNum;

  /// default to 14.0
  final double size;

  /// battery value font size, default to null
  final double? percentNumSize;

  /// battery value font size, default to null
  final bool isInPowerSaveMode;

  final int batteryLevel;

  const BatteryIndicator(
      {
        super.key,
        this.batteryLevel = 0,
        this.ratio = 2.5,
        this.mainColor = Colors.black,
        this.colorful = true,
        this.showPercentNum = true,
        this.showPercentSlide = true,
        this.percentNumSize,
        this.isInPowerSaveMode = false,
        this.size = 14.0
      });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size * ratio,
      child: CustomPaint(
        painter: BatteryIndicatorPainter(batteryLevel,showPercentSlide, colorful, mainColor,isInPowerSaveMode),
      ),
    );
  }
}