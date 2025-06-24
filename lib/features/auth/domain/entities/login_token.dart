class LoginToken {
  final String token;

  LoginToken({required this.token});

  factory LoginToken.fromJson(final Map<String, dynamic> json) =>
      LoginToken(token: json['token'] as String);
}
