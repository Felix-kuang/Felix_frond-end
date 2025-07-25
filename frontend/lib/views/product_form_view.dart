import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:frontend/controllers/product_form_controller.dart';
import 'package:frontend/styles/custom_input_decoration.dart';
import 'package:get/get.dart';

class ProductFormView extends GetView<ProductFormController> {
  const ProductFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.isEdit ? "Edit Barang" : "Tambah Barang"),
        shadowColor: Colors.grey,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Form(
              key: controller.formKey,
              child: Column(
                children: [
                  SizedBox(height: 30),
                  Obx(
                    () =>
                        controller.imageUrl.isEmpty ||
                                controller.isUploading.value
                            //Placeholder
                            ? Container(
                              height: 150,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade400),
                              ),
                              child: const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.image_outlined,
                                      size: 40,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      "Belum ada gambar",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            : Image.network(
                              controller.imageUrl.value,
                              height: 150,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 150,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Icon(
                                    Icons.broken_image,
                                    size: 80,
                                    color: Colors.grey[400],
                                  ),
                                );
                              },
                            ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: controller.pickAndUploadImage,
                    child: Obx(() {
                      return controller.isUploading.value
                          ? CircularProgressIndicator()
                          : Text("Pilih Gambar");
                    }),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: controller.nameController,
                    decoration: CustomInputDecoration.textField(
                      label: "Nama Barang",
                      isRequired: true,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Nama Barang Belum diisi";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  Obx(() {
                    if (controller.categories.isEmpty) {
                      return CircularProgressIndicator(); // atau SizedBox()
                    }
                    return DropdownButtonFormField<int>(
                      value: controller.selectedCategory.value,
                      items:
                          controller.categories
                              .map(
                                (kategori) => DropdownMenuItem<int>(
                                  value: kategori['id'],
                                  child: Text(kategori['nama_kategori']),
                                ),
                              )
                              .toList(),
                      onChanged: (value) {
                        controller.selectedCategory.value = value;
                      },
                      decoration: CustomInputDecoration.textField(
                        label: "Kategori Barang",
                        isRequired: true,
                      ),
                      validator: (value) {
                        if (value == null) {
                          return "Kategori Barang Belum diisi";
                        }
                        return null;
                      },
                    );
                  }),
                  SizedBox(height: 20),
                  Obx(
                    () => DropdownButtonFormField(
                      value: controller.selectedGroup.value,
                      items:
                          controller.groups
                              .map(
                                (group) => DropdownMenuItem(
                                  value: group,
                                  child: Text("Kelompok $group"),
                                ),
                              )
                              .toList(),
                      onChanged: (value) {
                        controller.selectedGroup.value = value;
                      },
                      decoration: CustomInputDecoration.textField(
                        label: "Kelompok Barang",
                        isRequired: true,
                      ),
                      validator: (value) {
                        if (value == null) {
                          return "Kelompok Barang Belum diisi";
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: controller.stockController,
                    keyboardType: TextInputType.number,
                    decoration: CustomInputDecoration.textField(
                      label: "Stok",
                      isRequired: true,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Stok Belum diisi";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: controller.priceController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      CurrencyInputFormatter(
                        thousandSeparator: ThousandSeparator.Period,
                        mantissaLength: 0,
                      ),
                    ],
                    decoration: CustomInputDecoration.textField(
                      label: "Harga",
                      isRequired: true,
                      prefix: Text("Rp "),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Harga Belum diisi";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FractionallySizedBox(
          widthFactor: 0.9,
          heightFactor: 0.06,
          child: Obx(
            () => ElevatedButton(
              onPressed:
                  controller.isUploading.value
                      ? null
                      : () {
                        if (controller.formKey.currentState!.validate()) {
                          controller.submit();
                        } else {
                          Get.snackbar(
                            "Error",
                            "Periksa kembali data yang diisi",
                          );
                        }
                      },
              style: ElevatedButton.styleFrom(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                controller.isEdit ? "Update Barang" : "Tambah Barang",
              ),
            ),
          ),
        ),
      ),
    );
  }
}
