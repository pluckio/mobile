import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '/constants.dart';
import '/notifiers/photos.dart';
import '../data/photo.dart';
import '../notifiers/auth.dart';
import '../widgets/sign_out_button.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ImagePicker picker = ImagePicker();
  final Set<String> _deleting = {};

  @override
  void initState() {
    super.initState();
    context.read<Photos>().init();
  }

  void newPhoto(ImageSource source) async {
    final photosNotifier = context.read<Photos>();
    final router = GoRouter.of(context);

    final XFile? image = await picker.pickImage(source: source);
    if (image != null) {
      debugPrint(image.path);
      photosNotifier.setNewPhoto(image);
      router.push('/new');
    }
  }

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: const [
          SignOutButton(),
        ],
      ),
      floatingActionButton: Builder(builder: (context) {
        return FloatingActionButton(
          onPressed: () async {
            Scaffold.of(context).showBottomSheet(
              (context) => Container(
                height: 200,
                color: Colors.white,
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.camera_alt),
                      title: const Text('Camera'),
                      onTap: () async {
                        debugPrint('tap Camera');
                        newPhoto(ImageSource.camera);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.photo),
                      title: const Text('Gallery'),
                      onTap: () async {
                        debugPrint('tap Gallery');
                        newPhoto(ImageSource.gallery);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
          child: const Icon(Icons.add),
        );
      }),
      body: Consumer2<Photos, Auth>(
        builder: (context, photos, auth, child) {
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemCount: photos.photos.length,
            itemBuilder: (BuildContext context, int index) {
              final photo = photos.photos[index];
              final photoUrl =
                  '${Appwrite.endpoint}/storage/buckets/${Appwrite.bucket}/files/${photo.fileId}/preview?project=${Appwrite.project}';
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
                            child: Text(photo.name),
                          ),
                        ),
                        IconButton(
                          icon: _deleting.contains(photo.id)
                              ? const CircularProgressIndicator()
                              : const Icon(Icons.delete),
                          onPressed: _deleting.contains(photo.id)
                              ? null
                              : () => delete(photo),
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
                        },
                        child: const Row(
                          children: [
                            Icon(Icons.favorite),
                            SizedBox(width: 2.0),
                            Text('Likes: 0'),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () => share(photo),
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
        },
      ),
    );
  }
}
