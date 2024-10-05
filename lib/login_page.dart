import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'user_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'register_page.dart';
import 'config.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false; // 添加加载状态变量

  Future<void> handleLogin() async {
    setState(() {
      _isLoading = true; // 开始加载
    });

    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    final url = Uri.parse('$baseUrl/API_login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    final data = jsonDecode(response.body);

    setState(() {
      _isLoading = false; // 加载结束
    });

    if (response.statusCode == 200 && data['message'] == '登入成功') {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['token']);
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const UserPage()),
      );
    } else {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(data['error'] ?? '登入失敗'),
          );
        },
      );
    }
  }

  void navigateToRegister() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const RegisterPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('登入',
        style: TextStyle(fontSize: 25),),), // Add this line 
      body: Stack(
        children: [
          SingleChildScrollView(
            // Use this to prevent overflow on smaller screens
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Add the image at the top
                  SizedBox(
                    width: MediaQuery.of(context).size.width *
                        0.8, // 70% of the screen width
                    child: Image.asset(
                      'assets/images/Brand.png', // Replace with your image path
                      fit: BoxFit.contain, // Maintain the aspect ratio
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(labelText: '帳號'),
                    style: const TextStyle(fontSize: 30),
                  ),
                  TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(labelText: '密碼'),
                    obscureText: true,
                    style: const TextStyle(fontSize: 30),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _isLoading ? null : handleLogin, // 防止重複點擊
                    child: const Text(
                      '登入',
                      style: TextStyle(
                        fontSize: 24, // 設置文字大小為18
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: navigateToRegister,
                    child: const Text(
                      '還沒有帳號？註冊',
                      style: TextStyle(
                        fontSize: 20, // 設置文字大小為16
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5), // 半透明背景
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
