import 'package:flutter/material.dart';
import 'package:flutter_app/Controllers/item_controller.dart';
import 'package:flutter_app/Screens/items_screen.dart';
import 'package:flutter_app/Services/api_service.dart';
import 'package:get/get.dart';

void main() {
  initServices();

  runApp(const MyApp());
}

void initServices() {
  Get.put(ApiService());
  Get.put(ItemController());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: AppBarTheme(color: Colors.redAccent),
        primaryColor: Colors.redAccent,
      ),
      darkTheme: ThemeData(
        appBarTheme: AppBarTheme(color: Colors.purpleAccent),
      ),
      home: const ItemsScreen(),
    );
  }
}
