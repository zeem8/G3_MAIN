import 'package:flutter/material.dart';
import 'package:g3_crm/pages/settermap.dart';

import 'pages/dashboard.dart';
import 'login/login_screen_4.dart';
import 'pages/admin.dart';

import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:splashscreen/splashscreen.dart';
import 'custom_splash.dart';

void main() {
  Function duringSplash = () {
    print('Something background process');
    int a = 123 + 23;
    print(a);

    if (a > 100)
      return 1;
    else
      return 2;
  };

  Map<int, Widget> op = {1: MyApp(), 2: MyApp()};

  runApp(new MaterialApp(
      home: CustomSplash(
    imagePath: 'images/animated_loading.gif',
    backGroundColor: Color.fromARGB(255, 255, 255, 255),
    // backGroundColor: Color(0xfffc6042),
    animationEffect: 'fade-in',
    logoSize: 500,
    home: MyApp(),
    customFunction: duringSplash,
    duration: 4500,
    type: CustomSplashType.StaticDuration,
    outputAndHome: op,
  )));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Map<String, WidgetBuilder> routes = {
      '/': (BuildContext context) => LoginScreen4(),
      '/dashboard': (BuildContext context) => Dashboard(),
      '/admin': (BuildContext context) => Admin(),
      '/settermap': (BuildContext context) => SetterMap(),
    };
    return MaterialApp(
      initialRoute: '/',
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      navigatorKey: Get.key,
    );
  }
}
