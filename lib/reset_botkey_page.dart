//reset_botkey_page.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'config.dart';

class ResetBotKeyPage extends StatefulWidget {
  const ResetBotKeyPage({Key? key}) : super(key: key);

  @override
  _ResetBotKeyPageState createState() => _ResetBotKeyPageState();
}

class _ResetBotKeyPageState extends State<ResetBotKeyPage> {
  final TextEditingController _newBotKeyController = TextEditingController();

  Future<void> handleResetBotKey() async {
    final newBotKey = _newBotKeyController.text.trim();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final url = Uri.parse('$baseUrl/API_reset_botkey');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-access-token': token ?? ''
      },
      body: jsonEncode({'new_bot_key': newBotKey}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data['message'] == '更新成功') {
      // Show success message
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: const Text('Bot Key 更新成功'),
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
            content: Text(data['error'] ?? 'Bot Key 更新失敗'),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('重設 Bot Key',
          style: TextStyle(
            fontSize: 25,
          ),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _newBotKeyController,
              decoration: const InputDecoration(labelText: '新 Bot Key'),
              style: const TextStyle(fontSize: 30),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: handleResetBotKey,
              child: const Text('更新 Bot Key',
                style: TextStyle(fontSize: 30),),
              
            ),
          ],
        ),
      ),
    );
  }
}
