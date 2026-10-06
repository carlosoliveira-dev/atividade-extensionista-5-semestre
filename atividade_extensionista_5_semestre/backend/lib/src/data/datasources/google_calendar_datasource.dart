class GoogleCalendarDatasource {
  GoogleCalendarDatasource();

  Future<List<DateTime>> buscarHorariosLivres(DateTime data) async {
    final ano = data.year;
    final mes = data.month;
    final dia = data.day;

    return [
      DateTime(ano, mes, dia, 8, 30),
      DateTime(ano, mes, dia, 10, 0),
      DateTime(ano, mes, dia, 13, 30),
      DateTime(ano, mes, dia, 15, 30),
      DateTime(ano, mes, dia, 17, 0),
    ];
  }

  Future<String> criarEvento({
    required String titulo,
    required String descricao,
    required DateTime dataHorario,
  }) async {
    final idExterno = 'gcal_event_${DateTime.now().millisecondsSinceEpoch}';

    print('📅 [Google Calendar API] Evento criado com sucesso na agenda do profissional!');
    print('   • Título: $titulo');
    print('   • Data/Horário: $dataHorario');
    print('   • ID Externo do Evento: $idExterno');

    return idExterno;
  }
}
