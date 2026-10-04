import '../../domain/entities/orcamento.dart';
import '../../domain/repositories/orcamento_repository.dart';
import '../datasources/database_datasource.dart';
import '../models/orcamento_model.dart';

class OrcamentoRepositoryImpl implements OrcamentoRepository {
  final DatabaseDatasource datasource;

  OrcamentoRepositoryImpl(this.datasource);

  @override
  Future<Orcamento> criarOrcamento(Orcamento orcamento) async {
    final model = OrcamentoModel.fromEntity(orcamento);
    return await datasource.salvarOrcamento(model);
  }

  @override
  Future<List<Orcamento>> listarPendentes() async {
    return await datasource.buscarPendentes();
  }

  @override
  Future<Orcamento?> obterPorId(String id) async {
    return await datasource.buscarOrcamentoPorId(id);
  }

  @override
  Future<void> atualizarStatus(String id, StatusOrcamento novoStatus) async {
    await datasource.atualizarStatusOrcamento(id, novoStatus);
  }
}
