import 'package:flutter/material.dart';
import 'elder_info.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'config.dart';

class ElderListPage extends StatefulWidget {
  const ElderListPage({Key? key}) : super(key: key);

  @override
  _ElderListPageState createState() => _ElderListPageState();
}

class _ElderListPageState extends State<ElderListPage> {
  List<ElderInfo> elders = [];
  bool _isLoading = false; // 添加加载状态变量

  @override
  void initState() {
    super.initState();
    fetchElders();
  }

  Future<void> fetchElders() async {
    setState(() {
      _isLoading = true; // 开始加载
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final url = Uri.parse('$baseUrl/API_get_elders');

    try {
      final response = await http.get(
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
        final data = jsonDecode(response.body);
        List<ElderInfo> loadedElders = [];
        for (var item in data['elders']) {
          loadedElders.add(ElderInfo.fromJson(item));
        }
        setState(() {
          elders = loadedElders;
        });
      } else {
        // 處理錯誤
        if (!mounted) return;
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(
                  '獲取長者資料失敗: ${response.statusCode}\n${response.body}'),
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

  Future<void> deleteElder(int elderId) async {
    setState(() {
      _isLoading = true; // 开始加载
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final url = Uri.parse('$baseUrl/API_delete_elder');

    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'x-access-token': token ?? '',
        },
        body: jsonEncode({'elder_id': elderId}),
      );

      setState(() {
        _isLoading = false; // 加载结束
      });

      if (response.statusCode == 200) {
        // 刪除成功，刷新列表
        fetchElders();
      } else {
        // 處理錯誤
        final data = jsonDecode(response.body);
        if (!mounted) return;
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content:
                  Text('刪除長者失敗: ${response.statusCode}\n${data['error']}'),
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

void confirmDelete(int elderId) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text(
          '確認刪除',
          style: TextStyle(
            fontSize: 30, // 設置標題文字大小
          ),
        ),
        content: const Text(
          '您確定要刪除此長者嗎？',
          style: TextStyle(
            fontSize: 25, // 設置內容文字大小
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              '取消',
              style: TextStyle(
                fontSize: 20, // 設置按鈕文字大小
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              deleteElder(elderId);
            },
            child: const Text(
              '確定',
              style: TextStyle(
                fontSize: 20, // 設置按鈕文字大小
                color: Colors.red, // 設置按鈕文字顏色（例如紅色表示警告）
              ),
            ),
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
        title: const Text('長者列表'),
      ),
      body: Stack(
        children: [
      RefreshIndicator(
        onRefresh: fetchElders,
        child: ListView.builder(
          itemCount: elders.length,
          itemBuilder: (context, index) {
            final elder = elders[index];
            return Container(
              color: Colors.white, // 根據需要設置背景色
              child: ListTile(
                title: Text(
                  elder.elderName,
                  style: TextStyle(
                    fontSize: 30, // 設置標題文字大小
                  ),
                ),
                subtitle: Text(
                  '區域編號: ${elder.regionId}',
                  style: TextStyle(
                    fontSize: 23, // 設置副標題文字大小
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    confirmDelete(elder.elderId);
                  },
                  tooltip: '刪除', // 可選：設置按鈕提示
                ),
                // 可選：設置 ListTile 的其他屬性，如分隔線、點擊事件等
              ),
            );
          },
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
