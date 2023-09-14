import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '/notifiers/photos.dart';

class New extends StatefulWidget {
  const New({super.key});

  @override
  State<New> createState() => _NewState();
}

class _NewState extends State<New> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _upload(BuildContext context) async {
    final photos = context.read<Photos>();
    final messenger = ScaffoldMessenger.of(context);
    final router = GoRouter.of(context);
    try {
      setState(() {
        _isUploading = true;
      });
      await photos.upload(
        _nameController.text,
        _descriptionController.text,
      );
      router.push('/');
    } catch (e) {
      debugPrint(e.toString());
      messenger.showSnackBar(
        SnackBar(
          content: Text('Failed to upload photo: $e'),
        ),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const gap = SizedBox(height: 16);

    return Scaffold(
      appBar: AppBar(
        title: const Text('New'),
        actions: const [
          // IconButton(
          //   onPressed: () async {
          //     final auth = context.read<Auth>();
          //     final router = GoRouter.of(context);
          //     await auth.signOut();

          //     while (router.canPop()) {
          //       router.pop();
          //     }
          //   },
          //   icon: const Icon(Icons.logout),
          // ),
        ],
      ),
      floatingActionButton: Builder(builder: (context) {
        return FloatingActionButton(
          onPressed: _isUploading ? null : () => _upload(context),
          child: _isUploading
              ? const CircularProgressIndicator()
              : const Icon(Icons.upload),
        );
      }),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.green,
              child: Consumer<Photos>(
                builder: (context, photos, child) {
                  final image = photos.newPhoto;

                  final size = MediaQuery.of(context).size;
                  final screenHeight = size.height;

                  if (image == null) {
                    return const Placeholder();
                  }

                  debugPrint(image.path);

                  return Image(
                    height: screenHeight / 3,
                    image: FileImage(
                      File(image.path),
                    ),
                  );
                },
              ),
            ),
            gap,
            TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Name',
              ),
              controller: _nameController,
            ),
            gap,
            TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Description',
              ),
              controller: _descriptionController,
            ),
          ],
        ),
      ),
    );
  }
}
