import 'package:flutter/material.dart';
import 'package:stockmark/core/constants/app_font_sizes.dart';
import 'package:webview_flutter/webview_flutter.dart'; // ✅ Import ตัวนี้
import 'package:stockmark/features/news/domain/entities/news_entity.dart';

class NewsDetailScreen extends StatefulWidget {
  final NewsEntity news;

  const NewsDetailScreen({super.key, required this.news});

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  late final WebViewController _controller;
  bool _isLoading = true; // เอาไว้โชว์หมุนๆ ตอนเว็บกำลังโหลด

  @override
  void initState() {
    super.initState();

    // 1. ตั้งค่า WebView
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.news.url)); // ✅ โหลดลิ้งก์ข่าวจริง
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.news.source, // โชว์ชื่อสำนักข่าวบนหัว
          style: const TextStyle(
            fontSize: AppFontSize.lg,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // 2. ตัวแสดงเว็บ
          WebViewWidget(controller: _controller),

          // 3. ตัวหมุนๆ (ถ้ากำลังโหลดอยู่ให้โชว์)
          if (_isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
