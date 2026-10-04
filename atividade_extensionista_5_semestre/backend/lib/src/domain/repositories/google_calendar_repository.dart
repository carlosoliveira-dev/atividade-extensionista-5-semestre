abstract class GoogleCalendarRepository {
  Future<List<DateTime>> obterHorariosLivres(DateTime data);
  Future<String> criarEventoAgenda({
    required String titulo,
    required String descricao,
    required DateTime dataHorario,
  });
}
