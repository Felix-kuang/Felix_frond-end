import 'package:frontend/services/product_service.dart';
import 'package:frontend/widgets/bottom_sheet_widget.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ProductController extends GetxController {
  var isLoading = false.obs;
  var products = [].obs;

  var isEditMode = false.obs;
  var isDeleting = false.obs;

  //untuk checkbox
  var selectedIds = <int>{}.obs;

  bool isSelected(int id) => selectedIds.contains(id);

  void toggleSelection(int id) {
    if (selectedIds.contains(id)) {
      selectedIds.remove(id);
    } else {
      selectedIds.add(id);
    }
  }

  void selectAll() {
    selectedIds.assignAll(products.map((e) => e['id'] as int));
  }

  void clearSelection() => selectedIds.clear();

  bool get isAllSelected => selectedIds.length == products.length;

  void toggleSelectAll() {
    if (isAllSelected) {
      clearSelection();
    } else {
      selectAll();
    }
  }

  void resetEditMode() {
    isEditMode.value = false;
    selectedIds.clear();
  }

  //delete
  Future<void> deleteSelected() async {
    try {
      isDeleting(true);
      await ProductService.deleteBulk(selectedIds.toList());
      final itemCount = selectedIds.length;
      await fetchProducts();

      selectedIds.clear();

      isEditMode(false);

      Get.snackbar("Berhasil", "$itemCount barang berhasil dihapus");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isDeleting(false);
    }
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
        onEditItem: () async {
          Get.back();
          final result = await Get.toNamed('/product-form', arguments: product);
          print("Hasil $result");
          if (result == true) {
            fetchProducts();
          }
        },
      ),
      barrierColor: Colors.black45,
      isDismissible: true,
      enableDrag: true,
    );
  }

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      isLoading(true);
      final result = await ProductService.getAll();
      products.assignAll(result);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }
}
