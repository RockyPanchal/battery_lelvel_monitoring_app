import 'dart:io';

import 'package:batter_level_monitoring_app/features/battery_info_screen/ui/battery_level_history_screen.dart';
import 'package:batter_level_monitoring_app/resources/strings.dart';
import 'package:flutter/material.dart';
import 'package:batter_level_monitoring_app/features/battery_info_screen/controller/battery_display_controller.dart';
import 'package:batter_level_monitoring_app/features/battery_info_screen/widgets/battery_display_widget.dart';
import 'package:batter_level_monitoring_app/resources/icons.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BatteryIndicatorScreen extends StatefulWidget {
  const BatteryIndicatorScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<BatteryIndicatorScreen> createState() => _BatteryIndicatorScreenState();
}

class _BatteryIndicatorScreenState extends State<BatteryIndicatorScreen> {
  @override
  void initState() {
    super.initState();
    initData();
  }

  ///initial data set
  initData() {
    // calling the method to get battery data
    BatterDisplayController.getBatteryData();

    // calling the method to get battery status
    BatterDisplayController.getBatteryState();

    //iOS only(to set data in foreground)
    if(Platform.isIOS){
      BatterDisplayController.setDataEvery15Min();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(StringConstants.batteryInfo),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const BatteryLevelHistoryScreen()),
                );
              },
              child: const Padding(
                padding: EdgeInsets.all(5),
                child: Icon(Icons.info_outline_rounded),
              ),
            ),
          )
        ],
      ),
      body: Center(
        child: StreamBuilder<bool>(
            stream: BatterDisplayController.batteryLowModeStream,
            builder: (context, snapshot) {
              bool isInPowerSaveMode = snapshot.data ?? false;
              return Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StreamBuilder<int>(
                      stream: BatterDisplayController.batteryLevelStream,
                      builder: (context, snapshot) {
                        int batteryPercentage = snapshot.data ?? 0;
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: Text(
                                '$batteryPercentage%',
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                BatteryIndicator(
                                  mainColor: Colors.grey,
                                  size: 25,
                                  batteryLevel: batteryPercentage,
                                  isInPowerSaveMode: isInPowerSaveMode,
                                ),
                                StreamBuilder<BatteryState>(
                                    stream: BatterDisplayController
                                        .batteryStatusStream,
                                    builder: (context, snapshot) {
                                      BatteryState batteryStatus =
                                          snapshot.data ?? BatteryState.unknown;
                                      return batteryBuild(batteryStatus);
                                    }),
                              ],
                            ),
                          ],
                        );
                      }),
                ],
              );
            }),
      ),
    );
  }

  // Custom widget to add different states of battery
  Widget batteryBuild(BatteryState state) {
    return state == BatteryState.charging
        ? SvgPicture.asset(
            IconsSVG.chargingIcon,
            width: 14,
            height: 14,
          )
        : const SizedBox.shrink();
  }
}
