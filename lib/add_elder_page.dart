import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'config.dart';


class AddElderPage extends StatefulWidget {
  const AddElderPage({Key? key}) : super(key: key);

  @override
  _AddElderPageState createState() => _AddElderPageState();
}

class _AddElderPageState extends State<AddElderPage> {
  final TextEditingController _elderNameController = TextEditingController();
  final TextEditingController _regionIdController = TextEditingController();

  bool _isLoading = false; // 添加加载状态变量

  Future<void> handleAddElder() async {
    setState(() {
      _isLoading = true; // 开始加载
    });

    final elderName = _elderNameController.text.trim();
    final regionId = _regionIdController.text.trim();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final url = Uri.parse('$baseUrl/API_add_elder');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-access-token': token ?? ''
      },
      body: jsonEncode({'elder_name': elderName, 'region_id': regionId}),
    );

    final data = jsonDecode(response.body);

    setState(() {
      _isLoading = false; // 加载结束
    });

    if (response.statusCode == 201 && data['message'] == '長者新增成功') {
      // Show success message
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: const Text('長者新增成功'),
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
            content: Text(data['error'] ?? '新增長者失敗'),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('新增長者',
          style: TextStyle(fontSize: 25),),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _elderNameController,
                  decoration: const InputDecoration(labelText: '長者姓名'),
                  style: const TextStyle(fontSize: 30),
                ),
                TextField(
                  controller: _regionIdController,
                  decoration: const InputDecoration(labelText: '常在區域編號'),
                  style: const TextStyle(fontSize: 30),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isLoading ? null : handleAddElder,
                  child: const Text('新增長者',
                    style: TextStyle(fontSize: 30),),
                ),
              ],
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
