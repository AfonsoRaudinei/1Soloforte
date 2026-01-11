/// Authentication State
class AuthState {
  final String userId;
  final String email;
  final String name;
  final String token;
  final String refreshToken;
  final bool isDemo;

  const AuthState({
    required this.userId,
    required this.email,
    required this.name,
    required this.token,
    required this.refreshToken,
    this.isDemo = false,
  });

  AuthState.authenticated({
    required this.userId,
    required this.email,
    required this.name,
    required this.token,
    required this.refreshToken,
    this.isDemo = false,
  });

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'email': email,
    'name': name,
    'token': token,
    'refreshToken': refreshToken,
    'isDemo': isDemo,
  };

  factory AuthState.fromJson(Map<String, dynamic> json) => AuthState(
    userId: json['userId'] as String,
    email: json['email'] as String,
    name: json['name'] as String,
    token: json['token'] as String,
    refreshToken: json['refreshToken'] as String,
    isDemo: json['isDemo'] as bool? ?? false,
  );
}
