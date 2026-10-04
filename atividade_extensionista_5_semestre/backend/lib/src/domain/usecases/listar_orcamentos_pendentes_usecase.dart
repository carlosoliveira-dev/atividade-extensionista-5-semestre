import '../entities/orcamento.dart';
import '../repositories/orcamento_repository.dart';

class ListarOrcamentosPendentesUseCase {
  final OrcamentoRepository repository;

  ListarOrcamentosPendentesUseCase(this.repository);

  Future<List<Orcamento>> execute() async {
    return await repository.listarPendentes();
  }
}
