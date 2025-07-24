import 'package:flutter/material.dart';
import 'package:frontend/controllers/product_controller.dart';
import 'package:get/get.dart';

class ProductView extends GetView<ProductController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("List Stok Barang"),
        elevation: 1,
        shadowColor: Colors.grey,
        centerTitle: true,
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.search))],
        leading: Obx(() {
          return controller.isEditMode.value
              ? IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  controller.isEditMode.value = false;
                  controller.selectedIds.clear();
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
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
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
                  //tambah 1 untuk teks
                  itemBuilder: (context, index) {
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
                      return controller.isEditMode.value
                          ? CheckboxListTile(
                            controlAffinity: ListTileControlAffinity.leading,
                            title: Text(item['nama_barang'] ?? '-'),
                            subtitle: Text('Stok : ${item['stok']}'),
                            secondary: Text("Rp ${item['harga']}"),
                            onChanged: (_) => controller.toggleSelection(id),
                            value: controller.isSelected(id),
                          )
                          : ListTile(
                            title: Text(item['nama_barang'] ?? '-'),
                            subtitle: Text('Stok : ${item['stok']}'),
                            trailing: Text("Rp ${item['harga']}"),
                            onTap: () {},
                          );
                    });
                  },
                  separatorBuilder:
                      (BuildContext context, int index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Divider(
                          thickness: 0.8,
                          color: Colors.grey.shade400,
                          height: 0,
                        ),
                      ),
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
                          bool isPartial = !isAll && !isNone;

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
                                    : Icon(Icons.delete, color: Colors.red,),
                            label: Text(
                              "Hapus Barang",
                              style: TextStyle(color: Colors.red),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                            ),
                            onPressed:
                                controller.selectedIds.isEmpty
                                    ? null
                                    : controller.deleteSelected,
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
    );
  }
}
