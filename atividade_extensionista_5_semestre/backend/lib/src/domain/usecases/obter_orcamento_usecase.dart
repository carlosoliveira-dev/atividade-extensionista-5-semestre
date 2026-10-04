import '../entities/orcamento.dart';
import '../repositories/orcamento_repository.dart';

class ObterOrcamentoUseCase {
  final OrcamentoRepository repository;

  ObterOrcamentoUseCase(this.repository);

  Future<Orcamento?> execute(String id) async {
    return await repository.obterPorId(id);
  }
}
