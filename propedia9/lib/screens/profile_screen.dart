import 'package:flutter/material.dart';
import 'edit_profile_screen.dart';
import 'pembeli_home.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.lightBlue),
        title: const Text(
          'Pengaturan',
          style: TextStyle(color: Colors.lightBlue),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.menu, color: Colors.black),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.lightBlue,
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListView(
            shrinkWrap: true,
            children: [
              _menuItem(context, 'EDIT PROFILE', onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfileScreen()));
              }),
              _menuItem(context, 'LANGUAGE'),
              _menuItem(context, 'CONTACTS'),
              _switchItem('NOTIFICATIONS'),
              _menuItem(context, 'SAVED'),
              _menuItem(context, 'PROPERTY'),
              _menuItem(context, 'HELP'),
              _menuItem(context, 'ABOUT'),
              _menuItem(context, 'LOGOUT', isLogout: true),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        selectedItemColor: Colors.lightBlue,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BuyerHomeNew()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profil'),
        ],
      ),
    );
  }

  Widget _menuItem(BuildContext context, String title, {VoidCallback? onTap, bool isLogout = false}) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      trailing: isLogout ? null : const Icon(Icons.chevron_right, color: Colors.white),
      onTap: onTap,
    );
  }

  Widget _switchItem(String title) {
    return SwitchListTile(
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      value: true,
      onChanged: (val) {},
      activeColor: Colors.black,
    );
  }
}
