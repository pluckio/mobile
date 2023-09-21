import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '/constants.dart';
import '/notifiers/auth.dart';
import '/notifiers/photos.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    context.read<Photos>().init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            onPressed: () async {
              final auth = context.read<Auth>();
              final router = GoRouter.of(context);
              await auth.signOut();

              while (router.canPop()) {
                router.pop();
              }
            },
            icon: const Icon(Icons.logout),
          ),
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
                        final photosNotifier = context.read<Photos>();
                        final router = GoRouter.of(context);

                        final XFile? image =
                            await picker.pickImage(source: ImageSource.camera);
                        if (image != null) {
                          debugPrint(image.path);
                          photosNotifier.setNewPhoto(image);
                          router.push('/new');
                        }
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.photo),
                      title: const Text('Gallery'),
                      onTap: () async {
                        debugPrint('tap Gallery');
                        final photosNotifier = context.read<Photos>();
                        final router = GoRouter.of(context);

                        final XFile? image =
                            await picker.pickImage(source: ImageSource.gallery);
                        if (image != null) {
                          debugPrint(image.path);
                          photosNotifier.setNewPhoto(image);
                          router.push('/new');
                        }
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
      body: Consumer<Photos>(
        builder: (context, photos, child) {
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemCount: photos.photos.length,
            itemBuilder: (BuildContext context, int index) {
              final photo = photos.photos[index];
              final photoUrl =
                  '${Appwrite.endpoint}/storage/buckets/${Appwrite.bucket}/files/${photo.fileId}/preview?project=${Appwrite.project}';
              debugPrint(photoUrl);
              return Card(
                child: GridTile(
                  header: GridTileBar(
                    leading: const CircleAvatar(
                      child: Text('WC'),
                    ),
                    title: Text(
                      photo.name,
                      style: const TextStyle(color: Colors.black),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.black),
                      onPressed: () async {
                        // await photos.delete(photo);
                      },
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
                        onPressed: () {
                          debugPrint('share');

                          final url =
                              'https://pluck-pi.vercel.app/user/${photo.username}/${photo.slug}';

                          Share.share(url, subject: photo.name);
                        },
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
