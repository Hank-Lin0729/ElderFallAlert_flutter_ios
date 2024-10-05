import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'login_page.dart';
import 'config.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _botKeyController = TextEditingController();

  bool _isLoading = false; // 添加加载状态变量

  Future<void> handleRegister() async {
    setState(() {
      _isLoading = true; // 开始加载
    });

    final name = _nameController.text.trim();
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();
    final botKey = _botKeyController.text.trim();

    final url = Uri.parse('$baseUrl/API_register');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'username': username,
        'password': password,
        'bot_key': botKey
      }),
    );

    final data = jsonDecode(response.body);

    setState(() {
      _isLoading = false; // 加载结束
    });

    if (response.statusCode == 201 && data['message'] == '註冊成功') {
      // Registration successful, navigate to login page
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: const Text('註冊成功，請登入'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                child: const Text('確定'),
              ),
            ],
          );
        },
      );
    } else {
      // Show error message
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(data['error'] ?? '註冊失敗'),
          );
        },
      );
    }
  }

  void switchToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('註冊',
          style: TextStyle(fontSize: 25),), 
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              // Avoid overflow when keyboard appears
              child: Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width *
                        0.8, // 70% of the screen width
                    child: Image.asset(
                      'assets/images/Brand.png', // Use the relative image path
                      fit: BoxFit.contain, // Maintain the aspect ratio
                    ),
                  ),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: '姓名'),
                    style: const TextStyle(fontSize: 30),
                  ),
                  TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(labelText: '帳號'),
                    style: const TextStyle(fontSize: 30),
                  ),
                  TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(labelText: '密碼'),
                    style: const TextStyle(fontSize: 30),
                    obscureText: true,
                  ),
                  TextField(
                    controller: _botKeyController,
                    decoration: const InputDecoration(labelText: 'Bot Key'),
                    style: const TextStyle(fontSize: 30),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _isLoading ? null : handleRegister,
                    child: const Text('註冊',style: TextStyle(
                        fontSize: 24, // 設置文字大小為18
                      ),),
                    
                  ),
                  TextButton(
                    onPressed: switchToLogin,
                    child: const Text('已經有帳號了？登入',style: TextStyle(
                        fontSize: 20, // 設置文字大小為18
                      ),),
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
