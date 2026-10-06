import '../entities/agendamento.dart';
import '../entities/orcamento.dart';
import '../entities/proposta.dart';
import '../repositories/agendamento_repository.dart';
import '../repositories/google_calendar_repository.dart';
import '../repositories/orcamento_repository.dart';
import '../repositories/proposta_repository.dart';

class EmitirPropostaUseCase {
  final OrcamentoRepository orcamentoRepository;
  final PropostaRepository propostaRepository;
  final AgendamentoRepository agendamentoRepository;
  final GoogleCalendarRepository calendarRepository;

  EmitirPropostaUseCase({
    required this.orcamentoRepository,
    required this.propostaRepository,
    required this.agendamentoRepository,
    required this.calendarRepository,
  });

  Future<Proposta> execute({
    required String orcamentoId,
    required double valorEstimado,
    required String prazoEntrega,
    String? observacoes,
    DateTime? dataHorarioAgendado,
  }) async {
    final orcamento = await orcamentoRepository.obterPorId(orcamentoId);
    if (orcamento == null) {
      throw StateError('Orcamento não encontrado para o ID: $orcamentoId');
    }

    final propostaId = 'prop_${DateTime.now().millisecondsSinceEpoch}';

    // 1. Salvar a Proposta primeiro para satisfazer a restrição de Chave Estrangeira (FK) no PostgreSQL
    final proposta = Proposta(
      id: propostaId,
      orcamentoId: orcamentoId,
      valorEstimado: valorEstimado,
      prazoEntrega: prazoEntrega,
      observacoes: observacoes,
      dataEnvio: DateTime.now(),
    );

    final propostaCriada = await propostaRepository.criarProposta(proposta);

    // 2. Criar e salvar o Agendamento caso um horário tenha sido selecionado
    Agendamento? agendamento;
    if (dataHorarioAgendado != null) {
      final eventId = await calendarRepository.criarEventoAgenda(
        titulo: 'Serviço: ${orcamento.veiculoModelo} (${orcamento.veiculoPlaca})',
        descricao: 'Cliente: ${orcamento.clienteNome} (${orcamento.clienteTelefone})\n'
            'Prazo: $prazoEntrega\n'
            'Valor: R\$ ${valorEstimado.toStringAsFixed(2)}',
        dataHorario: dataHorarioAgendado,
      );

      agendamento = Agendamento(
        id: 'agend_${DateTime.now().millisecondsSinceEpoch}',
        propostaId: propostaId,
        idEventoExterno: eventId,
        dataHorarioMarcados: dataHorarioAgendado,
        status: StatusAgendamento.confirmado,
      );

      await agendamentoRepository.criarAgendamento(agendamento);
    }

    await orcamentoRepository.atualizarStatus(orcamentoId, StatusOrcamento.enviado);

    return Proposta(
      id: propostaCriada.id,
      orcamentoId: propostaCriada.orcamentoId,
      valorEstimado: propostaCriada.valorEstimado,
      prazoEntrega: propostaCriada.prazoEntrega,
      observacoes: propostaCriada.observacoes,
      dataEnvio: propostaCriada.dataEnvio,
      agendamento: agendamento,
    );
  }
}
