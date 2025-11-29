<div align="center">

# 📈 StockMark

### *Real-time Stock Market Tracking App*

[![Flutter](https://img.shields.io/badge/Flutter-3.8+-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter. dev)
[![Dart](https://img.shields.io/badge/Dart-3.8+-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)](LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen?style=for-the-badge)](http://makeapullrequest.com)

<p align="center">
  <img src="https://img.shields.io/badge/Android-3DDC84?style=flat-square&logo=android&logoColor=white" alt="Android"/>
  <img src="https://img.shields.io/badge/iOS-000000?style=flat-square&logo=ios&logoColor=white" alt="iOS"/>
  <img src="https://img.shields.io/badge/Web-4285F4?style=flat-square&logo=google-chrome&logoColor=white" alt="Web"/>
  <img src="https://img.shields.io/badge/Windows-0078D6? style=flat-square&logo=windows&logoColor=white" alt="Windows"/>
  <img src="https://img.shields.io/badge/macOS-000000?style=flat-square&logo=apple&logoColor=white" alt="macOS"/>
  <img src="https://img.shields.io/badge/Linux-FCC624?style=flat-square&logo=linux&logoColor=black" alt="Linux"/>
</p>

---

**StockMark** เป็นแอปพลิเคชัน Flutter สำหรับติดตามและวิเคราะห์หุ้น<br/>
พัฒนาด้วยหลักการ **Clean Architecture** เพื่อความยืดหยุ่นและง่ายต่อการบำรุงรักษา

[Features](#-features) •
[Screenshots](#-screenshots) •
[Installation](#-installation) •
[Architecture](#-architecture) •
[Contributing](#-contributing)

</div>

---

## ✨ Features

<table>
<tr>
<td>

### 📊 Market Overview
- S&P 500 real-time tracking
- ภาพรวมตลาดหุ้นแบบ Real-time

</td>
<td>

### 📈 Top Movers
- Daily Gainers & Losers
- Most Active Stocks

</td>
</tr>
<tr>
<td>

### 📰 News Feed
- ข่าวตลาดหุ้นล่าสุด
- อัพเดทตลอด 24 ชั่วโมง

</td>
<td>

### 🎨 Theme Support
- Dark / Light Mode
- สลับธีมได้ตามต้องการ

</td>
</tr>
</table>

---

## 📱 Screenshots

<div align="center">

| Home Screen | News Feed | Profile |
|:-----------:|:---------:|:-------:|
| *Coming Soon* | *Coming Soon* | *Coming Soon* |

</div>

---

## 🚀 Installation

### Prerequisites

> ⚠️ ตรวจสอบให้แน่ใจว่าติดตั้งเครื่องมือเหล่านี้แล้ว

- [Flutter SDK](https://docs.flutter.dev/get-started/install) `>= 3.8.0`
- [Dart SDK](https://dart. dev/get-dart) `>= 3.8. 1`
- IDE ที่แนะนำ: [VS Code](https://code.visualstudio.com/) หรือ [Android Studio](https://developer.android.com/studio)

### Quick Start

```bash
# 1️⃣ Clone the repository
git clone https://github. com/MarkCnw/StockMark.git

# 2️⃣ Navigate to project directory
cd StockMark

# 3️⃣ Install dependencies
flutter pub get

# 4️⃣ Create .env file (สำหรับ API keys)
echo "API_KEY=your_api_key_here" > .env

# 5️⃣ Run the app
flutter run
```

---

## 🏗️ Architecture

โปรเจกต์นี้ใช้หลักการ **Clean Architecture** แบ่งโครงสร้างชัดเจน:

```
📦 lib
 ┣ 📂 core
 ┃ ┣ 📂 errors          # Exception handling
 ┃ ┣ 📂 theme           # App themes
 ┃ ┗ 📜 navigation_shell. dart
 ┣ 📂 features
 ┃ ┣ 📂 home
 ┃ ┃ ┣ 📂 data          # API Services, Repository Implementation
 ┃ ┃ ┣ 📂 domain        # Use Cases, Entities, Repository Interfaces
 ┃ ┃ ┗ 📂 presentation  # Screens, Widgets, Providers
 ┃ ┣ 📂 news            # News Feature Module
 ┃ ┗ 📂 profile         # Profile & Settings Module
 ┗ 📜 main.dart
```

### 🔄 Data Flow

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│     UI      │ ──▶ │  Provider   │ ──▶ │  Use Case   │ ──▶ │ Repository  │
│  (Screens)  │ ◀── │   (State)   │ ◀── │  (Domain)   │ ◀── │   (Data)    │
└─────────────┘     └─────────────┘     └─────────────┘     └─────────────┘
```

---

## 📦 Tech Stack & Dependencies

<table>
<tr>
<td align="center" width="96">
  <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/flutter/flutter-original.svg" width="48" height="48" alt="Flutter" />
  <br>Flutter
</td>
<td align="center" width="96">
  <img src="https://cdn. jsdelivr.net/gh/devicons/devicon/icons/dart/dart-original.svg" width="48" height="48" alt="Dart" />
  <br>Dart
</td>
</tr>
</table>

| Package | Version | Description |
|---------|---------|-------------|
| `provider` | ^6.1.5 | State Management |
| `http` | ^1.6.0 | API Requests |
| `get_it` | ^9.0.5 | Dependency Injection |
| `flutter_dotenv` | ^6.0.0 | Environment Variables |
| `equatable` | ^2.0. 7 | Value Equality |
| `google_fonts` | ^6.3.2 | Custom Fonts |
| `shared_preferences` | ^2.5. 3 | Local Storage |

---

## 🤝 Contributing

Contributions are always welcome! 🎉

```bash
# 1.  Fork the Project
# 2. Create your Feature Branch
git checkout -b feature/AmazingFeature

# 3. Commit your Changes
git commit -m 'Add some AmazingFeature'

# 4. Push to the Branch
git push origin feature/AmazingFeature

# 5. Open a Pull Request
```

---

## 📄 License

Distributed under the **MIT License**. See `LICENSE` for more information.

---

## 👤 Author

<div align="center">

**MarkCnw**

[![GitHub](https://img.shields. io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white)](https://github.com/MarkCnw)

</div>

---

<div align="center">

### ⭐ Show your support

Give a ⭐ if this project helped you! 

<br>

Made with ❤️ and Flutter

</div>
