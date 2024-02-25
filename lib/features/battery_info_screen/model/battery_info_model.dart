
class BatteryInfoModel{
   String? dateTime;
   int? batteryPercentage;

   BatteryInfoModel({ required this.dateTime,required this.batteryPercentage});

   BatteryInfoModel.fromJson(Map<String, dynamic> json) {
     dateTime = json['dateTime'];
     batteryPercentage = json['percentage'];
   }

   Map<String, dynamic> toJson() {
     final Map<String, dynamic> data = <String, dynamic>{};
     data['dateTime'] = dateTime;
     data['percentage'] = batteryPercentage;
     return data;
   }

}