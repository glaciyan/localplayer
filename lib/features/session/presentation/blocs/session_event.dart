abstract class SessionEvent {}

class LoadSession extends SessionEvent {}

class CreateSession extends SessionEvent {
  final double latitude;
  final double longitude;
  final String name;
  final bool open;

  CreateSession(this.latitude, this.longitude, this.name, this.open);
}

class CloseSession extends SessionEvent {
  final int id;

  CloseSession(this.id);
}
