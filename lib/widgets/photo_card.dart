import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../constants.dart';
import '../data/photo.dart';
import '../notifiers/auth.dart';
import '../notifiers/likes.dart';
import '../notifiers/photos.dart';

class PhotoCard extends StatefulWidget {
  final Photo photo;

  const PhotoCard({super.key, required this.photo});

  @override
  State<PhotoCard> createState() => _PhotoCardState();
}

class _PhotoCardState extends State<PhotoCard> {
  final Set<String> _deleting = {};

  void delete(Photo photo) async {
    setState(() {
      _deleting.add(photo.id);
    });

    final photosNotifier = context.read<Photos>();
    final messenger = ScaffoldMessenger.of(context);

    try {
      await photosNotifier.delete(photo);
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(
          content: Text('Failed to delete photo: $e'),
        ),
      );
    } finally {
      setState(() {
        _deleting.remove(photo.id);
      });
    }
  }

  void share(Photo photo) {
    debugPrint('share');

    final url =
        'https://pluck-pi.vercel.app/user/${photo.username}/${photo.slug}';

    Share.share(url, subject: photo.name);
  }

  @override
  Widget build(BuildContext context) {
    final photoUrl =
        '${Appwrite.endpoint}/storage/buckets/${Appwrite.bucket}/files/${widget.photo.fileId}/preview?project=${Appwrite.project}';
    return Consumer2<Auth, Likes>(
      builder: (context, auth, likes, child) {
        return Card(
          child: GridTile(
            header: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 4,
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    child: Text(auth.user?.name.substring(0, 1) ?? ''),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text(widget.photo.name),
                    ),
                  ),
                  IconButton(
                    icon: _deleting.contains(widget.photo.id)
                        ? const CircularProgressIndicator()
                        : const Icon(Icons.delete),
                    onPressed: _deleting.contains(widget.photo.id)
                        ? null
                        : () => delete(widget.photo),
                  ),
                ],
              ),
            ),
            footer: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    debugPrint('like');
                    likes.likePhoto(widget.photo);
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.favorite),
                      const SizedBox(width: 2.0),
                      Text('Likes: ${likes.getLikeCount(widget.photo)}'),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () => share(widget.photo),
                  child: const Row(
                    children: [
                      Icon(Icons.share),
                      SizedBox(width: 2.0),
                      Text('Share'),
                    ],
                  ),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 48.0),
              child: CachedNetworkImage(
                imageUrl: photoUrl,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
