import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localplayer/core/services/spotify/presentation/blocs/sptofiy_preview_state.dart';
import 'package:path_provider/path_provider.dart';

class SpotifyPreviewCubit extends Cubit<SpotifyPreviewState> {
  final Dio dio;

  SpotifyPreviewCubit(this.dio) : super(SpotifyPreviewInitial());

  Future<void> loadAndPlayPreview(String trackId) async {
    if (trackId.isEmpty) {
      emit(SpotifyPreviewError('Track ID is empty'));
      return;
    }

    try {
      emit(SpotifyPreviewLoading());

      final response = await dio.get<List<int>>(
        '/spotify/preview',
        queryParameters: {'trackId': trackId},
        options: Options(responseType: ResponseType.bytes),
      );

      final bytes = response.data!;

      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/$trackId.mp3');
      await file.writeAsBytes(bytes);
      final fileSize = await file.length();

      emit(SpotifyPreviewLoaded(file.path));
    } catch (e) {
      emit(SpotifyPreviewError(e.toString()));
    }
  }
}
