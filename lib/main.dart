import 'package:flutter/material.dart';
import 'package:my_coffer/pages/add_name.dart';
import 'package:my_coffer/pages/homepage.dart';
import 'package:my_coffer/pages/splash.dart';
import 'package:my_coffer/theme.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';

// ok
void main() async {
  // await Hive.init
  await Hive.initFlutter();
  await Hive.openBox('money');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Coffer',
      theme: myTheme,
      home: const Splash(),
    );
  }
}
