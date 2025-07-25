import 'package:flutter/material.dart';
import 'package:frontend/controllers/product_controller.dart';
import 'package:frontend/styles/app_text_styles.dart';
import 'package:frontend/styles/colors.dart';
import 'package:get/get.dart';

import '../widgets/product_list_item.dart';
import '../widgets/product_separator.dart';

class ProductView extends GetView<ProductController> {
  const ProductView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("List Stok Barang"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              controller.resetEditMode();
              Get.toNamed('/search');
            },
            icon: Icon(Icons.search),
          ),
        ],
        leading: Obx(() {
          return controller.isEditMode.value
              ? IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  controller.resetEditMode();
                },
              )
              : SizedBox.shrink();
        }),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (controller.products.isEmpty) {
          return Center(child: Text("Belum ada data"));
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(15.0),
              child: Row(
                children: [
                  Text(
                    "${controller.products.length} Data ditampilkan",
                    textAlign: TextAlign.left,
                    style: AppTextStyles.hintGrey,
                  ),
                  Spacer(),
                  !controller.isEditMode.value
                      ? TextButton(
                        onPressed: () => controller.isEditMode.value = true,
                        child: Text("Edit Data"),
                      )
                      : SizedBox.shrink(),
                ],
              ),
            ),

            //List Produk
            Expanded(
              child: RefreshIndicator(
                onRefresh: controller.fetchProducts,
                child: ListView.separated(
                  itemCount: controller.products.length + 1,
                  //tambah 1 untuk teks refresh
                  itemBuilder: (context, index) {
                    //teks refresh
                    if (index == controller.products.length) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.arrow_upward),
                              Text(
                                "Tarik untuk memuat data lainnya",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    final item = controller.products[index];
                    final id = item['id'];

                    return Obx(() {
                      return ProductListItem(
                        item: item,
                        isEditMode: controller.isEditMode.value,
                        isChecked:
                            controller.isEditMode.value
                                ? controller.isSelected(id)
                                : null,
                        onChecked: (_) => controller.toggleSelection(id),
                        onTap: () => controller.showDetail(item),
                      );
                    });
                  },
                  separatorBuilder:
                      (BuildContext context, int index) => productSeparator(),
                ),
              ),
            ),

            //Bagian bawah
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Obx(() {
                return controller.isEditMode.value
                    ? Row(
                      children: [
                        Obx(() {
                          bool isAll = controller.isAllSelected;
                          bool isNone = controller.selectedIds.isEmpty;

                          return Checkbox(
                            value: isNone ? false : (isAll ? true : null),
                            // null = strip ➖
                            tristate: true,
                            onChanged: (_) => controller.toggleSelectAll(),
                          );
                        }),

                        Text("Pilih Semua"),

                        Spacer(),

                        Obx(
                          () => ElevatedButton.icon(
                            icon:
                                controller.isDeleting.value
                                    ? SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(),
                                    )
                                    : Icon(Icons.delete, color: Colors.red),
                            label: Text(
                              "Hapus Barang",
                              style: TextStyle(color: Colors.red),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                            ),
                            onPressed:
                                (() => showDialog(
                                  context: context,
                                  builder:
                                      (ctx) => AlertDialog(
                                        title: Text("Hapus Dialog"),
                                        content: Text(
                                          "Yakin mau hapus ${controller.selectedIds.length} barang yang dipilih?",
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed:
                                                () => Navigator.of(
                                                  ctx,
                                                ).pop(false),
                                            child: Text("Batal"),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(ctx).pop(true);
                                              controller.deleteSelected();
                                            },
                                            child: Text("Hapus"),
                                          ),
                                        ],
                                      ),
                                )),
                          ),
                        ),
                      ],
                    )
                    : SizedBox.shrink();
              }),
            ),
          ],
        );
      }),
      floatingActionButton: Obx(
        () =>
            !controller.isEditMode.value
                ? FloatingActionButton.extended(
                  onPressed: () async {
                    final result = await Get.toNamed('/product-form');

                    if (result == true) {
                      controller.fetchProducts();
                    }
                  },
                  icon: Icon(Icons.add, size: 35.0),
                  label: Text("Barang", style: TextStyle(fontSize: 20)),
                  backgroundColor: AppCustomColor.darkBlue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                )
                : SizedBox.shrink(),
      ),
    );
  }
}
