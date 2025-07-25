import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/product_service.dart';
import '../widgets/bottom_sheet_widget.dart';

class SearchProductController extends GetxController {
  var isLoading = false.obs;
  var products = [].obs;

  var isEditMode = false.obs;
  var isDeleting = false.obs;

  final TextEditingController searchTextController = TextEditingController();

  @override
  void onInit() {
    super.onInit();

    fetchProducts();
  }

  Future<void> deleteSingle(int id) async {
    isDeleting(true);
    try {
      await ProductService.delete(id);
      await fetchProducts();
    } finally {
      isDeleting(false);
    }
  }

  //Product Detail
  void showDetail(Map<String, dynamic> product) {
    Get.bottomSheet(
      BottomSheetWidget(
        product: product,
        onDeleteItem: () async {

          try {
            await deleteSingle(product['id']);
            if (Get.isBottomSheetOpen == true) {
              Get.back();
            }
          } catch (e) {
            Get.back(); // close loading
          }
        },
        onEditItem: () {
          Get.back();
          Get.toNamed('/product-form', arguments: product);
        },
      ),
      barrierColor: Colors.black45,
      isDismissible: true,
      enableDrag: true,
    );
  }

  Future<void> fetchProducts() async {
    try {
      isLoading(true);

      final keyword = searchTextController.text;
      final result = await ProductService.searchItems(keyword);

      products.assignAll(result);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }
}
