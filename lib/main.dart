import 'package:brasileirao_flutter/controllers/theme_controller.dart';
import 'package:brasileirao_flutter/pages/home_page/home_page.dart';
import 'package:brasileirao_flutter/repositories/times_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'config.dart';
import 'widget/checkauth.dart';

void main() async {
  await initConfigurations();

  runApp(
    ChangeNotifierProvider(
      create: (context) => TimesRepository(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    ThemeController.to.loadThemeMode();

    return GetMaterialApp(
      title: 'Brasileirão',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          brightness: Brightness.light),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primarySwatch: Colors.grey,
        accentColor: Colors.white,
        accentIconTheme: IconThemeData(color: Colors.black),
        dividerColor: Colors.black45,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: Colors.deepPurpleAccent[100],
          ),
        ),
      ),
      themeMode: ThemeMode.system,
      home: CheckAuth(),
    );
  }
}
