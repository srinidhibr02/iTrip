import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:itrip/core/theme/app_colors.dart';
import 'package:itrip/core/utils/result.dart';
import 'package:itrip/core/widgets/app_loading.dart';
import 'package:itrip/data/repositories/travel_repository.dart';
import 'package:itrip/domain/entities/post_entity.dart';
import 'package:intl/intl.dart';

final postsProvider = FutureProvider<List<PostEntity>>((ref) async {
  final result = await ref.read(travelRepositoryProvider).getPosts();
  return result.when(
    success: (data) => data,
    error: (_) => throw Exception('Failed'),
  );
});

class CommunityScreen extends ConsumerWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(postsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Community'),
        actions: [
          IconButton(icon: const Icon(Icons.add_photo_alternate_outlined), onPressed: () {}),
        ],
      ),
      body: postsAsync.when(
        loading: () => const AppLoading(),
        error: (_, __) => const Center(child: Text('Failed to load feed')),
        data: (posts) => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: posts.length,
          itemBuilder: (_, i) => _PostCard(post: posts[i]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.edit),
      ),
    );
  }
}

class _PostCard extends StatelessWidget {
  const _PostCard({required this.post});

  final PostEntity post;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  child: Text(post.userName[0].toUpperCase()),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(post.userName, style: const TextStyle(fontWeight: FontWeight.w600)),
                      if (post.createdAt != null)
                        Text(
                          DateFormat.yMMMd().add_jm().format(post.createdAt!),
                          style: TextStyle(fontSize: 11, color: AppColors.mediumGray),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            if (post.hazardReport != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning, color: AppColors.error, size: 16),
                    const SizedBox(width: 8),
                    Expanded(child: Text(post.hazardReport!, style: const TextStyle(fontSize: 12))),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 12),
            Text(post.content),
            if (post.imageUrls.isNotEmpty) ...[
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  post.imageUrls.first,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                ),
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.favorite_border),
                  onPressed: () {},
                ),
                Text('${post.likes}'),
                const SizedBox(width: 16),
                IconButton(
                  icon: const Icon(Icons.comment_outlined),
                  onPressed: () {},
                ),
                Text('${post.comments}'),
                const Spacer(),
                IconButton(icon: const Icon(Icons.share_outlined), onPressed: () {}),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
