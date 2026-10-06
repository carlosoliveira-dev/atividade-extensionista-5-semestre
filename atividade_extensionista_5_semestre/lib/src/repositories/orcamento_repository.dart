import '../core/constants/api_constants.dart';
import '../models/agendamento_model.dart';
import '../models/orcamento_model.dart';
import '../models/proposta_model.dart';
import '../services/api_service.dart';

class OrcamentoRepository {
  final ApiService apiService;

  OrcamentoRepository({ApiService? apiService})
      : apiService = apiService ?? ApiService();

  Future<OrcamentoModel> enviarOrcamento(Map<String, dynamic> dadosOrcamento) async {
    final response = await apiService.post(ApiConstants.orcamentos, dadosOrcamento);
    if (response['success'] == true && response['data'] != null) {
      return OrcamentoModel.fromJson(response['data'] as Map<String, dynamic>);
    }
    throw Exception(response['error'] ?? 'Falha ao enviar orçamento.');
  }

  Future<List<OrcamentoModel>> buscarOrcamentosPendentes() async {
    final response = await apiService.get(ApiConstants.orcamentosPendentes);
    if (response['success'] == true && response['data'] != null) {
      final list = response['data'] as List<dynamic>;
      return list.map((item) => OrcamentoModel.fromJson(item as Map<String, dynamic>)).toList();
    }
    throw Exception(response['error'] ?? 'Falha ao buscar orçamentos pendentes.');
  }

  Future<PropostaModel> emitirProposta({
    required String orcamentoId,
    required double valorEstimado,
    required String prazoEntrega,
    String? observacoes,
    DateTime? dataHorarioAgendado,
  }) async {
    final body = {
      'orcamentoId': orcamentoId,
      'valorEstimado': valorEstimado,
      'prazoEntrega': prazoEntrega,
      'observacoes': observacoes,
      if (dataHorarioAgendado != null)
        'dataHorarioAgendado': dataHorarioAgendado.toIso8601String(),
    };

    final response = await apiService.post(ApiConstants.propostas, body);
    if (response['success'] == true && response['data'] != null) {
      return PropostaModel.fromJson(response['data'] as Map<String, dynamic>);
    }
    throw Exception(response['error'] ?? 'Falha ao emitir proposta.');
  }

  Future<List<DateTime>> consultarHorariosLivres(DateTime data) async {
    final url = '${ApiConstants.horariosLivres}?data=${data.toIso8601String().split('T').first}';
    final response = await apiService.get(url);
    if (response['success'] == true && response['data'] != null) {
      final list = response['data'] as List<dynamic>;
      return list.map((item) => DateTime.parse(item as String)).toList();
    }
    return [];
  }

  Future<List<AgendamentoModel>> buscarAgendamentos() async {
    final response = await apiService.get(ApiConstants.agendamentos);
    if (response['success'] == true && response['data'] != null) {
      final list = response['data'] as List<dynamic>;
      return list.map((item) => AgendamentoModel.fromJson(item as Map<String, dynamic>)).toList();
    }
    return [];
  }
}
