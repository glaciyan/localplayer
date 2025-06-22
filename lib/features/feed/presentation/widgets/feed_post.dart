import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:localplayer/features/feed/domain/models/NotificationModel.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:localplayer/core/widgets/profile_avatar.dart';

class FeedPost extends StatefulWidget {
  final NotificationModel post;

  const FeedPost({super.key, required this.post});

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<NotificationModel>('post', post));
  }

  @override
  State<FeedPost> createState() => _FeedPostState();
}

class _FeedPostState extends State<FeedPost> with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  bool _isLoading = false;

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<NotificationModel>('post', widget.post));
  }

  // Helper method to determine if this post should show a map
  bool get _shouldShowMap => widget.post.type == NotificationType.sessionAccepted;
  bool get _sessionInvite => widget.post.type == NotificationType.sessionInvite;

  // Helper method to get the expanded height based on content type
  double get _expandedHeight {
    if (_shouldShowMap) {
      return 500.0; // Taller for map posts
    } else if (_sessionInvite) {
      return 200.0; // Taller for session invite posts
    } else {
      return 110.0; // Standard height for other posts
    }
  }

  @override
  Widget build(final BuildContext context) => GestureDetector(
    onTap: () {
      setState(() {
        if (_shouldShowMap || _sessionInvite) {
          _isExpanded = !_isExpanded;
        } else {
          _isExpanded = false;
        }
      });
    },
    child: AnimatedSize(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      child: SizedBox(
        height: _isExpanded ? _expandedHeight : 110.0,
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: <Widget> [
              Image.network(
                widget.post.backgroundLink,
                fit: BoxFit.cover,
              ),
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 30, sigmaY: 20),
                  child: Stack(
                    children: <Widget> [
                      Container(
                      color: widget.post.type == NotificationType.like
                        ? const Color.fromARGB(255, 20, 174, 69).withValues(alpha: 0.2)
                        : widget.post.type == NotificationType.sessionRejected
                        ? const Color.fromARGB(255, 174, 20, 53).withValues(alpha: 0.2)
                        : Colors.black.withValues(alpha: 0.2),
                    ),
                      Container(
                        color: Colors.black.withValues(alpha: 0.2),
                      ),

                    ],
                  )
                )
              ),  
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget> [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget> [
                        ProfileAvatar(
                          avatarLink: widget.post.backgroundLink,
                          color: Colors.white,
                          scale: 0.75,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget> [
                              Text(
                                overflow: TextOverflow.ellipsis,
                                widget.post.title,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                overflow: TextOverflow.ellipsis,
                                widget.post.type.toString(),
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (_isExpanded) ...<Widget> [
                      const SizedBox(height: 16),
                      if (_shouldShowMap) ...<Widget> [
                        // Map content - fills available space
                        Expanded(
                          child: Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            clipBehavior: Clip.antiAlias,
                            child: FlutterMap(
                              options: MapOptions(
                                initialCenter: LatLng(51.5, -0.09),
                                initialZoom: 13.0,
                              ),
                              children: <Widget> [
                                TileLayer(
                                  urlTemplate: 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png',
                                  retinaMode: RetinaMode.isHighDensity(context),
                                ),
                                MarkerLayer(
                                  markers: <Marker> [
                                    Marker(
                                      point: LatLng(51.5, -0.09),
                                      child: Icon(Icons.location_on, color: Colors.red, size: 50),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),  
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : () async {
                              setState(() {
                                _isLoading = true;
                              });
                              
                              // Simulate API call
                              await Future<void>.delayed(const Duration(seconds: 2));
                              
                              setState(() {
                                _isLoading = false;
                              });
                            },
                            child: _isLoading 
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : const Text('Ping Artist'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              foregroundColor: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      ] else if (_sessionInvite) ...<Widget> [
                        // Session invite content
                        Text(
                          'Session Invite',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 200,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                            },
                            child: Text('Accept Session Request'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                      ] else ...<Widget> [
                        Text(
                          'Expanded content here...',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ],
                  ],
                ),
              ),    
            ],
          ),
        ),
      ),
    ),
  );
}