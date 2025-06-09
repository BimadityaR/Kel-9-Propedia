import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/map_screen.dart';
import 'services/secure_storage.dart';
import 'package:http/http.dart' as http;
import 'screens/add_property_screen.dart';
import 'package:propedia9/models/property.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProPediaApp());
}

// RouteObserver untuk navigasi jika diperlukan
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
    checkLogin();
  }

  Future<void> checkLogin() async {
    final token = await SecureStorage.getToken();
    final email = await SecureStorage.getEmail();

    setState(() {
      isLoggedIn = token != null;
      userEmail = email;
      isLoading = false;
    });
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