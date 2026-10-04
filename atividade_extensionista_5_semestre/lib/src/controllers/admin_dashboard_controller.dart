import 'package:flutter/material.dart';
import '../models/orcamento_model.dart';
import '../models/proposta_model.dart';
import '../repositories/orcamento_repository.dart';

class AdminDashboardController extends ChangeNotifier {
  final OrcamentoRepository repository;

  AdminDashboardController({OrcamentoRepository? repository})
      : repository = repository ?? OrcamentoRepository();

  List<OrcamentoModel> orcamentosPendentes = [];
  List<DateTime> horariosLivres = [];
  bool isLoading = false;
  String? errorMessage;

  Future<void> carregarPendentes() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      orcamentosPendentes = await repository.buscarOrcamentosPendentes();
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      errorMessage = 'Erro ao carregar fila de orçamentos: $e';
      notifyListeners();
    }
  }

  Future<void> carregarHorariosLivres(DateTime data) async {
    try {
      horariosLivres = await repository.consultarHorariosLivres(data);
      notifyListeners();
    } catch (e) {
      horariosLivres = [];
      notifyListeners();
    }
  }

  Future<PropostaModel?> emitirPropostaEAgendar({
    required String orcamentoId,
    required double valorEstimado,
    required String prazoEntrega,
    String? observacoes,
    DateTime? dataHorarioAgendado,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final proposta = await repository.emitirProposta(
        orcamentoId: orcamentoId,
        valorEstimado: valorEstimado,
        prazoEntrega: prazoEntrega,
        observacoes: observacoes,
        dataHorarioAgendado: dataHorarioAgendado,
      );

      // Remove da fila de pendentes
      orcamentosPendentes.removeWhere((o) => o.id == orcamentoId);
      isLoading = false;
      notifyListeners();
      return proposta;
    } catch (e) {
      isLoading = false;
      errorMessage = 'Erro ao emitir proposta: $e';
      notifyListeners();
      return null;
    }
  }
}
