import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prodect_app/controllers/product_controller.dart';

class AddProductPage extends StatefulWidget {
  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();  // Form key to validate form fields
  final TextEditingController _nameController = TextEditingController();  // Controller for product name input
  final TextEditingController _priceController = TextEditingController();  // Controller for price input
  String? _imagePath;  // To store the selected image path

  // Function to pick an image from the gallery
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);  // Open gallery to pick an image

    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;  // Set the selected image path
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the ProductController instance using Get.find() to access its methods
    final ProductController productController = Get.find<ProductController>();

    return Scaffold(
      appBar: AppBar(title: Text('Add Product')),  // App bar with the title "Add Product"
      body: Padding(
        padding:const  EdgeInsets.all(16.0),  // Padding for the entire form
        child: Form(
          key: _formKey,  // Assign form key for validation
          child: Column(
            children: [
              // Text field for product name
              TextFormField(
                controller: _nameController,  // Controller for text input
                decoration: const  InputDecoration(labelText: 'Product Name'),  // Label for the input field
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Product name is required';  // Show error if the input is empty
                  }
                  return null;  // Return null if validation is successful
                },
              ),
              const SizedBox(height: 16.0),  // Space between form fields
              
              // Text field for price input
              TextFormField(
                controller: _priceController,  // Controller for text input
                keyboardType: TextInputType.number,  // Show numeric keyboard
                decoration:const  InputDecoration(labelText: 'Price'),  // Label for the input field
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Price is required';  // Show error if the input is empty
                  }
                  return null;  // Return null if validation is successful
                },
              ),
              const SizedBox(height: 16.0),  // Space between form fields
              
              // Button to pick an image
              ElevatedButton(
                onPressed: _pickImage,  // Trigger image picking function when pressed
                child: const  Text('Pick Image'),
              ),
              
              // Display the picked image if it's not null
              if (_imagePath != null) ...[
                const SizedBox(height: 16.0),
                Image.file(File(_imagePath!), height: 100),  // Show the image thumbnail with height 100
              ],
              
              const SizedBox(height: 16.0),  // Space before the Add Product button
              
              // Button to add product
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // If the form is valid, call the addProduct function from ProductController
                    await productController.addProduct(
                      _nameController.text,  // Pass product name
                      _priceController.text,  // Pass product price
                      _imagePath,  // Pass the image path (if any)
                    );
                    Get.back();  // Go back to the product list page after adding the product
                  }
                },
                child: const Text('Add Product'),  // Text displayed on the button
              ),
            ],
          ),
        ),
      ),
    );
  }
}
