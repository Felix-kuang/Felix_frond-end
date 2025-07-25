import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BottomSheetWidget extends StatelessWidget {
  final formatCurrency = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  final Map<String, dynamic> product;
  final VoidCallback onDeleteItem;
  final VoidCallback onEditItem;

  BottomSheetWidget({
    super.key,
    required this.product,
    required this.onDeleteItem,
    required this.onEditItem,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = product['imageUrl']?.toString();
    final hasImage = imageUrl != null && imageUrl.trim().isNotEmpty;

    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.all(16.0),
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Placeholder Section
            hasImage
                ? Center(
                  child: Image.network(
                    imageUrl,
                    height: 150,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _imagePlaceholder();
                    },
                  ),
                )
                : _imagePlaceholder(),
            const SizedBox(height: 20),
      
            // Product Details Section
            _buildDetailRow(
              'Nama barang',
              product['nama_barang']?.toString() ?? 'N/A',
            ),
            _buildDetailRow(
              'Kategori',
              product['nama_kategori']?.toString() ?? 'N/A',
            ),
            _buildDetailRow(
              'Kelompok',
              "Kelompok ${product['kelompok_barang']?.toString()}" ?? 'N/A',
            ),
            _buildDetailRow('Stok', product['stok']?.toString() ?? 'N/A'),
      
            const SizedBox(height: 20),
      
            // Price Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Harga',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                Text(
                  formatCurrency.format(product['harga']),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
      
            // Buttons Section
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onDeleteItem,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text(
                      'Hapus Barang',
                      style: TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onEditItem,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade800, // Background color
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text(
                      'Edit Barang',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildDetailRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 16, color: Colors.grey[600])),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ],
    ),
  );
}

Widget _imagePlaceholder() {
  return Container(
    height: 150,
    width: double.infinity,
    decoration: BoxDecoration(
      color: Colors.grey[200],
      borderRadius: BorderRadius.circular(8.0),
    ),
    child: Icon(Icons.broken_image, size: 80, color: Colors.grey[400]),
  );
}
