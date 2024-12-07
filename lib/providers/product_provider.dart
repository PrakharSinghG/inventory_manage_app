import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';
import 'dart:convert';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];

  List<Product> get products => _products;

  Future<void> loadProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final String? productData = prefs.getString('products');
    if (productData != null) {
      List<dynamic> jsonList = json.decode(productData);
      _products = jsonList.map((json) => Product.fromJson(json)).toList();
    }
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    _products.add(product);
    await _saveProducts();
    notifyListeners();
  }

  Future<void> editProduct(int index, Product product) async {
    _products[index] = product;
    await _saveProducts();
    notifyListeners();
  }

  Future<void> deleteProduct(int index) async {
    _products.removeAt(index);
    await _saveProducts();
    notifyListeners();
  }

  Future<void> _saveProducts() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('products',
        json.encode(_products.map((product) => product.toJson()).toList()));
  }
}
