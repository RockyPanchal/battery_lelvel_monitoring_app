import 'package:flutter/material.dart';

class BatteryIndicatorPainter extends CustomPainter {
  int batteryLv;
  bool colorful;
  bool isInPowerSaveMode;
  bool showPercentSlide;
  Color mainColor;

  BatteryIndicatorPainter(
      this.batteryLv,
      this.showPercentSlide,
      this.colorful,
      this.mainColor,
      this.isInPowerSaveMode
      );

  @override
  void paint(Canvas canvas, Size size) {

      canvas.drawRRect(
          RRect.fromLTRBR(0.0, size.height * 0.05, size.width,
              size.height * 0.95, const Radius.circular(100.0)),
          Paint()
            ..color = mainColor
            ..strokeWidth = 0.5
            ..style = PaintingStyle.stroke);

      if (showPercentSlide) {
        canvas.clipRect(Rect.fromLTWH(0.0, size.height * 0.05,
            size.width * fixedBatteryLv / 100, size.height * 0.95));

        double offset = size.height * 0.1;

        canvas.drawRRect(
            RRect.fromLTRBR(
                offset,
                size.height * 0.05 + offset,
                size.width - offset,
                size.height * 0.95 - offset,
                const Radius.circular(100.0)),
            Paint()
              ..color = colorful ? getBatteryLvColor : mainColor
              ..style = PaintingStyle.fill);
      }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return (oldDelegate as BatteryIndicatorPainter).batteryLv != batteryLv ||
        (oldDelegate).mainColor != mainColor || (oldDelegate).isInPowerSaveMode != isInPowerSaveMode;
  }

  get fixedBatteryLv => batteryLv < 10 ? 4 + batteryLv / 2 : batteryLv;

  get getBatteryLvColor => isInPowerSaveMode
      ? Colors.orange
      : batteryLv <= 20 ? Colors.red : Colors.green;
}