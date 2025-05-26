import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:localplayer/widgets/profile_avatar.dart';
import 'package:localplayer/widgets/spotify_embed_player.dart';

class ProfileCard extends StatelessWidget {
  final String avatarLink;
  final String backgroundLink;

  const ProfileCard({
    super.key,
    required this.avatarLink,
    required this.backgroundLink
  });
  
  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            
            // background image
            Positioned.fill(
              child: Image.network(
                backgroundLink,
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
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children:[
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ProfileAvatar(avatarLink: avatarLink,color: Colors.green),
                              Spacer(flex: 1,),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:[
                                  Text('Artist', style: Theme.of(context).textTheme.bodyLarge),
                                  Text('Artist Description', style: Theme.of(context).textTheme.bodyMedium)
                                  ]
                              ),
                              Spacer(flex: 5,)
                            ],
                          ),
                          SizedBox(height: 16,),
                          Text(style: Theme.of(context).textTheme.bodySmall,'[Your Name] is a visual artist creating expressive works inspired by emotion, nature, and daily life. Their art invites reflection through bold color, texture, and storytelling.'),
                          SizedBox(height: 20,),
                          SpotifyPreviewWidget(trackId: '3Lc2iEewvM7KoJi9zcN5bx'),
                          SizedBox(height: 20,),
                          SpotifyPreviewWidget(trackId: '5GYgYjeC02l8fSkQ4ffyqd'),
                          SizedBox(height: 20,),
                          Text(style: Theme.of(context).textTheme.bodySmall,'[Your Name] is a visual artist creating expressive works inspired by emotion, nature, and daily life. Their art invites reflection through bold color, texture, and storytelling.'),
                          SizedBox(height: 20,),
                          SpotifyPreviewWidget(trackId: '5GYgYjeC02l8fSkQ4ffyqd'),
                          SizedBox(height: 20,),
                          SpotifyPreviewWidget(trackId: '0PvFJmanyNQMseIFrU708S'),
                          SizedBox(height: 20,),
                          Text(style: Theme.of(context).textTheme.bodySmall,'[Your Name] is a visual artist creating expressive works inspired by emotion, nature, and daily life. Their art invites reflection through bold color, texture, and storytelling.'),
                          SizedBox(height: 20,),
                          SpotifyPreviewWidget(trackId: '0PvFJmanyNQMseIFrU708S'),
                        ],
                      )
                    )
                  ) 
                ],
              ),
            ),


            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 200, // Adjust height to control how much of the content is blurred
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withAlpha(100), // dark fade to add contrast
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
} 