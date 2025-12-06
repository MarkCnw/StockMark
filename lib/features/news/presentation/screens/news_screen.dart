import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stockmark/core/constants/app_spacing.dart';
import 'package:stockmark/core/constants/app_string.dart';
import 'package:stockmark/core/extensions/context_extensions.dart';
import 'package:stockmark/features/news/presentation/providers/new_provider.dart';
import 'package:stockmark/features/news/presentation/screens/news_detail_screen.dart';
import 'package:stockmark/features/news/presentation/widgets/hot_news_section.dart';
import 'package:stockmark/features/news/presentation/widgets/news_list_section.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NewProvider>().loadAllNews();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(AppStrings.marketNews, style: context.titleLarge),
      centerTitle: true,
      elevation: 0,
      backgroundColor: context.backgroundColor,
    );
  }

  Widget _buildBody() {
    return Consumer<NewProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading && provider.isHotNewsLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.isEmpty) {
          return _buildEmptyState();
        }

        return _buildContent(provider);
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Text(
        AppStrings.noNewsAvailable,
        style: context.bodyMedium.copyWith(
          color: context.textSecondaryColor,
        ),
      ),
    );
  }

  Widget _buildContent(NewProvider provider) {
    return RefreshIndicator(
      onRefresh: () => provider.loadAllNews(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (provider.hotNews.isNotEmpty) ...[
              HotNewsSection(
                hotNews: provider.hotNews,
                onNewsTap: _handleNewsTap,
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
            LatestNewsSection(
              news: provider.news,
              onNewsTap: _handleNewsTap,
            ),
          ],
        ),
      ),
    );
  }

  void _handleNewsTap(news) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewsDetailScreen(news: news),
      ),
    );
  }
}
