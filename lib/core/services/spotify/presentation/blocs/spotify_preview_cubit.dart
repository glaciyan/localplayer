import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localplayer/core/network/api_client.dart';
import 'package:localplayer/core/network/api_error_exception.dart';
import 'package:localplayer/core/network/no_connection_exception.dart';
import 'package:localplayer/core/services/spotify/presentation/blocs/sptofiy_preview_state.dart';
import 'package:path_provider/path_provider.dart';

class SpotifyPreviewCubit extends Cubit<SpotifyPreviewState> {
  final ApiClient dio;

  SpotifyPreviewCubit(this.dio) : super(SpotifyPreviewInitial());

  Future<void> loadAndPlayPreview(final String trackId) async {
    if (trackId.isEmpty) {
      emit(SpotifyPreviewError('Track ID is empty'));
      return;
    }

    try {
      emit(SpotifyPreviewLoading());

      final Response<dynamic> response = await dio.get(
        '/spotify/preview',
        queryParameters: <String, dynamic>{'trackId': trackId},
        options: Options(responseType: ResponseType.bytes),
      );

      final List<int> bytes = response.data!;

      final Directory dir = await getTemporaryDirectory();
      final File file = File('${dir.path}/$trackId.mp3');
      await file.writeAsBytes(bytes);

      emit(SpotifyPreviewLoaded(file.path));
    } on NoConnectionException {
      emit(SpotifyPreviewError("You have no internet connection"));
    } catch (e) {
      if (e is ApiErrorException) {
        emit(SpotifyPreviewError(e.message));
      } else {
        emit(SpotifyPreviewError(e.toString()));
      }
    }
  }
}
