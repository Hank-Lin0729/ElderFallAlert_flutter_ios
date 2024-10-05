import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';
import 'reset_password_page.dart';
import 'reset_botkey_page.dart';
import 'add_elder_page.dart';
import 'photo_gallery_page.dart';
import 'elder_list_page.dart';
import 'emergency_list_page.dart';
import 'config.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  String name = '';
  String username = '';
  bool _isLoading = false; // 添加加载状态变量

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
  }

  Future<void> fetchUserInfo() async {
    setState(() {
      _isLoading = true; // 开始加载
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final url = Uri.parse('$baseUrl/API_get_user_info');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-access-token': token ?? ''
      },
    );

    setState(() {
      _isLoading = false; // 加载结束
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        name = data['name'];
        username = data['username'];
      });
    } else if (response.statusCode == 401) {
      // Token invalid, redirect to login
      await prefs.remove('token');
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  Future<void> deleteAllRecords() async {
    setState(() {
      _isLoading = true; // 开始加载
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final url = Uri.parse('$baseUrl/API_delete_all_records');

    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'x-access-token': token ?? '',
        },
      );

      setState(() {
        _isLoading = false; // 加载结束
      });

      if (response.statusCode == 200) {
        // 刪除成功，提示用戶
        if (!mounted) return;
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: const Text('所有列表記錄已刪除'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('確定'),
                ),
              ],
            );
          },
        );
      } else {
        // 處理錯誤
        final data = jsonDecode(response.body);
        if (!mounted) return;
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content:
                  Text('刪除失敗: ${response.statusCode}\n${data['error']}'),
            );
          },
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false; // 加载结束
      });
      print('Error occurred: $e');
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text('發生錯誤：$e'),
          );
        },
      );
    }
  }

  Future<void> handleLogout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  void navigateToResetPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ResetPasswordPage()),
    );
  }

  void navigateToResetBotKey() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ResetBotKeyPage()),
    );
  }

  void navigateToAddElder() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddElderPage()),
    );
  }

  void navigateToPhotoGallery() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PhotoGalleryPage()),
    );
  }

  void navigateToElderList() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ElderListPage()),
    );
  }

  void navigateToEmergencyList() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EmergencyListPage()),
    );
  }

  void confirmDeleteAllRecords() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('確認刪除', style: TextStyle(fontSize: 30)),
          content: const Text('您確定要刪除所有列表記錄嗎？此操作無法撤銷。',
              style: TextStyle(fontSize: 25)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('取消', style: TextStyle(fontSize: 20)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                deleteAllRecords();
              },
              child: const Text('確定', style: TextStyle(fontSize: 20)),
            ),
          ],
        );
      },
    );
  }

  // Add more navigation functions as needed.

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('用戶專屬頁面',
          style: TextStyle(
            fontSize: 25,
          )),
      actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: handleLogout,
        ),
      ],
    ),
    body: Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                '歡迎, $name!',
                style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              Text(
                '您的帳號是: $username',
                style: const TextStyle(fontSize: 20, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2, // 每行兩個按鈕
                  mainAxisSpacing: 16.0, // 垂直間距
                  crossAxisSpacing: 16.0, // 水平間距
                  childAspectRatio: 1.0, // 寬高比為1，確保按鈕為正方形
                  children: [
                    _buildGridButton(
                      label: '重設密碼',
                      color: Colors.blue,
                      onPressed: navigateToResetPassword,
                    ),
                    _buildGridButton(
                      label: '重設 Bot Key',
                      color: Colors.green,
                      onPressed: navigateToResetBotKey,
                    ),
                    _buildGridButton(
                      label: '新增長者',
                      color: Colors.orange,
                      onPressed: navigateToAddElder,
                    ),
                    _buildGridButton(
                      label: '查看長者列表',
                      color: Colors.purple,
                      onPressed: navigateToElderList,
                    ),
                    _buildGridButton(
                      label: '查看事件列表',
                      color: Colors.red,
                      onPressed: navigateToEmergencyList,
                    ),
                     _buildGridButton(
                       label: '查看照片',
                       color: Colors.teal,
                       onPressed: navigateToPhotoGallery,
                     ),
                    _buildGridButton(
                      label: '刪除所有列表記錄',
                      color: Colors.grey,
                      onPressed: confirmDeleteAllRecords,
                    ),
                    // 可以根據需要添加更多按鈕
                  ],
                ),
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

/// 建立一個自定義的方塊按鈕


}
Widget _buildGridButton({
  required String label,
  required Color color,
  required VoidCallback onPressed,
}) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white, backgroundColor: color, // 按鈕文字色
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 5,
    ),
    onPressed: onPressed,
    child: Center(
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
      ),
    ),
  );
}