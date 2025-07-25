import 'package:flutter/material.dart';
import 'package:frontend/bindings/product_form_binding.dart';
import 'package:frontend/bindings/search_product_binding.dart';
import 'package:frontend/views/product_form_view.dart';
import 'package:frontend/views/product_view.dart';
import 'package:frontend/views/search_product_view.dart';
import 'package:get/get.dart';

import 'bindings/product_binding.dart';

void main() {
  runApp(
    GetMaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 4,
          shadowColor: Colors.grey,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.black),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF001767),
            foregroundColor: Colors.white,
            textStyle: TextStyle(fontWeight: FontWeight.w600),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(fontSize: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      getPages: [
        GetPage(
          name: '/',
          page: () => ProductView(),
          binding: ProductBinding(),
        ),
        GetPage(
          name: '/search',
          page: () => SearchProductView(),
          binding: SearchProductBinding(),
        ),
        GetPage(
          name: '/product-form',
          page: () => ProductFormView(),
          binding: ProductFormBinding(),
        ),
      ],
    ),
  );
}
