import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:localplayer/features/map/presentation/widgets/profile_avatar.dart';

class MapWidget extends StatelessWidget {
  const MapWidget({super.key});

  static final List<Map<String, dynamic>> people = [
    {
      'name': 'Alice',
      'position': LatLng(51.509364, -0.128928), // London center
      'avatar': 'https://i1.sndcdn.com/avatars-000614099139-aooibr-t200x200.jpg',
      'color': Colors.orange,
    },
    {
      'name': 'Bob',
      'position': LatLng(51.519364, -0.118928), // Slightly northeast
      'avatar': 'https://i1.sndcdn.com/avatars-000701366305-hu9f0i-t120x120.jpg',
      'color': Colors.green,
    },
    // Add more people as needed
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        options: MapOptions(
          interactionOptions: InteractionOptions(
            rotationThreshold: 360,
          ),
          initialCenter: LatLng(51.509364, -0.128928), // London
          initialZoom: 13.0,
        ),
        children: [
          TileLayer(
            retinaMode: RetinaMode.isHighDensity(context),
            // Choose any of these free tile providers:
            //urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png', // Standard OSM
            // urlTemplate: 'https://{s}.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png', // Humanitarian style
            // urlTemplate: 'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png', // CartoDB Voyager
            urlTemplate: 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png', // CartoDB Positron
            // urlTemplate: 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png', // CartoDB Dark Matter
            subdomains: ['a', 'b', 'c'],
            userAgentPackageName: 'com.example.app',
          ),
          MarkerLayer(
            markers: people.map((person) => Marker(
              point: person['position'],
              width: 100,
              height: 100,
              child:
                ProfileAvatar(avatarLink: person['avatar'], color: person['color'])
              )
            ).toList(),
          )
        ],
      ),
    );
  }
}
