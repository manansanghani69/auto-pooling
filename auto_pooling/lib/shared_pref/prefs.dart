class Prefs {
  static final Map<String, Object> _cache = <String, Object>{};

  static Future<void> init() async {
    // In-memory placeholder until storage integration is added.
  }

  static Future<void> setString(String key, String value) async {
    _cache[key] = value;
  }

  static Future<String?> getString(String key) async {
    final value = _cache[key];
    if (value is String) {
      return value;
    }
    return null;
  }

  static Future<void> clear() async {
    _cache.clear();
  }
}
