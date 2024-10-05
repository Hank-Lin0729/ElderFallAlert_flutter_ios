import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:elder_care_app/main.dart';
import 'package:elder_care_app/user_page.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ElderCareApp Widget Tests', () {
    testWidgets('Displays UserPage when logged in', (WidgetTester tester) async {
      // 模擬 HTTP 請求
      final client = MockClient((request) async {
        if (request.url.path == '/get_user_info') {
          return http.Response(jsonEncode({
            'name': 'Test User',
            'username': 'test_user'
          }), 200);
        }
        return http.Response('Not Found', 404);
      });

      // 模擬已登錄狀態
      SharedPreferences.setMockInitialValues({'isLoggedIn': true});

      // 構建應用
      await tester.pumpWidget(ElderCareApp());

      // 等待異步操作完成
      await tester.pumpAndSettle();

      // 檢查是否顯示了 UserPage
      expect(find.text('用戶專屬頁面'), findsOneWidget);
    });

    testWidgets('Displays LoginPage when not logged in', (WidgetTester tester) async {
      // 模擬未登錄狀態
      SharedPreferences.setMockInitialValues({'isLoggedIn': false});

      // 構建應用
      await tester.pumpWidget(const ElderCareApp());

      // 等待異步操作完成
      await tester.pumpAndSettle();

      // 檢查是否顯示了 LoginPage
      expect(find.widgetWithText(ElevatedButton, '登入'), findsOneWidget);
    });
  });
}
