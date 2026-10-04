class ApiConstants {
  static const String baseUrl = 'http://10.0.2.2:8080'; // Emulador Android; localhost para web/desktop
  static const String orcamentos = '$baseUrl/api/orcamentos';
  static const String orcamentosPendentes = '$baseUrl/api/orcamentos/pendentes';
  static const String propostas = '$baseUrl/api/propostas';
  static const String horariosLivres = '$baseUrl/api/calendar/horarios-livres';
}
