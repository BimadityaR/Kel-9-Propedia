import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'screens/map_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Memuat token dari secure storage sebelum aplikasi dijalankan
  await ApiService.initialize();

  runApp(const ProPediaApp());
}

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class ProPediaApp extends StatelessWidget {
  const ProPediaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ProPedia',
      navigatorObservers: [routeObserver],
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
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
  String? userEmail;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = await ApiService.getToken();

    if (token != null) {
      try {
        // Ambil email dari SharedPreferences (jika disimpan saat login)
        final email = prefs.getString('email');
        setState(() {
          isLoggedIn = true;
          userEmail = email;
          isLoading = false;
        });
      } catch (e) {
        // Handle exception
        setState(() {
          isLoggedIn = false;
          userEmail = null;
          isLoading = false;
        });
      }
    } else {
      setState(() {
        isLoggedIn = false;
        userEmail = null;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return isLoggedIn
        ? HomeScreen(userName: userEmail ?? 'User')
        : const LoginScreen();
  }
}
