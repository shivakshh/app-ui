import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductController extends GetxController with WidgetsBindingObserver {
  // Observable list to hold products
  var products = <Map<String, String>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadProducts(); // Load products from SharedPreferences when the app starts
    WidgetsBinding.instance.addObserver(this);  // Observe app lifecycle to detect when the app resumes
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      loadProducts();  // Reload products when app is resumed (if it's in the background)
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);  // Clean up lifecycle observer when the controller is disposed
    super.dispose();
  }

  // Load products from SharedPreferences and update the products list
  Future<void> loadProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? productsJson = prefs.getString('products');  // Retrieve the saved product list as a JSON string

    if (productsJson != null) {
      // Decode the JSON string to a list of maps
      var decodedProducts = List<Map<String, String>>.from(jsonDecode(productsJson));
      products.value = decodedProducts;  // Update the observable products list
    }
  }

  // Add a product to the list and save to SharedPreferences
  Future<void> addProduct(String name, String price, String? imagePath) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Check if the product already exists in the list (to prevent duplicates)
    if (products.any((product) => product['name'] == name)) {
      print("Duplicate found, showing snackbar");
      // Show a snackbar message to indicate the product already exists
      Get.snackbar(
        'Error', 
        'Product already exists', 
        snackPosition: SnackPosition.TOP, 
        backgroundColor: Colors.red, 
        duration: Duration(seconds: 2),
      );
      return;  // Exit the function if product already exists
    }

    // Create a new product map
    var newProduct = {
      'name': name,
      'price': price,
      'image': imagePath ?? '',  // If imagePath is null, set an empty string
    };
    products.add(newProduct);  // Add the new product to the observable list

    // Save the updated products list to SharedPreferences
    await prefs.setString('products', jsonEncode(products));
    print("Product added: $newProduct");
  }

  // Delete a product from the list and update SharedPreferences
  Future<void> deleteProduct(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Remove the product from the list by matching its name
    products.removeWhere((product) => product['name'] == name);

    // Save the updated products list to SharedPreferences
    await prefs.setString('products', jsonEncode(products));
    print("Product deleted: $name");
  }
}
