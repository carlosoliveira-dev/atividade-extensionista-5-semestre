import '../entities/proposta.dart';

abstract class PropostaRepository {
  Future<Proposta> criarProposta(Proposta proposta);
  Future<Proposta?> obterPorOrcamentoId(String orcamentoId);
}
