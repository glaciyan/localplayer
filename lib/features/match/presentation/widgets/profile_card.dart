import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/icon_park_solid.dart';
import 'package:localplayer/features/map/presentation/widgets/profile_avatar.dart';
import 'package:localplayer/features/match/domain/entities/user_profile.dart';
import 'package:localplayer/features/match/presentation/blocs/match_block.dart';
import 'package:localplayer/features/match/presentation/blocs/match_event.dart';
import 'package:localplayer/spotify/presentation/widgets/spotify_preview_container.dart';

class ProfileCard extends StatelessWidget {
  final UserProfile profile;
  final CardSwiperController swiperController;

  const ProfileCard({super.key, required this.profile, required this.swiperController});

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
                profile.getBckgroundLink(),
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
                                ProfileAvatar(avatarLink: profile.avatarLink, color: Colors.green, scale: 100,),
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
                          SpotifyPreviewContainer(trackId: '3n3Ppam7vgaVa1iaRUc9Lp'),
                          
                          SizedBox(height: 20,),
                          SpotifyPreviewContainer(trackId: '5GYgYjeC02l8fSkQ4ffyqd'),
                          SizedBox(height: 20,),

                          SpotifyPreviewContainer(trackId: '0PvFJmanyNQMseIFrU708S'),
                          SizedBox(height: 20,),

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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).highlightColor,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              onPressed: () {
                                context.read<MatchBloc>().add(DislikePressed(profile));
                                swiperController.swipe(CardSwiperDirection.left);
                              },
                              icon: Iconify(
                                IconParkSolid.dislike_two,
                                size: 50,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 20), // 🛠 Reduce this spacing

                        Flexible(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              onPressed: () {
                                context.read<MatchBloc>().add(LikePressed(profile));
                                swiperController.swipe(CardSwiperDirection.right);
                              },
                              icon: Iconify(
                                IconParkSolid.like,
                                size: 50,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                )
            )
          ],
        )
      )
    );
  }
}