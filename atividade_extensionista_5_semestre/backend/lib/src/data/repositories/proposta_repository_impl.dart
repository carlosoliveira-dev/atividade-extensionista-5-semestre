import '../../domain/entities/proposta.dart';
import '../../domain/repositories/proposta_repository.dart';
import '../datasources/database_datasource.dart';
import '../models/proposta_model.dart';

class PropostaRepositoryImpl implements PropostaRepository {
  final DatabaseDatasource datasource;

  PropostaRepositoryImpl(this.datasource);

  @override
  Future<Proposta> criarProposta(Proposta proposta) async {
    final model = PropostaModel.fromEntity(proposta);
    return await datasource.salvarProposta(model);
  }

  @override
  Future<Proposta?> obterPorOrcamentoId(String orcamentoId) async {
    return await datasource.buscarPropostaPorOrcamentoId(orcamentoId);
  }
}
