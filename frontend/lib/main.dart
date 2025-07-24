import 'package:flutter/material.dart';
import 'package:frontend/views/product_view.dart';
import 'package:get/get.dart';

import 'bindings/product_binding.dart';

void main() {
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      getPages: [
        GetPage(
          name: '/',
          page: () => ProductView(),
          binding: ProductBinding(),
        ),
      ],
    ),
  );
}
