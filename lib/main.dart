import 'package:flutter/material.dart';
import 'package:inventory_manage_app/providers/product_provider.dart';
import 'package:inventory_manage_app/providers/theme_provider.dart';
import 'package:inventory_manage_app/screens/product_list_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductProvider()..loadProducts()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Inventory Management',
            theme: themeProvider.theme, // Use the selected theme
            home: const ProductListScreen(),
          );
        },
      ),
    );
  }
}
