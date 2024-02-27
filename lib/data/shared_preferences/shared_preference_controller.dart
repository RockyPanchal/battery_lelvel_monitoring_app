

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesController {

  ///database keys
  static const String batterInfoData = "battery_data";
  static const String initialDataEntry = "initial_data_entry";

 ///method to get data from key
  static Future<dynamic> getDataFromKey({required String dataKey}) async {
    var pref = await SharedPreferences.getInstance();
    var dataValue = pref.get(dataKey);
    return dataValue;
  }

  ///method to set string data with key
  static Future<void> setStringData({required String dataKey, required dynamic dataValue}) async {
    var pref = await SharedPreferences.getInstance();
    pref.setString(dataKey, dataValue);
  }

  ///method to set string data with key
  static Future<void> setBoolData({required String dataKey, required dynamic dataValue}) async {
    var pref = await SharedPreferences.getInstance();
    pref.setBool(dataKey, dataValue);
  }

}