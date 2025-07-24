import 'package:frontend/services/product_service.dart';
import 'package:get/get.dart';

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

  //delete
  Future<void> deleteSelected() async {
    try {
      isDeleting(true);
      await ProductService.deleteBulk(selectedIds.toList());

      await fetchProducts();

      selectedIds.clear();

      isEditMode(false);

      Get.snackbar("Berhasil", "Barang berhasil dihapus");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isDeleting(false);
    }
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
