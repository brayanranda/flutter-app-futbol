class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  String? _token;

  String? get token => _token;

  // Simplified: Now only in-memory to avoid MissingPluginException
  void saveToken(String token) {
    _token = token;
  }

  void clearToken() {
    _token = null;
  }

  bool get isAuthenticated => _token != null;
}
