import '../../domain/entities/agendamento.dart';
import '../../domain/repositories/agendamento_repository.dart';
import '../datasources/database_datasource.dart';
import '../models/agendamento_model.dart';

class AgendamentoRepositoryImpl implements AgendamentoRepository {
  final DatabaseDatasource datasource;

  AgendamentoRepositoryImpl(this.datasource);

  @override
  Future<Agendamento> criarAgendamento(Agendamento agendamento) async {
    final model = AgendamentoModel.fromEntity(agendamento);
    return await datasource.salvarAgendamento(model);
  }

  @override
  Future<List<Agendamento>> listarAgendamentos() async {
    return await datasource.buscarAgendamentos();
  }
}
