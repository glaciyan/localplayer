abstract class SpotifyPreviewState {}

class SpotifyPreviewInitial extends SpotifyPreviewState {}

class SpotifyPreviewLoading extends SpotifyPreviewState {}

class SpotifyPreviewLoaded extends SpotifyPreviewState {
  final String filePath;
  SpotifyPreviewLoaded(this.filePath);
}

class SpotifyPreviewError extends SpotifyPreviewState {
  final String message;
  SpotifyPreviewError(this.message);
}
