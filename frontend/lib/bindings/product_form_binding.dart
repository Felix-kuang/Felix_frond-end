import 'package:frontend/controllers/product_form_controller.dart';
import 'package:get/get.dart';

class ProductFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProductFormController());
  }
}
