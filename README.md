# 長者即時照護 Flutter 前端專案

## 專案簡介
本專案是一個配合長者即時照護系統後端 API 的 Flutter 前端應用，旨在幫助用戶管理長者資訊、查看緊急狀況、上傳圖片及與長者即時互動。應用程式包含登入註冊、管理長者資料、查看緊急狀況等功能，並通過與後端 API 的通信來實現長者即時照護。

### 目錄結構
- **main.dart**: 應用程式的入口文件。
- **login_page.dart**: 登入頁面，用戶可以通過此頁面登入系統。
- **register_page.dart**: 註冊頁面，用於新用戶註冊。
- **user_page.dart**: 用戶主頁，顯示長者資料及操作選項。
- **add_elder_page.dart**: 新增長者頁面，用戶可新增長者資訊。
- **elder_list_page.dart**: 長者列表頁面，顯示所有長者的資料。
- **emergency_list_page.dart**: 緊急事件列表頁面，用戶可查看最近的緊急事件資訊。
- **photo_gallery_page.dart**: 照片庫頁面，用戶可查看偵測到的照片。
- **reset_password_page.dart**: 重設密碼頁面，用戶可重設自己的帳戶密碼。
- **reset_botkey_page.dart**: 重設 Bot Key 頁面，用戶可更新 Bot Key。

### 技術棧
- **前端框架**: Flutter
- **後端 API**: Flask 應用程式（[長者即時照護系統](elder_care_readme)）
- **資料庫**: Render PostgreSQL（後端管理）

## 功能描述
1. **用戶註冊與登入**
    - **註冊頁面 (register_page.dart)**：用戶可以通過此頁面建立帳號，並登錄系統。
    - **登入頁面 (login_page.dart)**：已註冊用戶可以使用帳號和密碼登入。

2. **長者資訊管理**
    - **新增長者 (add_elder_page.dart)**：用戶可以新增長者的基本資料，包含區域 ID 及長者名稱。
    - **長者列表頁面 (elder_list_page.dart)**：顯示所有長者的基本資料，用戶可以瀏覽與管理。

3. **緊急事件查看**
    - **緊急事件列表 (emergency_list_page.dart)**：顯示最近的緊急事件資訊，確保用戶可以即時了解長者的狀況。

4. **照片庫**
    - **照片庫頁面 (photo_gallery_page.dart)**：顯示跌倒偵測的照片，用戶可以查詢與查看最近的偵測記錄。

5. **密碼與 Bot Key 重設**
    - **重設密碼 (reset_password_page.dart)**：用戶可以重設帳戶密碼，以確保帳戶安全。
    - **重設 Bot Key (reset_botkey_page.dart)**：用戶可以重設 Bot Key，保持與後端的同步。

## 安裝與使用

### 前置需求
- Flutter SDK
- Android Studio 或 Visual Studio Code（用於開發與測試）
- Xcode

### 安裝步驟
1. 克隆專案到本地：
   ```
   git clone <專案地址>
   ```
2. 安裝相依庫：
   ```
   flutter pub get
   ```
3. 連接您的模擬器或 Android/iOS 裝置，然後啟動應用：
   ```
   flutter run
   ```

## 與後端 API 的集成
本專案配合後端 Flask API 進行資料交互，以下為主要使用的 API：

- **/register**: 用於註冊新用戶。
- **/login**: 用於登入系統。
- **/add_elder**: 新增長者資料。
- **/get_elders**: 查詢用戶的長者列表。
- **/get_emergencies**: 查詢最近的緊急事件列表。
- **/get_latest_photos**: 查詢跌倒偵測的照片庫。
- **/reset_password**: 重設用戶密碼。
- **/reset_botkey**: 重設 Bot Key。

## 注意事項
- **帳戶安全**: 用戶的登入和密碼重設功能會使用 JWT 和 bcrypt 進行安全保護。
- **通知功能**: 緊急事件偵測後，系統會通過 LINE 通知設定的用戶，確保即時通知。

## 開發者
- 此專案由林柏翰開發，歡迎進行改進與討論。
