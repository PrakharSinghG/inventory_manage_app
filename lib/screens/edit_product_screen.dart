import 'package:flutter/material.dart';
import 'package:inventory_manage_app/providers/product_provider.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';

class EditProductScreen extends StatefulWidget {
  final int index;

  const EditProductScreen({super.key, required this.index});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _sku;
  late double _price;
  late int _quantity;

  @override
  void initState() {
    super.initState();
    final product = Provider.of<ProductProvider>(context, listen: false).products[widget.index];
    _name = product.name;
    _sku = product.sku;
    _price = product.price;
    _quantity = product.quantity;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Product')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(labelText: 'Product Name'),
                onSaved: (value) {
                  _name = value!;
                },
              ),
              TextFormField(
                initialValue: _sku,
                decoration: const InputDecoration(labelText: 'SKU'),
                onSaved: (value) {
                  _sku = value!;
                },
              ),
              TextFormField(
                initialValue: _price.toString(),
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  _price = double.parse(value!);
                },
              ),
              TextFormField(
                initialValue: _quantity.toString(),
                decoration: const InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  _quantity = int.parse(value!);
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final updatedProduct = Product(name: _name, sku: _sku, price: _price, quantity: _quantity);
                    Provider.of<ProductProvider>(context, listen: false).editProduct(widget.index, updatedProduct);
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Update Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}