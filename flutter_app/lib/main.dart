import 'package:flutter/material.dart';
import 'package:flutter_app/Services/api_service.dart';
import 'package:get/get.dart';

void main() {
  initServices();

  runApp(const MyApp());
}

void initServices() {
  Get.put(ApiService());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(appBarTheme: AppBarTheme(color: Colors.redAccent)),
      darkTheme: ThemeData(
        appBarTheme: AppBarTheme(color: Colors.purpleAccent),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Welcome"));
  }
}
