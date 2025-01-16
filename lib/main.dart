import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:prodect_app/screens/login%20screen/login_page.dart';
import 'package:prodect_app/screens/homescreen%20features/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');

  runApp(MyApp(token: token));  // Pass the token to the app
}

class MyApp extends StatelessWidget {
  final String? token;

  MyApp({required this.token});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
       debugShowCheckedModeBanner: false,
      title: 'Product Management',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: token != null ? '/home' : '/',  // Check if the token exists
      routes: {
        '/': (context) => LoginPage(),
        '/home': (context) => ProductListPage(),
      },
    );
  }
}
