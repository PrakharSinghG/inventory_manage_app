import 'package:flutter/material.dart';
import 'package:inventory_manage_app/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import 'add_product_screen.dart';
import 'edit_product_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products',
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.isDarkMode
                  ? Icons.light_mode_rounded
                  : Icons.dark_mode_rounded,
            ),
            onPressed: themeProvider.toggleTheme,
          ),
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AddProductScreen()));
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search by name or SKU...',
                prefixIcon: const Icon(Icons.search_rounded),
                filled: true,
                fillColor: Theme.of(context).cardColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
        ),
      ),
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
          final products = productProvider.products
              .where((product) =>
                  product.name.toLowerCase().contains(_searchQuery) ||
                  product.sku.toLowerCase().contains(_searchQuery))
              .toList();

          if (products.isEmpty) {
            return const Center(
              child: Text(
                'No products found. Add some!',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(8.0),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              final lowStock = product.quantity < 5;

              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => EditProductScreen(index: index)));
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: lowStock
                        ? (themeProvider.isDarkMode
                            ? Colors.redAccent[400]
                            : Colors.red[100])
                        : Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 16.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Theme.of(context).primaryColorLight,
                        child: Text(
                          product.name[0].toUpperCase(),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColorDark,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .color,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "SKU: ${product.sku}",
                              style: TextStyle(
                                fontSize: 12,
                                color: lowStock
                                    ? (themeProvider.isDarkMode
                                        ? Colors.white
                                        : Colors.black)
                                    : Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .color,
                              ),
                            ),
                            Text(
                              "Price: \$${product.price.toStringAsFixed(2)}",
                              style: TextStyle(
                                fontSize: 12,
                                color: lowStock
                                    ? (themeProvider.isDarkMode
                                        ? Colors.white
                                        : Colors.black)
                                    : Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .color,
                              ),
                            ),
                            Text(
                              "Quantity: ${product.quantity}",
                              style: TextStyle(
                                fontSize: 12,
                                color: lowStock
                                    ? (themeProvider.isDarkMode
                                        ? Colors.white
                                        : Colors.black)
                                    : Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .color,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline_rounded,
                            color: Colors.redAccent),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Confirm Delete'),
                              content: const Text(
                                  'Are you sure you want to delete this product?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(ctx).pop(),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    productProvider.deleteProduct(index);
                                    Navigator.of(ctx).pop();
                                  },
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 10),
          );
        },
      ),
    );
  }
}
