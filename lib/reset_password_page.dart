//reset_password_page.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'config.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({Key? key}) : super(key: key);

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController =
  TextEditingController();

  Future<void> handleResetPassword() async {
    final oldPassword = _oldPasswordController.text.trim();
    final newPassword = _newPasswordController.text.trim();
    final confirmNewPassword = _confirmNewPasswordController.text.trim();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final url =
    Uri.parse('$baseUrl/API_reset_password');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-access-token': token ?? ''
      },
      body: jsonEncode({
        'old_password': oldPassword,
        'new_password': newPassword,
        'confirm_new_password': confirmNewPassword
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data['message'] == '更新成功') {
      // Show success message
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: const Text('密碼更新成功'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context); // Return to previous page
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
            content: Text(data['error'] ?? '密碼更新失敗'),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('重設密碼',
          style: TextStyle(fontSize: 25),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _oldPasswordController,
              decoration: const InputDecoration(labelText: '舊密碼'),
              obscureText: true,
              style: const TextStyle(fontSize: 30),
            ),
            TextField(
              controller: _newPasswordController,
              decoration: const InputDecoration(labelText: '新密碼'),
              obscureText: true,
              style: const TextStyle(fontSize: 30),
            ),
            TextField(
              controller: _confirmNewPasswordController,
              decoration: const InputDecoration(labelText: '重複新密碼'),
              obscureText: true,
              style: const TextStyle(fontSize: 30),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: handleResetPassword,
              child: const Text('更新密碼',
                style: TextStyle(fontSize: 30),),
            ),
          ],
        ),
      ),
    );
  }
}
