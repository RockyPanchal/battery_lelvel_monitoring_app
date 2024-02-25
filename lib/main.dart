import 'dart:convert';
import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import 'app/battery_leve_monitoring_app.dart';
import 'features/battery_info_screen/controller/battery_display_controller.dart';
import 'features/battery_info_screen/model/battery_info_model.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initSetup();
  runApp(const BatteryLevelMonitoringApp());
}

initSetup() async {

  ///work manager intialize and register task
  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  Workmanager().registerPeriodicTask(
    backgroundTaskName,
    backgroundTaskName,
    frequency: const Duration(minutes: 15),
    initialDelay: const Duration(minutes: 15),
  );

 ///store initial battery data to local db
  var prefs = await SharedPreferences.getInstance();
  var isInitialDataSaved = prefs.get(initialDataEntry);
  if(isInitialDataSaved != true){
    backgroundDataStore();
  }

}


///background task name
const backgroundTaskName = "com.example.batteryLevelMonitoringApp.battery_data_fetch";

///database keys
const String batterInfoData = "battery_data";
const String initialDataEntry = "initial_data_entry";

@pragma(
    'vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case backgroundTaskName:
        printLog("$backgroundTaskName was executed");
        var prefs = await SharedPreferences.getInstance();
        var data = prefs.get(batterInfoData);

        List<BatteryInfoModel> tempDataList = [];

        if (data != null) {
          var list = jsonDecode(data as String);
          var dataList = (list as List)
              .map<BatteryInfoModel>((json) => BatteryInfoModel.fromJson(json))
              .toList();
          tempDataList.addAll(dataList);
        }

        String currentTimeDate = BatterDisplayController.getTimeDate();
        int batteryLevel = await Battery().batteryLevel;

        BatteryInfoModel batteryInfoData =
        BatteryInfoModel(dateTime: currentTimeDate, batteryPercentage: batteryLevel);
        tempDataList.add(batteryInfoData);

        String dataString = jsonEncode(tempDataList);
        prefs.setString(batterInfoData, dataString);
        break;

      case Workmanager.iOSBackgroundTask:
        printLog("The iOS background fetch was triggered");
        var prefs = await SharedPreferences.getInstance();
        var data = prefs.get(batterInfoData);

        List<BatteryInfoModel> tempDataList = [];

        if (data != null) {
          var list = jsonDecode(data as String);
          var dataList = (list as List)
              .map<BatteryInfoModel>((json) => BatteryInfoModel.fromJson(json))
              .toList();
          tempDataList.addAll(dataList);
        }

        String currentTimeDate = BatterDisplayController.getTimeDate();
        int batteryLevel = await Battery().batteryLevel;

        BatteryInfoModel batteryInfoData =
        BatteryInfoModel(dateTime: currentTimeDate, batteryPercentage: batteryLevel);
        tempDataList.add(batteryInfoData);

        String dataString = jsonEncode(tempDataList);
        prefs.setString(batterInfoData, dataString);
        break;
    }

    return Future.value(true);
  });
}

void backgroundDataStore() async {
  var prefs = await SharedPreferences.getInstance();
  var data = prefs.get(batterInfoData);

  List<BatteryInfoModel> tempDataList = [];

  if (data != null) {
    var list = jsonDecode(data as String);
    var dataList = (list as List)
        .map<BatteryInfoModel>((json) => BatteryInfoModel.fromJson(json))
        .toList();
    tempDataList.addAll(dataList);
  }

  String currentTimeDate = BatterDisplayController.getTimeDate();
  int batteryLevel = await Battery().batteryLevel;

  BatteryInfoModel batteryInfoData =
      BatteryInfoModel(dateTime: currentTimeDate, batteryPercentage: batteryLevel);
  tempDataList.add(batteryInfoData);

  String dataString = jsonEncode(tempDataList);
  prefs.setString(batterInfoData, dataString);

  prefs.setBool(initialDataEntry, true);

}
