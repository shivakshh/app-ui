import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';




class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  
  

 Future<void> login() async {
  setState(() {
    _isLoading = true;
  });

  final response = await http.post(
    Uri.parse('https://reqres.in/api/login'),
    body: jsonEncode({
      'email': _emailController.text,
      'password': _passwordController.text,
    }),
    headers: {'Content-Type': 'application/json'},
  );

  setState(() {
    _isLoading = false;
  });

  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');

  if (response.statusCode == 200) {
    final token = jsonDecode(response.body)['token'];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);

    Navigator.pushReplacementNamed(context, '/home');  // Navigate to home after successful login
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Invalid credentials. Please try again.')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(  // Wrap everything in SingleChildScrollView to avoid overflow
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  'images/cart.gif', // Path to your image asset
                  width: 300, // You can adjust the width
                  height: 300, // You can adjust the height
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Login',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              // Email row
              Row(
                children: [
                  const Icon(Icons.email_rounded, color: Colors.grey), // Icon outside the field
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      width: 300, // Shortened underline width
                      child: TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email ID',
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey), // Normal underline
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue), // Focused underline
                          ),
                        ),
                        onChanged: (value) {
                          // Remove whitespaces as the user types
                          final trimmedValue = value.replaceAll(' ', '');
                          if (value != trimmedValue) {
                            _emailController.text = trimmedValue;
                            _emailController.selection = TextSelection.fromPosition(
                              TextPosition(offset: trimmedValue.length),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Password row
              Row(
                children: [
                  const Icon(Icons.lock_rounded, color: Colors.grey), // External icon
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      width: 300, // Control underline width
                      child: TextField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey), // Normal underline
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue), // Focused underline
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible; // Toggle visibility
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "Forgot Password?",
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 20),   
              // Login Button
              SizedBox(
                width: double.infinity, // Makes the button take the full width of the parent
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 33, 103, 243), // Blue background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // Slightly rounded corners
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16), // Height of the button
                  ),
                  onPressed: _isLoading ? null : login, // Disable button while loading
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 20), // Adds space between the buttons
              // OR Divider
              const Row(
                children: <Widget>[
                  Expanded(
                    child: Divider(
                      color: Colors.grey, // Color of the line
                      height: 1,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'OR',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey, // Color of the "OR" text
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: Colors.grey, // Color of the line
                      height: 1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Google login button
              SizedBox(
                width: double.infinity, // Makes the button take the full width of the parent
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 189, 189, 189), // Gray background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // Slightly rounded corners
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16), // Height of the button
                  ),
                  onPressed: () {
                    // Add the desired action here
                    print("Google Login Button Pressed");
                  },
                  child: Row(
                    children: [
                      // Image asset for Google logo, aligned to the left
                      Padding(
                        padding: const EdgeInsets.only(left: 15), // Optional padding to add some space
                        child: Image.asset(
                          'images/google.png', // Path to your Google logo image
                          width: 28, // Adjust size as needed
                          height: 28,
                        ),
                      ),
                      // Space between the icon and the text
                      // Expanded widget to push the text to the center
                     const  Expanded(
                        child: Text(
                          'Login with Google',
                          textAlign: TextAlign.center, // Centers the text
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 79, 78, 78), // Gray text color
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20), // Adds space before the "Register" text
              // Register Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'New to logistics? ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // Regular black text for "New to logistics?"
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Add the action for "Register" click here
                      print("Register Button Pressed");
                    },
                    child: const Text(
                      'Register',
                      style: TextStyle(
                        color: Colors.blue, // Blue color for the "Register" link
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        // Underline the "Register" text
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}