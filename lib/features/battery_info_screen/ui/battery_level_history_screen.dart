import 'package:batter_level_monitoring_app/features/battery_info_screen/controller/battery_display_controller.dart';
import 'package:batter_level_monitoring_app/features/battery_info_screen/model/battery_info_model.dart';
import 'package:batter_level_monitoring_app/resources/strings.dart';
import 'package:flutter/material.dart';

class BatteryLevelHistoryScreen extends StatefulWidget {
  const BatteryLevelHistoryScreen({super.key});

  @override
  State<BatteryLevelHistoryScreen> createState() =>
      _BatteryLevelHistoryScreenState();
}

class _BatteryLevelHistoryScreenState extends State<BatteryLevelHistoryScreen> {
  @override
  void initState() {
    super.initState();
    initData();
  }

  ///initial data set
  initData(){
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      BatterDisplayController.getInitialList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(StringConstants.batteryLevelHistory),
        centerTitle: true,
        forceMaterialTransparency: true,
      ),
      body: SafeArea(
        child: StreamBuilder<List<BatteryInfoModel>>(
            stream: BatterDisplayController.batteryDataListStream,
            builder: (context, snapshot) {
              List<BatteryInfoModel> batteryDataList = snapshot.data ?? [];
              if (batteryDataList.isEmpty) {
                return noDataWidget();
              }else{
                return dataListWidget(batteryDataList: batteryDataList);
              }
            }),
      ),
    );
  }

  Widget dataListWidget({required List<BatteryInfoModel> batteryDataList}){
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
          child: Row(
            children: [
              Expanded(
                flex: 7,
                child: Text(
                  StringConstants.batteryLevelDateTime,
                  style:
                  TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  StringConstants.batteryLevel,
                  style:
                  TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              )
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 15),
              itemCount: batteryDataList.length,
              itemBuilder: (context, index) {
                BatteryInfoModel batteryInfoData = batteryDataList[index];
                return batteryDataWidget(batteryInfoData);
              }),
        ),
      ],
    );
  }

  Widget noDataWidget(){
    return const Center(
      child: Text(
        StringConstants.noHistoryAvailable,
      ),
    );
  }

  Widget batteryDataWidget(BatteryInfoModel batteryInfoData) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 7,
            child: Text(
              '${batteryInfoData.dateTime}',
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              '${batteryInfoData.batteryPercentage}%',
            ),
          )
        ],
      ),
    );
  }
}
