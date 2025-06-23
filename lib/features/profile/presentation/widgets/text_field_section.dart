import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

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
  Widget build(final BuildContext context) => Column(
      children: <Widget> [
        TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
        const SizedBox(height: 12),
        TextField(controller: bioController, decoration: const InputDecoration(labelText: 'Biography')),
        const SizedBox(height: 12),
        TextField(controller: spotifyIdController, decoration: const InputDecoration(labelText: 'Spotify ID')),
      ],
    );

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<TextEditingController>('nameController', nameController));
    properties.add(DiagnosticsProperty<TextEditingController>('bioController', bioController));
    properties.add(DiagnosticsProperty<TextEditingController>('spotifyIdController', spotifyIdController));
  }
}
