import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/product_provider.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  void _showAddProductDialog(BuildContext context) {
    final nameController = TextEditingController();
    final categoryController = TextEditingController();
    final brandController = TextEditingController();
    final stockController = TextEditingController();
    final priceController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Add Product'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: categoryController,
                  decoration: const InputDecoration(labelText: 'Category'),
                ),
                TextField(
                  controller: brandController,
                  decoration: const InputDecoration(labelText: 'Brand'),
                ),
                TextField(
                  controller: stockController,
                  decoration: const InputDecoration(labelText: 'Stock'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: priceController,
                  decoration: const InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final product = Product(
                  name: nameController.text.trim(),
                  category: categoryController.text.trim(),
                  brand: brandController.text.trim(),
                  stock: double.tryParse(stockController.text.trim()) ?? 0,
                  price: double.tryParse(priceController.text.trim()) ?? 0,
                );

                await context.read<ProductProvider>().addProduct(product);

                if (dialogContext.mounted) {
                  Navigator.pop(dialogContext);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final products = context.watch<ProductProvider>().products;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        backgroundColor: const Color(0xFF8B4513),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddProductDialog(context),
        backgroundColor: const Color(0xFF8B4513),
        child: const Icon(Icons.add),
      ),
      body: products.isEmpty
          ? const Center(child: Text('No products yet'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: const Icon(Icons.local_drink),
                    title: Text(product.name),
                    subtitle: Text(
                      'Category: ${product.category}
Brand: ${product.brand}',
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            ),
    );
  }
}
