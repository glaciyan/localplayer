import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:localplayer/core/entities/user_profile.dart';
import 'package:localplayer/features/match/domain/repositories/match_repository.dart';

class MatchRepositoryImpl implements MatchRepository {
  @override
  Future<List<UserProfile>> fetchProfiles() async {
    final String jsonString = await rootBundle.loadString('assets/profiles.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((final dynamic e) => UserProfile.fromJson(e)).toList();
  }

  @override
  Future<void> like(final UserProfile user) async {
    //print('Liked: ${user.displayName}');
  }

  @override
  Future<void> dislike(final UserProfile user) async {
    //print('Disliked: ${user.displayName}');
  }
}