import 'package:booknplay/Local_Storage/shared_pre.dart';
import 'package:booknplay/Utils/Colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';

import 'Routes/all_pages.dart';
import 'Routes/routes.dart';
import 'Routes/screen_bindings.dart';
import 'Screens/PushNotification/notification_service.dart';
import 'Screens/Timer/timer_controller.dart';
Future<void> backgroundHandler(RemoteMessage message) async {
  WidgetsFlutterBinding.ensureInitialized();
  print(message.data.toString());
  print(message.notification!.title);
}



void main() async{
  runApp(const MyApp());

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  LocalNotificationService.initialize();
  try{
    String? token = await FirebaseMessaging.instance.getToken();
  } on FirebaseException{

  }
  await GetStorage.init();
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>{

  var controllettimer=Get.put(TimerController());

  // This widget is the root of your application.
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: splashScreen,
      getPages: AllPages.getPages(),
      initialBinding: ScreenBindings(),
      title: 'Cleverpager.in',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          foregroundColor: AppColors.whit
        ),
        primarySwatch: Colors.blue,
      ),

    );
  }
}