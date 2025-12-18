import 'package:flutter/material.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/core/theme/app_spacing.dart';
import 'package:soloforte_app/features/marketing/data/marketing_repository.dart';
import 'package:soloforte_app/features/marketing/domain/post_model.dart';
import 'package:soloforte_app/features/marketing/presentation/screens/create_post_screen.dart';
import 'package:soloforte_app/features/marketing/presentation/widgets/feed/feed_post_card.dart';

class MarketingScreen extends StatefulWidget {
  const MarketingScreen({super.key});

  @override
  State<MarketingScreen> createState() => _MarketingScreenState();
}

class _MarketingScreenState extends State<MarketingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final MarketingRepository _repository = MarketingRepository();
  List<Post> _myPosts = [];
  List<Post> _drafts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  Future<void> _loadData() async {
    final published = await _repository.getPosts(status: PostStatus.published);
    final drafts = await _repository.getPosts(status: PostStatus.draft);

    // Filter by current user (mock ID: 'user_123')
    setState(() {
      _myPosts = published.where((p) => p.authorId == 'user_123').toList();
      _drafts = drafts;
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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.menu), // [☰]
            onPressed: () {},
          ),
          title: const Text('Marketing UI Test'),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: AppSpacing.sm),
              child: TextButton.icon(
                onPressed: () => _navigateToCreate(),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Publicar'), // [+ Publicar]
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  textStyle: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            labelColor: AppColors.primary,
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppColors.primary,
            tabs: [
              const Tab(text: 'Meus Posts'),
              Tab(text: 'Rascunhos (${_drafts.length})'),
            ],
          ),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                controller: _tabController,
                children: [_buildMyPostsList(), _buildDraftsList()],
              ),
      ),
    );
  }

  Widget _buildMyPostsList() {
    if (_myPosts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.article_outlined, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text('Você ainda não publicou nada.'),
            TextButton(
              onPressed: () => _navigateToCreate(),
              child: const Text('Criar primeiro post'),
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
        // Using FeedPostCard but could customize strictly to ASCII here if needed
        // The FeedPostCard will be updated to match the card layout
        return FeedPostCard(
          post: post,
          isMine: true,
          onEdit: () => _navigateToCreate(draft: post),
        );
      },
    );
  }

  Widget _buildDraftsList() {
    if (_drafts.isEmpty) {
      return const Center(child: Text('Nenhum rascunho salvo.'));
    }

    return ListView.separated(
      padding: EdgeInsets.all(AppSpacing.md),
      itemCount: _drafts.length,
      separatorBuilder: (_, __) => SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, index) {
        final draft = _drafts[index];
        return Card(
          child: ListTile(
            leading: draft.imageUrls.isNotEmpty
                ? Container(
                    width: 50,
                    height: 50,
                    child: Image.network(
                      draft.imageUrls.first,
                      errorBuilder: (c, e, s) => const Icon(Icons.image),
                      fit: BoxFit.cover,
                    ),
                  )
                : Container(
                    width: 50,
                    height: 50,
                    color: Colors.grey[300],
                    child: const Icon(Icons.edit_note, color: Colors.grey),
                  ),
            title: Text(
              draft.title.isEmpty ? 'Sem título' : draft.title,
              maxLines: 1,
            ),
            subtitle: Text(
              draft.content.isEmpty ? 'Sem conteúdo...' : draft.content,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: IconButton(
              icon: const Icon(Icons.edit, color: AppColors.primary),
              onPressed: () => _navigateToCreate(draft: draft),
            ),
          ),
        );
      },
    );
  }
} // End Class
