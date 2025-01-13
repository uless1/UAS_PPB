import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../admin/dashboard_page.dart';
import '../user/menu_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = _usernameController.text;
    String password = _passwordController.text;

    if (username == 'admin' && password == 'admin123') {
      await prefs.setString('role', 'admin'); // Set status sebagai admin
      Navigator.pushReplacementNamed(context, '/admin_dashboard');
    } else if (username == 'user' && password == 'user123') {
      await prefs.setString('role', 'user'); // Set status sebagai user
      Navigator.pushReplacementNamed(context, '/user_menu');
    } else {
      _showErrorDialog('Username atau Password salah.');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Kesalahan'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Tambahkan logo di sini
            Image.asset(
              'assets/images/logo.png', // Path logo
              height: 150, 
              width: 150, 
            ),
            SizedBox(height: 40), // Jarak antara logo dan form login
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            SizedBox(height: 20), // Jarak antara username dan password field
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
