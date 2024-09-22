import 'dart:typed_data';

import 'package:cryptoprice/Screens/homescreen.dart';
import 'package:cryptoprice/Service/updateprice.dart';
import 'package:cryptoprice/modes/cryptoprice.dart';
import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// void callbackDispatcher() {
//   Workmanager().executeTask((task, inputData) async {
//     // Fetch crypto price and update maxPrice logic here
//     // Check if new max price is reached and trigger notification if true
//     if (inputData != null && inputData['newMax'] == true) {
//       await sendNotification();
//     }
//     return Future.value(true);
//   });
// }
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == 'fetchAndNotify') {
      String symbol = inputData?['symbol'] ?? 'BTCUSDT';
      Cryptoprice data = await Updateprice.request(symbol);

      // Fetch the current max price from shared preferences or another source
      double currentMaxPrice =
          0; // Replace with actual logic to fetch saved max price

      if (data.price > currentMaxPrice) {
        // Update max price and send notification
        currentMaxPrice = data.price;

        await sendNotification();
        return Future.value(true);
      }
    }
    return Future.value(false);
  });
}

Future<void> sendNotification() async {
  AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'channelId',
    'Crypto Price Tracker',
    importance: Importance.max,
    priority: Priority.high,
    vibrationPattern: Int64List.fromList([0, 500, 1000, 500]),
    enableVibration: true,
  );

  NotificationDetails platformDetails =
      NotificationDetails(android: androidDetails);
  await flutterLocalNotificationsPlugin.show(
    0,
    'New Max Price Alert!',
    'A new maximum price has been reached!',
    platformDetails,
  );
}

void main() {
  runApp(const MyApp());
  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
    );
  }
}
