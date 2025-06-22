import 'package:flutter/material.dart';

class TextFieldsSection extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController bioController;
  final TextEditingController spotifyIdController;

  const TextFieldsSection({
    super.key,
    required this.nameController,
    required this.bioController,
    required this.spotifyIdController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
        const SizedBox(height: 12),
        TextField(controller: bioController, decoration: const InputDecoration(labelText: 'Biography')),
        const SizedBox(height: 12),
        TextField(controller: spotifyIdController, decoration: const InputDecoration(labelText: 'Spotify ID')),
      ],
    );
  }
}
