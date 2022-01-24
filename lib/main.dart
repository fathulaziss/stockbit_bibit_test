import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stockbit_bibit_test/page_main.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // var initializationSettingAndroid =
  //     const AndroidInitializationSettings('android_icon');
  // var initializationSettingIOS = IOSInitializationSettings(
  //     requestAlertPermission: true,
  //     requestBadgePermission: true,
  //     requestSoundPermission: true,
  //     onDidReceiveLocalNotification:
  //         (int id, String? title, String? body, String? payload) async {});
  // var initializationSettings = InitializationSettings(
  //     android: initializationSettingAndroid, iOS: initializationSettingIOS);
  // await flutterLocalNotificationsPlugin.initialize(initializationSettings,
  //     onSelectNotification: (String? payload) async {});
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 779),
      builder: () => GetMaterialApp(
        home: const PageMain(),
        builder: (context, child) => MediaQuery(
          /// Setting font does not change with system font size
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
          child: child!,
        ),
      ),
    );
  }
}
