import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:localplayer/features/feed/domain/models/NotificationModel.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:localplayer/core/widgets/profile_avatar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localplayer/core/services/spotify/domain/entities/spotify_artist_data.dart';
import 'package:localplayer/core/services/spotify/domain/usecases/get_spotify_artist_data_use_case.dart';

import 'package:localplayer/features/feed/domain/interfaces/feed_controller_interface.dart';

class FeedPost extends StatefulWidget {
  final NotificationModel post;
  final IFeedController feedController;

  const FeedPost({
    super.key,
    required this.post,
    required this.feedController,
  });

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<NotificationModel>('post', post));
    properties.add(DiagnosticsProperty<IFeedController>('feedController', feedController));
  }

  @override
  State<FeedPost> createState() => _FeedPostState();
}

class _FeedPostState extends State<FeedPost> with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  bool _isLoading = false;
  String? _backgroundLink;

  @override
  void initState() {
    super.initState();
    _loadBackgroundLink();
  }

  Future<void> _loadBackgroundLink() async {
    final String spotifyId = widget.post.sender.spotifyId;
    if (spotifyId.isEmpty) {
      setState(() => _backgroundLink = widget.post.sender.avatarLink);
      return;
    }

    try {
      final GetSpotifyArtistDataUseCase getArtist =
          context.read<GetSpotifyArtistDataUseCase>();
      final SpotifyArtistData artist = await getArtist(spotifyId);
      setState(() => _backgroundLink = artist.imageUrl);
    } catch (_) {
      setState(() => _backgroundLink = widget.post.sender.avatarLink);
    }
  }

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<NotificationModel>('post', widget.post));
    properties.add(DiagnosticsProperty<IFeedController>('feedController', widget.feedController));
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
      return 115.0; // Standard height for other posts
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
        height: _isExpanded ? _expandedHeight : 115.0,
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: <Widget> [
              if (_backgroundLink != null && _backgroundLink!.isNotEmpty)
                Image.network(
                  _backgroundLink!,
                  fit: BoxFit.cover,
                  errorBuilder: (final BuildContext context, final Object error, final StackTrace? stackTrace) => ColoredBox(color: widget.post.sender.color ?? Colors.black12)
                )
              else
                ColoredBox(color: widget.post.sender.color ?? Colors.black12),
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
                        : Colors.black.withValues(alpha: 0.5),
                    ),
                      Container(
                        color: Colors.black.withValues(alpha: 0.5),
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
                          avatarLink: _backgroundLink ?? '',
                          color: widget.post.sender.color ?? Colors.black12,
                          scale: 0.75,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget> [
                              Text(
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.visible,
                                widget.post.title,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
                                initialCenter: /*widget.post.session?.position ?? */LatLng(52.52, 13.405),
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
                                      point: /*widget.post.session?.position ?? */LatLng(52.52, 13.405),
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

                              widget.feedController.pingUser(widget.post.sender.id);
                              
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
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isLoading || widget.post.session == null
                                ? null
                                : () async {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    
                                    widget.feedController.acceptSession(
                                      widget.post.sender.id,
                                      widget.post.session!.id,
                                    );

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
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : const Text('Accept Session Request'),
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