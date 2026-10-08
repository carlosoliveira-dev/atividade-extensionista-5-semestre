import 'package:flutter/services.dart' show rootBundle;

class ApiConstants {
  static String _backendIp = '10.0.2.2';
  static String _backendPort = '8080';

  /// Carrega as variáveis de ambiente do arquivo assets/.env
  static Future<void> loadEnv() async {
    try {
      final content = await rootBundle.loadString('assets/.env');
      final lines = content.split('\n');
      for (final line in lines) {
        final trimmed = line.trim();
        if (trimmed.isEmpty || trimmed.startsWith('#')) continue;
        final parts = trimmed.split('=');
        if (parts.length >= 2) {
          final key = parts[0].trim();
          final value = parts.sublist(1).join('=').trim();
          if (key == 'BACKEND_IP' && value.isNotEmpty) {
            _backendIp = value;
          }
          if (key == 'BACKEND_PORT' && value.isNotEmpty) {
            _backendPort = value;
          }
        }
      }
    } catch (_) {
      // Mantém os valores padrão caso ocorra algum erro na leitura
    }
  }

  static String get baseUrl => 'http://$_backendIp:$_backendPort';

  static String get orcamentos => '$baseUrl/api/orcamentos';
  static String get orcamentosPendentes => '$baseUrl/api/orcamentos/pendentes';
  static String get propostas => '$baseUrl/api/propostas';
  static String get horariosLivres => '$baseUrl/api/calendar/horarios-livres';
  static String get agendamentos => '$baseUrl/api/agendamentos';
}
