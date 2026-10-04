import '../models/agendamento_model.dart';
import '../models/orcamento_model.dart';
import '../models/proposta_model.dart';
import '../../domain/entities/orcamento.dart';

class DatabaseDatasource {
  final List<OrcamentoModel> _orcamentos = [];
  final List<PropostaModel> _propostas = [];
  final List<AgendamentoModel> _agendamentos = [];

  DatabaseDatasource();

  Future<OrcamentoModel> salvarOrcamento(OrcamentoModel orcamento) async {
    _orcamentos.add(orcamento);
    return orcamento;
  }

  Future<List<OrcamentoModel>> buscarPendentes() async {
    return _orcamentos.where((o) => o.status == StatusOrcamento.pendente).toList();
  }

  Future<OrcamentoModel?> buscarOrcamentoPorId(String id) async {
    try {
      return _orcamentos.firstWhere((o) => o.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> atualizarStatusOrcamento(String id, StatusOrcamento novoStatus) async {
    final index = _orcamentos.indexWhere((o) => o.id == id);
    if (index != -1) {
      final antigo = _orcamentos[index];
      _orcamentos[index] = OrcamentoModel(
        id: antigo.id,
        clienteNome: antigo.clienteNome,
        clienteTelefone: antigo.clienteTelefone,
        veiculoModelo: antigo.veiculoModelo,
        veiculoPlaca: antigo.veiculoPlaca,
        descricaoDano: antigo.descricaoDano,
        status: novoStatus,
        dataCriacao: antigo.dataCriacao,
        fotos: antigo.fotos,
        proposta: antigo.proposta,
      );
    }
  }

  Future<PropostaModel> salvarProposta(PropostaModel proposta) async {
    _propostas.add(proposta);
    return proposta;
  }

  Future<PropostaModel?> buscarPropostaPorOrcamentoId(String orcamentoId) async {
    try {
      return _propostas.firstWhere((p) => p.orcamentoId == orcamentoId);
    } catch (_) {
      return null;
    }
  }

  Future<AgendamentoModel> salvarAgendamento(AgendamentoModel agendamento) async {
    _agendamentos.add(agendamento);
    return agendamento;
  }

  Future<List<AgendamentoModel>> buscarAgendamentos() async {
    return List.unmodifiable(_agendamentos);
  }
}
