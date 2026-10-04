import '../../domain/repositories/google_calendar_repository.dart';
import '../datasources/google_calendar_datasource.dart';

class GoogleCalendarRepositoryImpl implements GoogleCalendarRepository {
  final GoogleCalendarDatasource datasource;

  GoogleCalendarRepositoryImpl(this.datasource);

  @override
  Future<List<DateTime>> obterHorariosLivres(DateTime data) async {
    return await datasource.buscarHorariosLivres(data);
  }

  @override
  Future<String> criarEventoAgenda({
    required String titulo,
    required String descricao,
    required DateTime dataHorario,
  }) async {
    return await datasource.criarEvento(
      titulo: titulo,
      descricao: descricao,
      dataHorario: dataHorario,
    );
  }
}
