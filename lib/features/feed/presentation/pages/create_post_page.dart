import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import '../bloc/feed_bloc.dart';
import '../bloc/feed_event.dart';
import '../bloc/feed_state.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final _contentController = TextEditingController();
  String? _imageBase64;
  XFile? _pickedImage;
  bool _submitted = false;

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (file == null) return;
    final bytes = await file.readAsBytes();
    setState(() {
      _pickedImage = file;
      _imageBase64 = base64Encode(bytes);
    });
  }

  void _removeImage() => setState(() {
        _pickedImage = null;
        _imageBase64 = null;
      });

  void _submit() {
    final content = _contentController.text.trim();
    if (content.isEmpty && _imageBase64 == null) return;
    setState(() => _submitted = true);
    context.read<FeedBloc>().add(CreatePostEvent(
      content: content,
      imageBase64: _imageBase64,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FeedBloc, FeedState>(
      listener: (context, state) {
        if (!_submitted) return;
        if (state is FeedLoaded) {
          context.pop();
        } else if (state is FeedError) {
          setState(() => _submitted = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red[800]),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('New Post'),
          actions: [
            if (_submitted)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              )
            else
              TextButton(
                onPressed: _submit,
                child: Text(
                  'Post',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _contentController,
                maxLines: 6,
                maxLength: 2000,
                decoration: const InputDecoration(
                  hintText: "What did you observe? Share a sighting...",
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                autofocus: true,
                enabled: !_submitted,
              ),
              const SizedBox(height: 16),
              if (_pickedImage != null)
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(_pickedImage!.path),
                        height: 220,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: Material(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(20),
                        child: IconButton(
                          icon: const Icon(Icons.close, color: Colors.white, size: 20),
                          onPressed: _submitted ? null : _removeImage,
                        ),
                      ),
                    ),
                  ],
                )
              else
                OutlinedButton.icon(
                  icon: const Icon(Icons.add_photo_alternate_outlined),
                  label: const Text('Add Photo'),
                  onPressed: _submitted ? null : _pickImage,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
