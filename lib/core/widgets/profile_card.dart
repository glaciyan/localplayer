import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:localplayer/core/services/spotify/presentation/widgets/spotify_preview_container.dart';
import 'package:localplayer/core/widgets/profile_avatar.dart';
import 'package:localplayer/core/domain/models/profile.dart';
import 'package:flutter/foundation.dart';

class ProfileCard extends StatelessWidget {
  final Profile? profile;
  final String? backgroundLink;

  const ProfileCard({
    super.key,
    this.profile,
    this.backgroundLink,
  });

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Profile?>('profile', profile));
    properties.add(StringProperty('backgroundLink', backgroundLink));
  }

  @override
  Widget build(final BuildContext context) => SizedBox.expand(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: <Widget> [
            
            // background image
            Positioned.fill(
              child: Image.network(
                backgroundLink ?? '',
                fit: BoxFit.cover
              )
            ),
            
            // blur effect
            Positioned.fill(
              child:
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 30, sigmaY: 20),
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.5),
                  )
                )
            ),

            // profile card
            SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget> [
                    Expanded(
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Column(
                          children: <Widget> [
                            SizedBox(height: 30,),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget> [
                                  ProfileAvatar(avatarLink: backgroundLink ?? '',color: Colors.green, scale: 1),
                                  SizedBox(width: 16,),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,         
                                      children: <Widget> [
                                        Text(
                                          'Test Profile Name',
                                          style: Theme.of(context).textTheme.titleLarge,
                                          overflow: TextOverflow.ellipsis,
                                          ),
                                        Text(
                                          'Artist Genre',
                                          style: Theme.of(context).textTheme.bodyMedium,
                                          overflow: TextOverflow.ellipsis,
                                          ),
                                        Text(
                                          '27.365 Monthly Listeners',
                                          style: Theme.of(context).textTheme.bodySmall,
                                          overflow: TextOverflow.ellipsis,
                                          )
                                        ]
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 16,),
              
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                style: Theme.of(context).textTheme.bodySmall,
                                '[Your Name] is a visual artist creating expressive works inspired by emotion, nature, and daily life. Their art invites reflection through bold color, texture, and storytelling.'),
                            ),
              
                            SizedBox(height: 20,),
                            SpotifyPreviewContainer(trackId: '3Lc2iEewvM7KoJi9zcN5bx'),
                            SizedBox(height: 20,),
                            SpotifyPreviewContainer(trackId: '5GYgYjeC02l8fSkQ4ffyqd'),
                            SizedBox(height: 20,),
              
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                style: Theme.of(context).textTheme.bodySmall,
                                '[Your Name] is a visual artist creating expressive works inspired by emotion, nature, and daily life. Their art invites reflection through bold color, texture, and storytelling.',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                ),
                            ),
              
              
                            SizedBox(height: 20,),
                            SpotifyPreviewContainer(trackId: '5GYgYjeC02l8fSkQ4ffyqd'),
                            SizedBox(height: 20,),
                            SpotifyPreviewContainer(trackId: '0PvFJmanyNQMseIFrU708S'),
                            SizedBox(height: 20,),
                            Text(style: Theme.of(context).textTheme.bodySmall,
                              '[Your Name] is a visual artist creating expressive works inspired by emotion, nature, and daily life. Their art invites reflection through bold color, texture, and storytelling.',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            SizedBox(height: 20,),
                            SpotifyPreviewContainer(trackId: '0PvFJmanyNQMseIFrU708S'),
              
                            SizedBox(height: 200,),
                          ],
                        )
                      )
                    ) 
                  ],
                ),
              ),
            ),


            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 350, 
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.center,
                      colors: <Color> [
                        Colors.black.withAlpha(150), // dark fade to add contrast
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
            ),
          ],
        )
      )
    );
}