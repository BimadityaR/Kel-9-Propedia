import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const ProPediaApp());
}

class ProPediaApp extends StatelessWidget {
  const ProPediaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ProPedia',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue, // Changed from lightBlue to blue
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const SplashDecider(),
    );
  }
}

class SplashDecider extends StatefulWidget {
  const SplashDecider({super.key});

  @override
  State<SplashDecider> createState() => _SplashDeciderState();
}

class _SplashDeciderState extends State<SplashDecider> {
  bool isLoading = true;
  bool isLoggedIn = false;
  String? userEmail; // Added to store user email

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  Future<void> checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    final password = prefs.getString('password');

    setState(() {
      isLoggedIn = email != null && password != null;
      userEmail = email; // Store the email to pass to HomeScreen
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return isLoggedIn
        ? HomeScreen(userName: userEmail ?? 'User') // Handle null case
        : const LoginScreen();
  }
}
