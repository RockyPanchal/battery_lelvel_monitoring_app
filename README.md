﻿# battery_level_monitoring_app

A new Flutter project to display and store battery level data and display in list

Flutter version used: 3.16.5

Architecture pattern used: MVC (as no need other architecture)

Background task package : WorkManager 

State Management: Stream Controller (As no need of other bloc, provide, Getx etc) as there are less data update manage. So no need of other package, use basic dart provided stream controller

Data storage: Shared preferences (use as there is just need to save key value data)

HoW App Works:

1.First screen: Battery Info screen 

it shows battery info at Center of screen

Percentage text- show real time battery level percentage

Battery Display view – display battery with appropriate color and charing indicating icon

Orange color- if battery is in power saver mode, no matter percentage level


Red color- battery less or equal to 20%

Green color – battery greater then 20%

Battery charging indicating icon: if battery is charging shows charging indicating icon on battery view
Important: when battery is full charged and connected to power, It will not show charging indicating icon as battery is not storing energy and we will not getting charging status from device

Details(info) Icon: It will redirect to battery data level history list.


2.Second screen: Battery Info screen 

This screen will show battery level with date and time in list every 15 minutes

Important:
-Android: for background fetch you need to allow app to run in background(add app in never sleep apps) and allow background fetch in battery settings   
-Background fetch time will not accurate all time as per work manager document (Periodic tasks : runs indefinitely on a regular basis)
-Debug notifications shows on screen for testing purpose, can be disable with  isInDebugMode value to false, while init workmanager 

Known issue:

1.iOS battery level: iOS 17 and above battery level shows increment of 5 level(percentage) , else below ios 17 works perfectly: 
   references: https://forums.developer.apple.com/forums/thread/732903

2.iOS Background fetch is not working (working to find way if possible to implement)
But in order to test you can simulate a background fetch in Xcode; go to Debug → Simulate Background Fetch

