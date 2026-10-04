import '../entities/agendamento.dart';

abstract class AgendamentoRepository {
  Future<Agendamento> criarAgendamento(Agendamento agendamento);
  Future<List<Agendamento>> listarAgendamentos();
}
