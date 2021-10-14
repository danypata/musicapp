import 'package:flutter/material.dart';
import 'package:musicapp/networking/config/api_config.dart';
import 'package:musicapp/screens/search/search_screen.dart';

void main() {
  ApiConfig().setEnv(ConfigEnv.staging);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SearchScreen(),
    );
  }
}
