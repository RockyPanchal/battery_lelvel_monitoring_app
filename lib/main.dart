import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:batter_level_monitoring_app/data/shared_preferences/shared_preference_controller.dart';
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

  ///work manager initialize and register task
  try{
    Workmanager().initialize(callbackDispatcher, isInDebugMode: true);

    ///android only as ios does not support this for now
    if(Platform.isAndroid){
      Workmanager().registerPeriodicTask(
        backgroundTaskName,
        backgroundTaskName,
        frequency: const Duration(minutes: 15),
        initialDelay: const Duration(minutes: 15),
      );
    }
  }catch(e){
    printLog("workmanager Exception ${e.toString()}");
  }

 ///store initial battery data to local db
  var isInitialDataSaved = await SharedPreferencesController.getDataFromKey(dataKey: SharedPreferencesController.initialDataEntry);
  if(isInitialDataSaved != true){
    BatterDisplayController.storeDataToDb();
  }

  //set received data in main tread
  try{
    var port = ReceivePort();
    IsolateNameServer.registerPortWithName(port.sendPort, backgroundTaskName);
    port.listen((dynamic data) async {
      await SharedPreferencesController.setStringData(dataKey: SharedPreferencesController.batterInfoData,dataValue: data);
    });
  }catch(e){
    printLog("error while update data to main thread ${e.toString()}");
  }

}

///background task name
const backgroundTaskName = "com.example.batteryLevelMonitoringApp.battery_data_fetch";

///call back for background function
@pragma(
    'vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case backgroundTaskName:
        printLog("$backgroundTaskName was executed");

        var prefs = await SharedPreferences.getInstance();
        var data = prefs.get(SharedPreferencesController.batterInfoData);

        List<BatteryInfoModel> tempDataList = [];

        var list = jsonDecode(data as String);
        var dataList = (list as List)
            .map<BatteryInfoModel>((json) => BatteryInfoModel.fromJson(json))
            .toList();
        tempDataList.addAll(dataList);

        String currentTimeDate = BatterDisplayController.getTimeDate();
        int batteryLevel = await Battery().batteryLevel;

        BatteryInfoModel batteryInfoData =
        BatteryInfoModel(dateTime: currentTimeDate, batteryPercentage: batteryLevel);
        tempDataList.add(batteryInfoData);

        String dataString = jsonEncode(tempDataList);
        prefs.setString(SharedPreferencesController.batterInfoData, dataString);

        //to send data main thread
        final sendPort = IsolateNameServer.lookupPortByName(backgroundTaskName);
        if (sendPort != null) {
          // The port might be null if the main isolate is not running.
          sendPort.send(dataString);
        }

        break;

      case Workmanager.iOSBackgroundTask:
        printLog("The iOS background fetch was triggered");

        var prefs = await SharedPreferences.getInstance();
        var data = prefs.get(SharedPreferencesController.batterInfoData);

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
        prefs.setString(SharedPreferencesController.batterInfoData, dataString);


        //to send data main thread
        final sendPort = IsolateNameServer.lookupPortByName(backgroundTaskName);
        if (sendPort != null) {
          // The port might be null if the main isolate is not running.
          sendPort.send(dataString);
        }

        break;
    }

    return Future.value(true);
  });
}