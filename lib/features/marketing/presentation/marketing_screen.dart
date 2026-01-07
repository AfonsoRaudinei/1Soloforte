import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:soloforte_app/core/theme/app_spacing.dart';
import 'package:soloforte_app/features/marketing/data/marketing_repository.dart';
import 'package:soloforte_app/features/marketing/domain/post_model.dart';
import 'package:soloforte_app/features/marketing/presentation/screens/create_post_screen.dart';
import 'package:soloforte_app/features/marketing/presentation/widgets/cases_dashboard.dart';
import 'package:soloforte_app/features/marketing/presentation/widgets/feed/feed_post_card.dart';

class MarketingScreen extends ConsumerStatefulWidget {
  const MarketingScreen({super.key});

  @override
  ConsumerState<MarketingScreen> createState() => _MarketingScreenState();
}

class _MarketingScreenState extends ConsumerState<MarketingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final MarketingRepository _repository = MarketingRepository();
  List<Post> _myPosts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadData();
  }

  Future<void> _loadData() async {
    final published = await _repository.getPosts(status: PostStatus.published);

    // Filter by current user (mock ID: 'user_123')
    setState(() {
      _myPosts = published.where((p) => p.authorId == 'user_123').toList();
      _isLoading = false;
    });
  }

  void _navigateToCreate({Post? draft}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreatePostScreen(draft: draft)),
    );
    _loadData(); // Reload on return
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB), // gray-50
      appBar: AppBar(
        title: const Text(
          'SoloForte Marketing',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E3A2F),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: Color(0xFF1E3A2F)),
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF4ADE80),
          unselectedLabelColor: Colors.grey,
          indicatorColor: const Color(0xFF4ADE80),
          indicatorWeight: 3,
          isScrollable: true,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: 'Dashboard'),
            Tab(text: 'Meus Cases'),
            Tab(text: 'Analytics'),
            Tab(text: 'Configurações'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                const CasesDashboard(), // The main dashboard we built
                _buildMyCasesList(), // Legacy logic adapted
                const _PlaceholderPage(
                  title: 'Analytics',
                  icon: Icons.analytics_outlined,
                ),
                const _PlaceholderPage(
                  title: 'Configurações',
                  icon: Icons.settings_outlined,
                ),
              ],
            ),
    );
  }

  Widget _buildMyCasesList() {
    if (_myPosts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.article_outlined, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text('Nenhum case publicado.'),
            TextButton(
              onPressed: () => _navigateToCreate(),
              child: const Text('Criar publicação padrão'),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: EdgeInsets.all(AppSpacing.md),
      itemCount: _myPosts.length,
      itemBuilder: (context, index) {
        final post = _myPosts[index];
        return FeedPostCard(
          post: post,
          isMine: true,
          onEdit: () => _navigateToCreate(draft: post),
        );
      },
    );
  }
}

class _PlaceholderPage extends StatelessWidget {
  final String title;
  final IconData icon;

  const _PlaceholderPage({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Em desenvolvimento',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
