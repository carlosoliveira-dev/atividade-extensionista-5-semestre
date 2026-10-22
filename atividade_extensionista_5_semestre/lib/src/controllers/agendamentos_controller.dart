import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/agendamento_model.dart';
import '../repositories/orcamento_repository.dart';

class AgendamentosController extends ChangeNotifier {
  final OrcamentoRepository repository;

  AgendamentosController({OrcamentoRepository? repository})
      : repository = repository ?? OrcamentoRepository();

  List<AgendamentoModel> agendamentos = [];
  bool isLoading = false;
  String? errorMessage;

  Future<void> carregarAgendamentos() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      agendamentos = await repository.buscarAgendamentos();
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      errorMessage = 'Erro ao carregar agendamentos: $e';
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>?> buscarDetalhesProposta(String propostaId) async {
    try {
      return await repository.buscarDetalhesProposta(propostaId);
    } catch (e) {
      errorMessage = 'Erro ao buscar detalhes: $e';
      notifyListeners();
      return null;
    }
  }

  Future<bool> adicionarAoGoogleCalendar(AgendamentoModel agendamento) async {
    try {
      final inicio = agendamento.dataHorarioMarcados;
      final fim = inicio.add(const Duration(hours: 2));

      final format = DateFormat("yyyyMMdd'T'HHmmss");
      final startFormatted = format.format(inicio.toUtc());
      final endFormatted = format.format(fim.toUtc());

      final titulo = 'Serviço de Funilaria - Impact Car (${agendamento.id})';
      final descricao = 'Agendamento de serviço de funilaria/pintura.\n'
          'Status: ${agendamento.status.toUpperCase()}\n'
          'ID Google Calendar: ${agendamento.idEventoExterno}';

      // URL de template do Google Calendar.
      // O Android utiliza "App Links" para interceptar este link e abrir DIRETAMENTE o aplicativo nativo 
      // do Google Calendar com Título, Descrição e Horários preenchidos automaticamente!
      final calendarUrl = 'https://calendar.google.com/calendar/render'
          '?action=TEMPLATE'
          '&text=${Uri.encodeComponent(titulo)}'
          '&dates=${startFormatted}Z/${endFormatted}Z'
          '&details=${Uri.encodeComponent(descricao)}';

      final uri = Uri.parse(calendarUrl);

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        return true;
      } else {
        // Se o Google Calendar não estiver instalado ou não puder ser aberto, abrir a Google Play Store
        final playStoreUri = Uri.parse('https://play.google.com/store/apps/details?id=com.google.android.calendar');
        await launchUrl(playStoreUri, mode: LaunchMode.externalApplication);
        return true;
      }
    } catch (e) {
      errorMessage = 'Erro ao abrir Google Calendar: $e';
      notifyListeners();
      return false;
    }
  }
}
