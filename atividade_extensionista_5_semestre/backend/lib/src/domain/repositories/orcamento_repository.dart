import '../entities/orcamento.dart';

abstract class OrcamentoRepository {
  Future<Orcamento> criarOrcamento(Orcamento orcamento);
  Future<List<Orcamento>> listarPendentes();
  Future<Orcamento?> obterPorId(String id);
  Future<void> atualizarStatus(String id, StatusOrcamento novoStatus);
}
