import 'dart:async';
import 'dart:convert';
import 'package:batter_level_monitoring_app/data/shared_preferences/shared_preference_controller.dart';
import 'package:batter_level_monitoring_app/features/battery_info_screen/model/battery_info_model.dart';
import 'package:batter_level_monitoring_app/main.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

void printLog(Object? object) {
  if (kDebugMode) {
    print(object);
  }
}

class BatterDisplayController{

  static final StreamController<int> _batteryLevelController = StreamController();
  static Stream<int> get batteryLevelStream => _batteryLevelController.stream;

  static final StreamController<bool> _batteryLowModeController = StreamController();
  static Stream<bool> get batteryLowModeStream => _batteryLowModeController.stream;

  static final StreamController<BatteryState> _batteryStatusController = StreamController();
  static Stream<BatteryState> get batteryStatusStream => _batteryStatusController.stream;

  static final StreamController <List<BatteryInfoModel>> _batteryDataListController = StreamController.broadcast();
  static Stream <List<BatteryInfoModel>> get batteryDataListStream => _batteryDataListController.stream;

  static final _battery = Battery();

  /// method to know the state of the battery
  static void getBatteryState() {
    _battery.onBatteryStateChanged.listen((state) {
      _batteryStatusController.sink.add(state);
    });
  }

  /// method created to get battery data every second
  static getBatteryData()async{
    Timer.periodic(const Duration(seconds: 1), (timer) {
      getBatteryPercentage();
      checkBatterSaveMode();
      //storeDataToDb();
    });
  }

  /// method created to display battery percent
  static void getBatteryPercentage() async {
    final level = await _battery.batteryLevel;
    _batteryLevelController.sink.add(level);
  }


  ///for iOS foreground update
  static setDataEvery15Min(){
    //storeDataToDb();
    Timer.periodic(const Duration(minutes: 15), (timer) async{
      try{
       var dataList = await storeDataToDb();
       _batteryDataListController.sink.add(dataList);
      }catch(e){
        printLog("error while storing issue${e.toString()}");
      }
    });
  }

 /// method created to check if battery is in powerSave mode or not
  static void checkBatterSaveMode() async {
    final isInPowerSaveMode = await _battery.isInBatterySaveMode;
    _batteryLowModeController.sink.add(isInPowerSaveMode);
  }

  /// method to get initial battery level history list
  static getInitialList()async{
    //var prefs = await SharedPreferences.getInstance();
   // var data = prefs.get(batterInfoData);

    var data = await SharedPreferencesController.getDataFromKey(dataKey: SharedPreferencesController.batterInfoData);

    List<BatteryInfoModel> tempDataList = [];

    if(data != null){
      var list = jsonDecode(data as String);
      var dataList = (list as List).map<BatteryInfoModel>((json) => BatteryInfoModel.fromJson(json)).toList();
      tempDataList.addAll(dataList);
      tempDataList = tempDataList.reversed.toList();
    }

    _batteryDataListController.sink.add(tempDataList);
  }

  /// method created to store data in db
  static Future<List<BatteryInfoModel>> storeDataToDb() async {

    var data = await SharedPreferencesController.getDataFromKey(dataKey: SharedPreferencesController.batterInfoData);

    List<BatteryInfoModel> tempDataList = [];

    if(data != null){
      var list = jsonDecode(data as String);
      var dataList = (list as List).map<BatteryInfoModel>((json) => BatteryInfoModel.fromJson(json)).toList();
      tempDataList.addAll(dataList);
    }

    String currentTimeDate = getTimeDate();

    int batteryLevel = await Battery().batteryLevel;

    BatteryInfoModel batteryInfoData = BatteryInfoModel(dateTime: currentTimeDate, batteryPercentage: batteryLevel);
    tempDataList.add(batteryInfoData);

    String dataString = jsonEncode(tempDataList);

    await SharedPreferencesController.setStringData(dataKey: SharedPreferencesController.batterInfoData,dataValue: dataString);


    var isInitialDataSaved = await SharedPreferencesController.getDataFromKey(dataKey: SharedPreferencesController.initialDataEntry);
    if(isInitialDataSaved != true){
      await SharedPreferencesController.setBoolData(dataKey: SharedPreferencesController.initialDataEntry,dataValue: true);
    }

    return tempDataList;
  }

  static String getTimeDate(){
      var outputFormatDate= DateFormat('dd-MM-yyyy hh:mm:ss');
      DateTime finalDate = DateTime.now();
      var date = outputFormatDate.format(finalDate);
      return date;
  }


}