import 'package:batter_level_monitoring_app/features/battery_info_screen/ui/battery_indicator_screen.dart';
import 'package:flutter/material.dart';

class BatteryLevelMonitoringApp extends StatefulWidget {
  const BatteryLevelMonitoringApp({super.key});

  @override
  State<BatteryLevelMonitoringApp> createState() => _BatteryLevelMonitoringAppState();
}

class _BatteryLevelMonitoringAppState extends State<BatteryLevelMonitoringApp> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Battery Display',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const BatteryIndicatorScreen(),
    );
  }
}
