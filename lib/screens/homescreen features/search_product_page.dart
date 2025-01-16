import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/product_controller.dart';

class SearchProductPage extends StatefulWidget {
  @override
  _SearchProductPageState createState() => _SearchProductPageState();
}

class _SearchProductPageState extends State<SearchProductPage> {
  final ProductController productController = Get.find(); // Get the ProductController instance
  TextEditingController searchController = TextEditingController(); // Controller for the search input

  // Function to filter products based on the search query
  List<Map<String, String>> getFilteredProducts() {
    // If the search query is empty, return an empty list (no products are shown)
    if (searchController.text.isEmpty) {
      return [];
    }

    // Filter products based on the search query (case-insensitive)
    return productController.products
        .where((product) => product['name']!
            .toLowerCase()
            .contains(searchController.text.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Products'), // AppBar title
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0), // Padding around the body content
        child: Column(
          children: [
            // Search Bar
            TextField(
              controller: searchController, // Controller for the search field
              decoration: InputDecoration(
                labelText: 'Search by Product Name', // Label inside the search field
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const  Icon(Icons.search), // Search icon
                  onPressed: () {
                    setState(() {}); // Trigger a rebuild when the search icon is pressed
                  },
                ),
              ),
              onChanged: (query) {
                setState(() {}); // Update UI as the user types
              },
            ),
            const SizedBox(height: 20),
            // Display filtered products based on the search query
            Expanded(
              child: Obx(() {
                var filteredProducts = getFilteredProducts(); // Get the filtered products

                // If no products match the search query and no search has been made yet
                if (filteredProducts.isEmpty && searchController.text.isEmpty) {
                  return const Center(child: Text('No Products')); // No products to show
                }

                // If no products match the search query after typing
                if (filteredProducts.isEmpty) {
                  return const Center(child: Text('No Products Found')); // No matching products
                }

                // If matching products are found
                return ListView.builder(
                  itemCount: filteredProducts.length, // Number of filtered products
                  itemBuilder: (context, index) {
                    var product = filteredProducts[index]; // Get each product from the filtered list
                    return Padding(
                      padding: const EdgeInsets.all(8.0), // Padding around each product item
                      child: ListTile(
                        title: Text(product['name']!), // Display product name
                        subtitle: Text('Price: ${product['price']}'), // Display product price
                        leading: product['image'] != ''
                            ? Image.file(File(product['image']!), // If image exists, display it
                                width: 50, height: 50, fit: BoxFit.cover)
                            : const Icon(Icons.image), // Otherwise, show a default image icon
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red), // Delete icon
                          onPressed: () {
                            productController.deleteProduct(product['name']!); // Delete product when clicked
                          },
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
