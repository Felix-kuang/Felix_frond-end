import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:frontend/services/category_service.dart';
import 'package:frontend/services/image_service.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../services/product_service.dart';

class ProductFormController extends GetxController {
  Map<String, dynamic>? product;

  bool get isEdit => product != null;

  //category dropdown
  final categories = <Map<String, dynamic>>[].obs;
  var selectedCategory = RxnInt();

  Future<void> fetchCategories() async {
    try {
      final result = await CategoryService.getAll();
      categories.assignAll(result.cast<Map<String, dynamic>>());
    } catch (e) {
      Get.snackbar("Error", "Gagal ambil kategori: $e");
    }
  }

  //kelompok barang dropdown
  final List<String> groups = ['A', 'B', 'C'];

  var selectedGroup = RxnString();

  //form controllers
  TextEditingController nameController = TextEditingController();
  TextEditingController stockController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  var imageUrl = "".obs;

  //image handle
  var isUploading = false.obs;

  void pickAndUploadImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      isUploading(true);
      final file = File(image.path);

      try {
        final url = await ImageService.uploadImage(file);
        imageUrl.value = url;
        Get.snackbar("Sukses", "Gambar berhasil diupload");
      } catch (e) {
        Get.snackbar("Upload Gagal", "$e");
      } finally {
        isUploading(false);
      }
    }
  }

  //submit handle
  final formKey = GlobalKey<FormState>();

  Future<void> submit() async {
    final namaBarang = nameController.text.trim();
    final kategoriId = selectedCategory.value;
    final stok = int.tryParse(stockController.text) ?? 0;

    final hargaStr =
        priceController.text.replaceAll('.', '').replaceAll('Rp', '').trim();
    final harga = int.tryParse(hargaStr) ?? 0;

    final kelompok = selectedGroup.value;

    final payload = {
      "nama_barang": namaBarang,
      "kategori_id": kategoriId,
      "stok": stok,
      "kelompok_barang": kelompok,
      "harga": harga,
      "imageUrl": imageUrl.value,
    };

    try {
      if(!isEdit){
        await ProductService.create(payload);
      } else {
        await ProductService.update(product!['id'], payload);
      }

      Get.back(result: true);
      // Get.snackbar("Sukses", "Produk berhasil ditambahkan");
    } catch (e) {
      Get.snackbar("Error", "Gagal tambah barang: $e");
    }
  }

  @override
  void onInit() {
    super.onInit();
    product = Get.arguments;

    if (isEdit) {
      nameController.text = product!['nama_barang'];
      stockController.text = product!['stok'].toString();
      priceController.text = product!['harga'].toString();
      selectedGroup.value = product!['kelompok_barang'];
      imageUrl.value = product!['imageUrl'] ?? "";
    }

    fetchCategories().then((_) {
      if (isEdit) {
        selectedCategory.value = product!['kategori_id'];
      }
    });
  }
}
