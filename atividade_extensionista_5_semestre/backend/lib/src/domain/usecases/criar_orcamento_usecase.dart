import '../entities/orcamento.dart';
import '../repositories/orcamento_repository.dart';

class CriarOrcamentoUseCase {
  final OrcamentoRepository repository;

  CriarOrcamentoUseCase(this.repository);

  Future<Orcamento> execute(Orcamento orcamento) async {
    if (orcamento.clienteNome.trim().isEmpty) {
      throw ArgumentError('O nome do cliente é obrigatório.');
    }
    if (orcamento.clienteTelefone.trim().isEmpty) {
      throw ArgumentError('O telefone de contato é obrigatório.');
    }
    if (orcamento.veiculoPlaca.trim().isEmpty) {
      throw ArgumentError('A placa do veículo é obrigatória.');
    }
    if (orcamento.fotos.length < 3 || orcamento.fotos.length > 5) {
      throw ArgumentError('É necessário enviar entre 3 e 5 fotos do dano.');
    }

    return await repository.criarOrcamento(orcamento);
  }
}
