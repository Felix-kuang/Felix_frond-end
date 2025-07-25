import 'package:flutter/material.dart';
import 'package:frontend/controllers/search_product_controller.dart';
import 'package:frontend/styles/app_text_styles.dart';
import 'package:frontend/widgets/product_list_item.dart';
import 'package:frontend/widgets/product_separator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SearchProductView extends GetView<SearchProductController> {
  const SearchProductView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: controller.searchTextController,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search),
            hintText: "Cari data...",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
          textInputAction: TextInputAction.search,
          onSubmitted: (_) => controller.fetchProducts(),
        ),
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
              child: Text(
                "${controller.products.length} Data cocok",
                textAlign: TextAlign.left,
                style: AppTextStyles.hintGrey,
              ),
            ),

            //List Produk
            Expanded(
              child: RefreshIndicator(
                onRefresh: () {
                  controller.searchTextController.clear();
                  return controller.fetchProducts();
                },
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
                              Icon(Icons.restart_alt, color: Colors.blueAccent),
                              Text(
                                "Refresh untuk melihat data lainnya",
                                style: TextStyle(color: Colors.blueAccent),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    final item = controller.products[index];
                    return ProductListItem(
                      item: item,
                      isSearchMode: true,
                      onTap: () {
                        controller.showDetail(item);
                      },
                    );
                  },
                  separatorBuilder:
                      (BuildContext context, int index) => productSeparator(),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
