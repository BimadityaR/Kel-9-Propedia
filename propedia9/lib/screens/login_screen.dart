import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';
import 'register_screen.dart';
import 'admin_home.dart';
import 'pembeli_home.dart';
import 'penjual_home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> login() async {
    setState(() {
      _isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('email');
    final savedPassword = prefs.getString('password');
    final savedRole = prefs.getString('role');

    await Future.delayed(const Duration(seconds: 1)); // Simulasi loading

    if (emailController.text == savedEmail &&
        passwordController.text == savedPassword) {
      Widget nextScreen;

      switch (savedRole) {
        case 'Admin':
          // dialog konfirmasi untuk admin
          showAdminConfirmationDialog(context);
          return;
        case 'Pembeli':
          nextScreen = const BuyerHomeNew();
          break;
        case 'Penjual':
          nextScreen = const SellerHome();
          break;
        default:
          nextScreen = HomeScreen(userName: savedEmail!);
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => nextScreen),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login gagal. Email atau password salah.'),
        ),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  void showAdminConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Konfirmasi Admin'),
            content: const Text('Anda akan masuk sebagai Admin. Lanjutkan?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  setState(() {
                    _isLoading = false;
                  });
                },
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const AdminHome()),
                  );
                },
                child: const Text('Lanjutkan'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: ListView(
          children: [
            const SizedBox(height: 40),
            const Text(
              'Welcome to ProPedia',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const Text('Log in to continue', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 40),
            Center(
              child: Image.asset(
                'assets/logo_propedia.jpg',
                width: 150,
                height: 150,
              ),
            ),
            const SizedBox(height: 40),
            const Text('Email Address'),
            const SizedBox(height: 8),
            _inputField(
              Icons.email,
              'Enter your email address',
              emailController,
            ),
            const SizedBox(height: 20),
            const Text('Password'),
            const SizedBox(height: 8),
            _inputField(
              Icons.lock,
              'Enter your password',
              passwordController,
              isPassword: true,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: const Text(
                  'Forgot Your Password?',
                  style: TextStyle(
                    color: Colors.lightBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : login,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlue,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child:
                  _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                        'LOGIN',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
            ),
            const SizedBox(height: 30),
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RegisterScreen()),
                  );
                },
                child: const Text(
                  "Don't have an account? Sign Up",
                  style: TextStyle(color: Colors.lightBlue),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputField(
    IconData icon,
    String hint,
    TextEditingController controller, {
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(25),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.black),
          hintText: hint,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }
}
