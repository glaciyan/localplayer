import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/icon_park_solid.dart';
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
              padding: EdgeInsets.fromLTRB(10, 30, 10, 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children:[
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ProfileAvatar(avatarLink: avatarLink,color: Colors.green),
                                SizedBox(width: 16,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,

                                  children:[
                                    Text('Artist', style: Theme.of(context).textTheme.titleLarge),
                                    Text('Artist Genre', style: Theme.of(context).textTheme.bodyMedium),
                                    Text('27.365 Monthly Listeners', style: Theme.of(context).textTheme.bodySmall)
                                    ]
                                ),
                                Spacer(flex: 5,)
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
                          SpotifyPreviewWidget(trackId: '3Lc2iEewvM7KoJi9zcN5bx'),
                          SizedBox(height: 20,),
                          SpotifyPreviewWidget(trackId: '5GYgYjeC02l8fSkQ4ffyqd'),
                          SizedBox(height: 20,),

                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              style: Theme.of(context).textTheme.bodySmall,
                              '[Your Name] is a visual artist creating expressive works inspired by emotion, nature, and daily life. Their art invites reflection through bold color, texture, and storytelling.'),
                          ),


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
              height: 350, 
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.center,
                      colors: [
                        Colors.black.withAlpha(150), // dark fade to add contrast
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
            ),

            Padding(
              padding: EdgeInsetsGeometry.all(40),
              child:
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                              
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        
                        Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).highlightColor,
                            shape: BoxShape.circle
                          ),
                          child: IconButton(
                            onPressed: () {  },
                            icon: Iconify(IconParkSolid.dislike_two, size: 50,color: Colors.white,)
                          ),
                        ),

                        SizedBox(width: 125,),

                        Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            shape: BoxShape.circle
                          ),
                          child: IconButton(
                            onPressed: () {  },
                            icon: Iconify(IconParkSolid.like, size: 50,color: Theme.of(context).primaryColor)
                          ),
                        ),
                      ],
                    ),
                  ],
                )
            )
          ],
        )
      )
    );
  }
}