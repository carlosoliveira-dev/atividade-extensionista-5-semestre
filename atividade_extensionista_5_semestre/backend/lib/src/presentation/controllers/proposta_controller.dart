import 'dart:convert';
import 'package:shelf/shelf.dart';
import '../../data/models/proposta_model.dart';
import '../../domain/usecases/consultar_horarios_livres_usecase.dart';
import '../../domain/usecases/emitir_proposta_usecase.dart';

class PropostaController {
  final EmitirPropostaUseCase emitirPropostaUseCase;
  final ConsultarHorariosLivresUseCase consultarHorariosLivresUseCase;

  PropostaController({
    required this.emitirPropostaUseCase,
    required this.consultarHorariosLivresUseCase,
  });

  Future<Response> emitir(Request request) async {
    try {
      final bodyText = await request.readAsString();
      final data = jsonDecode(bodyText) as Map<String, dynamic>;

      final orcamentoId = data['orcamentoId'] as String;
      final valorEstimado = (data['valorEstimado'] as num).toDouble();
      final prazoEntrega = data['prazoEntrega'] as String;
      final observacoes = data['observacoes'] as String?;
      final dataHorarioStr = data['dataHorarioAgendado'] as String?;

      final dataHorarioAgendado = dataHorarioStr != null ? DateTime.parse(dataHorarioStr) : null;

      final proposta = await emitirPropostaUseCase.execute(
        orcamentoId: orcamentoId,
        valorEstimado: valorEstimado,
        prazoEntrega: prazoEntrega,
        observacoes: observacoes,
        dataHorarioAgendado: dataHorarioAgendado,
      );

      return Response.ok(
        jsonEncode({
          'success': true,
          'data': PropostaModel.fromEntity(proposta).toJson(),
          'error': null,
        }),
        headers: {'content-type': 'application/json'},
      );
    } catch (e) {
      return Response.badRequest(
        body: jsonEncode({
          'success': false,
          'data': null,
          'error': e.toString(),
        }),
        headers: {'content-type': 'application/json'},
      );
    }
  }

  Future<Response> consultarHorariosLivres(Request request) async {
    try {
      final queryParams = request.url.queryParameters;
      final dataStr = queryParams['data'] ?? DateTime.now().toIso8601String().split('T').first;
      final data = DateTime.parse(dataStr);

      final horarios = await consultarHorariosLivresUseCase.execute(data);

      return Response.ok(
        jsonEncode({
          'success': true,
          'data': horarios.map((h) => h.toIso8601String()).toList(),
          'error': null,
        }),
        headers: {'content-type': 'application/json'},
      );
    } catch (e) {
      return Response.badRequest(
        body: jsonEncode({
          'success': false,
          'data': null,
          'error': e.toString(),
        }),
        headers: {'content-type': 'application/json'},
      );
    }
  }
}
