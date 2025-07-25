import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../styles/app_text_styles.dart';

class ProductListItem extends StatelessWidget {
  final Map item;
  final bool isEditMode;
  final bool isSearchMode;
  final bool? isChecked;
  final VoidCallback? onTap;
  final ValueChanged<bool?>? onChecked;

  const ProductListItem({
    super.key,
    required this.item,
    this.isEditMode = false,
    this.isSearchMode = false,
    this.isChecked,
    this.onTap,
    this.onChecked,
  });

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    if (isEditMode) {
      return CheckboxListTile(
        controlAffinity: ListTileControlAffinity.leading,
        title: Text(item['nama_barang'] ?? '-', style: AppTextStyles.title),
        subtitle: Text('Stok : ${item['stok']}', style: AppTextStyles.subtitle),
        secondary: Text(
          formatCurrency.format(item['harga']),
          style: AppTextStyles.price,
        ),
        value: isChecked ?? false,
        onChanged: onChecked,
      );
    }

    if (isSearchMode) {
      return ListTile(
        title: Text(item['nama_barang'] ?? '-', style: AppTextStyles.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${item['nama_kategori']}', style: AppTextStyles.subtitle),
            Text('Kelompok ${item['kelompok_barang']}', style: AppTextStyles.subtitle),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "Stok : ${item['stok']}",
              style: AppTextStyles.smallGrey,
            ),
            Text(
              formatCurrency.format(item['harga']),
              style: AppTextStyles.price,
            ),
          ],
        ),
        onTap: onTap,
      );
    }

    return ListTile(
      title: Text(item['nama_barang'] ?? '-', style: AppTextStyles.title),
      subtitle: Text('Stok : ${item['stok']}', style: AppTextStyles.subtitle),
      trailing: Text(
        formatCurrency.format(item['harga']),
        style: AppTextStyles.price,
      ),
      onTap: onTap,
    );
  }
}
