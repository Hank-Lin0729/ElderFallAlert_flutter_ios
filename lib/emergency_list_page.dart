import 'package:flutter/material.dart';
import 'emergency_info.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'config.dart';

class EmergencyListPage extends StatefulWidget {
  const EmergencyListPage({Key? key}) : super(key: key);

  @override
  _EmergencyListPageState createState() => _EmergencyListPageState();
}

class _EmergencyListPageState extends State<EmergencyListPage> {
  List<EmergencyInfo> emergencies = [];
  bool _isLoading = false; // 添加加载状态变量

  @override
  void initState() {
    super.initState();
    fetchEmergencies();
  }

  Future<void> fetchEmergencies() async {
    setState(() {
      _isLoading = true; // 开始加载
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final url =
        Uri.parse('$baseUrl/API_get_emergencies');

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
      List<EmergencyInfo> loadedEmergencies = [];
      for (var item in data['emergencies']) {
        loadedEmergencies.add(EmergencyInfo.fromJson(item));
      }
      setState(() {
        emergencies = loadedEmergencies;
      });
    } else {
      // 处理错误
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            content: Text('無法獲得事件列表'),
          );
        },
      );
    }
  }

  String formatTime(String timeString) {
    // 格式化时间字符串，如果需要的话
    return timeString;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('事件列表',
          style: TextStyle(fontSize: 25),),
      ),
      body: Stack(
        children: [
  RefreshIndicator(
    onRefresh: fetchEmergencies,
    child: ListView.builder(
      itemCount: emergencies.length,
      itemBuilder: (context, index) {
        final emergency = emergencies[index];
        return Container(
          color: emergency.getColor(),
          child: ListTile(
            title: Text(
              emergency.emergencyMessage,
              style: TextStyle(
                fontSize: 25, // 設置標題文字大小
              ),
            ),
            subtitle: Text(
              '區域編號: ${emergency.regionId}\n時間: ${formatTime(emergency.emergencyTime)}',
              style: TextStyle(
                fontSize: 20, // 設置副標題文字大小
              ),
            ),
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
