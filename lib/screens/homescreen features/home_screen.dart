import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controllers/product_controller.dart';
import 'add_product_screen.dart';
import 'search_product_page.dart';

class ProductListPage extends StatelessWidget {
  final ProductController productController = Get.put(ProductController());  // Initializing ProductController

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          // Logout button
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              // Show snackbar notification for logout
              Get.snackbar('Logout', 'You have been logged out.');

              // Clear the token from SharedPreferences to log out the user
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.remove('token'); // Remove saved token

              // Navigate back to the login page by removing all screens in the stack
              Get.offAllNamed('/'); 
            },
          ),
          // Search button
          IconButton(
            icon: const  Icon(Icons.search),
            onPressed: () {
              // Navigate to SearchProductPage when search button is pressed
              Get.to(() => SearchProductPage());
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          // Shop title
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "HI-FI Shop & Service",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Shop location
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Audio shop on Rustaveli Ave 57.",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.grey[600]),
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Description of the shop
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "This shop offers both products and services.",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.grey[600]),
              ),
            ),
          ),
         const  SizedBox(height: 10),
          // Section to display the products header
          Padding(
            padding:  const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              const   Text(
                  "Products",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    // Displaying the number of products in the list
                    Obx(() {
                      return Text(
                        "${productController.products.length} ",
                        style: const  TextStyle(fontSize: 14),
                      );
                    }),
                    const SizedBox(width: 200),
                    // "Show All" button, which can display all products (currently just shows a snackbar)
                    GestureDetector(
                      onTap: () {
                        Get.snackbar('Show All', 'Show all products functionality');
                      },
                      child: const  Text(
                        "Show All",
                        style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        const   SizedBox(height: 10),
          // ListView to display products horizontally
          Expanded(
            child: Obx(() {
              // If no products, display "No Products Found"
              if (productController.products.isEmpty) {
                return const Center(child: Text('No Products Found'));
              }
              // Display the list of products
              return ListView.builder(
                scrollDirection: Axis.horizontal,  // Horizontal scroll view
                itemCount: productController.products.length,  // Total products
                itemBuilder: (context, index) {
                  var product = productController.products[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      clipBehavior: Clip.none,  // To allow delete icon to be outside of the container
                      children: [
                        // Container for each product item
                        Container(
                          width: 180,  // Fixed width for product container
                          height: 180, // Fixed height for product container
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey[200],
                          ),
                          child: Column(
                            children: [
                              // If the product has an image, display it, otherwise show a placeholder
                              product['image'] != ''
                                  ? Image.file(File(product['image']!), height: 120, width: 180, fit: BoxFit.cover)
                                  : Container(
                                      height: 120,
                                      width: 180,
                                      color: Colors.grey,
                                      child: const  Center(child: Text('No Image')),
                                    ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Product name and price
                                    Text(
                                      product['name']!,
                                      style: const  TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                    Text(' Rs: ${product['price']}'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Delete icon to remove the product
                        Positioned(
                          top: -8,
                          right: -8,
                          child: IconButton(
                            icon: const Icon(Icons.delete_sharp, color: Colors.black, size: 40),
                            onPressed: () {
                              // Remove the product when delete icon is pressed
                              productController.deleteProduct(product['name']!);
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
      // Floating action button to add a new product
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => AddProductPage()),  // Navigate to AddProductPage when pressed
          child: Icon(Icons.add),  // Add icon for the button
        tooltip: 'Add Product',  // Tooltip when hovering over the button
      ),
    );
  }
}
