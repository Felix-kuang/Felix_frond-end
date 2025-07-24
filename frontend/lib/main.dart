import 'package:flutter/material.dart';
import 'package:frontend/views/home_view.dart';
import 'package:get/get.dart';

import 'bindings/home_binding.dart';

void main() {
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => HomeView(), binding: HomeBinding()),
      ],
    ),
  );
}
