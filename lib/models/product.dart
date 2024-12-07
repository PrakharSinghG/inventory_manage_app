class Product {
  final String name;
  final String sku;
  final double price;
  int quantity;

  Product({required this.name, required this.sku, required this.price, required this.quantity});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'sku': sku,
      'price': price,
      'quantity': quantity,
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'],
      sku: json['sku'],
      price: json['price'],
      quantity: json['quantity'],
    );
  }
}