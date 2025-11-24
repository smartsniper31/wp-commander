import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../notifiers/comments_notifier.dart';

class CommentsScreen extends ConsumerWidget {
  final String siteId;

  const CommentsScreen({super.key, required this.siteId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commentsState = ref.watch(commentsNotifierProvider(siteId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
      ),
      body: commentsState.when(
        data: (comments) => ListView.builder(
          itemCount: comments.length,
          itemBuilder: (context, index) {
            final comment = comments[index];
            return ListTile(
              title: Text(comment.authorName),
              subtitle: Text(comment.content),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
