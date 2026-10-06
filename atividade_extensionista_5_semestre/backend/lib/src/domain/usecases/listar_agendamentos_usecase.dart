import '../entities/agendamento.dart';
import '../repositories/agendamento_repository.dart';

class ListarAgendamentosUseCase {
  final AgendamentoRepository repository;

  ListarAgendamentosUseCase(this.repository);

  Future<List<Agendamento>> execute() async {
    return await repository.listarAgendamentos();
  }
}
