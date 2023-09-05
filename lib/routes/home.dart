import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../notifiers/auth.dart';
import '../notifiers/photos.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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

                // print('canPop?: ${router.canPop()}');
                // while (router.canPop()) {
                //   print('popping');
                //   router.pop();
                // }
              },
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
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
                  print(photoUrl);
                  return Card(
                    child: GridTile(
                      header: GridTileBar(
                        leading: const CircleAvatar(
                          child: Text('WC'),
                        ),
                        title: Text(photo.name),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            // await photos.delete(photo);
                          },
                        ),
                      ),
                      child: Image.network(photoUrl),
                    ),
                  );
                });
          },
        ));
  }
}
