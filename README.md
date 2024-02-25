# battery_level_monitoring_app

A new Flutter project to display and store battery level data and display in list


Flutter version used: 3.16.5

Architecture pattern used: MVC (as no need other architecture)

State Management: Stream Controller (As no need of other bloc, provide, Getx etc) as there are less data update manage. So no need of other package, use basic dart provided stream controller

Data storage: Shared preferences (use as there is just need to save key value data)

HoW App Works:

1.First screen: Battery Info screen 

it shows battery info at Center of screen

Percentage text- show real time battery level percentage

Battery Display view – display battery with appropriate color and charing indicating icon

Orange color- if battery is in power saver mode, no matter percentage level


Red color- battery less or equal to 20%

Green color – battery greater ten 20%

Battery charging indicating icon: if battery is charing shows charging indicating icon on battery view

Details(info) Icon: It will redirect to battery data level history list.


2.Second screen: Battery Info screen 

This screen will show battery level with date and time in list every 15 minutes


Known issue:
1.iOS battery level: iOS 17 and above battery level shows increment of 5 level , else works perfectly: 
   references: https://forums.developer.apple.com/forums/thread/732903
2.iOS Background fetch is not working (working on this part)
2.Android: Data update in forground/background app : Battery data history list is not updating while app is in background and frgorund , it will update when you close and open app again OR App is killed (working on this part)
