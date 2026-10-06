import 'dart:io';

class DatabaseConfig {
  final String host;
  final int port;
  final String dbName;
  final String user;
  final String password;

  DatabaseConfig({
    required this.host,
    required this.port,
    required this.dbName,
    required this.user,
    required this.password,
  });

  factory DatabaseConfig.carregar() {
    Map<String, String> envMap = {};

    // Tenta carregar arquivo .env na pasta do backend se existir
    final envFile = File('.env');
    if (envFile.existsSync()) {
      try {
        final lines = envFile.readAsLinesSync();
        for (final line in lines) {
          final trimmed = line.trim();
          if (trimmed.isEmpty || trimmed.startsWith('#')) continue;
          final parts = trimmed.split('=');
          if (parts.length >= 2) {
            final key = parts[0].trim();
            final value = parts.sublist(1).join('=').trim();
            envMap[key] = value;
          }
        }
      } catch (_) {}
    }

    return DatabaseConfig(
      host: Platform.environment['DB_HOST'] ?? envMap['DB_HOST'] ?? 'localhost',
      port: int.parse(Platform.environment['DB_PORT'] ?? envMap['DB_PORT'] ?? '5432'),
      dbName: Platform.environment['DB_NAME'] ?? envMap['DB_NAME'] ?? 'impactcar_db',
      user: Platform.environment['DB_USER'] ?? envMap['DB_USER'] ?? 'postgres',
      password: Platform.environment['DB_PASSWORD'] ?? envMap['DB_PASSWORD'] ?? 'postgres',
    );
  }
}
