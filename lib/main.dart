import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebaseauth/localnotification.dart';
import 'package:firebaseauth/login/login_controller.dart';
import 'package:firebaseauth/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home/home_screen.dart';
import 'signup/signup_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService notificationService = NotificationService();
  await notificationService.initNotification();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: 'AIzaSyD87QejOcwKcD7XAIHwTUUznuzkYsYaln4',
    appId: '1:144333009677:android:75fee772e2b25234247644',
    messagingSenderId: '144333009677',
    projectId: 'task-2587d',
    storageBucket: 'gs://task-2587d.appspot.com',
  )).whenComplete(() async {
    print("Complete");
    final fcmToken = await FirebaseMessaging.instance.getToken() ?? '';
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('FIREBASE_TOKEN', fcmToken);
    print("Firebase token: $fcmToken");

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      NotificationService().showNotification(
        id: DateTime.now().microsecond,
        title: message.notification?.title,
        body: message.notification?.body,
      );
      print(
          'Received a message in the foreground: ${message.notification?.body}');
    });

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      print("New token: $newToken");
    });
  });

  if (GetPlatform.isIOS) {
    await requestNotificationPermission();
  } else {
    await requestNotificationPermission();
  }
  Get.put(AuthController());

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(const MyApp());
  });
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("adhaiusdhaiud ${message.data}");
}

Future<void> requestNotificationPermission() async {
  final settings = await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
    provisional: true,
  );
  print("PERMISSION++++++++++++++++${settings}");
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          appBarTheme: AppBarTheme(
              backgroundColor: Colors.teal, foregroundColor: Colors.white)),
      title: 'Login App',
      initialRoute: '/',
      home: YourInitialScreen(),
      getPages: [
        GetPage(name: '/', page: () => LoginPage()),
        GetPage(name: '/signup', page: () => SignUpPage()),
        GetPage(name: '/home', page: () => HomeScreen()),
      ],
    );
  }
}

class YourInitialScreen extends StatelessWidget {
  const YourInitialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.put(AuthController());
    authController.userLoginOrNot();

    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
