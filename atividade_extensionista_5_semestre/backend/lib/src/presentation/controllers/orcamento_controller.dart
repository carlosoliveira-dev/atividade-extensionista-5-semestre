import 'dart:convert';
import 'package:shelf/shelf.dart';
import '../../data/models/orcamento_model.dart';
import '../../domain/entities/foto_orcamento.dart';
import '../../domain/entities/orcamento.dart';
import '../../domain/usecases/criar_orcamento_usecase.dart';
import '../../domain/usecases/listar_orcamentos_pendentes_usecase.dart';
import '../../domain/usecases/obter_orcamento_usecase.dart';

class OrcamentoController {
  final CriarOrcamentoUseCase criarOrcamentoUseCase;
  final ListarOrcamentosPendentesUseCase listarPendentesUseCase;
  final ObterOrcamentoUseCase obterOrcamentoUseCase;

  OrcamentoController({
    required this.criarOrcamentoUseCase,
    required this.listarPendentesUseCase,
    required this.obterOrcamentoUseCase,
  });

  Future<Response> criar(Request request) async {
    try {
      final bodyText = await request.readAsString();
      final data = jsonDecode(bodyText) as Map<String, dynamic>;

      final id = 'orc_${DateTime.now().millisecondsSinceEpoch}';
      final fotosJson = (data['fotos'] as List<dynamic>?) ?? [];

      final fotos = fotosJson.map((f) {
        final fMap = f as Map<String, dynamic>;
        return FotoOrcamento(
          id: 'foto_${DateTime.now().millisecondsSinceEpoch}_${fMap['ordemCategory']}',
          orcamentoId: id,
          caminhoArquivo: fMap['caminhoArquivo'] as String? ?? 'uploads/default.jpg',
          urlAcesso: fMap['urlAcesso'] as String? ?? fMap['caminhoArquivo'] as String? ?? 'uploads/default.jpg',
          ordemCategoria: fMap['ordemCategoria'] as String? ?? 'Foto',
        );
      }).toList();

      final orcamentoInput = Orcamento(
        id: id,
        clienteNome: data['clienteNome'] as String? ?? '',
        clienteTelefone: data['clienteTelefone'] as String? ?? '',
        veiculoModelo: data['veiculoModelo'] as String? ?? '',
        veiculoPlaca: data['veiculoPlaca'] as String? ?? '',
        descricaoDano: data['descricaoDano'] as String? ?? '',
        status: StatusOrcamento.pendente,
        dataCriacao: DateTime.now(),
        fotos: fotos,
      );

      final resultado = await criarOrcamentoUseCase.execute(orcamentoInput);
      final model = OrcamentoModel.fromEntity(resultado);

      return Response.ok(
        jsonEncode({
          'success': true,
          'data': model.toJson(),
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

  Future<Response> listarPendentes(Request request) async {
    try {
      final lista = await listarPendentesUseCase.execute();
      final models = lista.map((o) => OrcamentoModel.fromEntity(o).toJson()).toList();

      return Response.ok(
        jsonEncode({
          'success': true,
          'data': models,
          'error': null,
        }),
        headers: {'content-type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({
          'success': false,
          'data': null,
          'error': e.toString(),
        }),
        headers: {'content-type': 'application/json'},
      );
    }
  }

  Future<Response> obterPorId(Request request, String id) async {
    try {
      final orcamento = await obterOrcamentoUseCase.execute(id);
      if (orcamento == null) {
        return Response.notFound(
          jsonEncode({
            'success': false,
            'data': null,
            'error': 'Orçamento não encontrado',
          }),
          headers: {'content-type': 'application/json'},
        );
      }

      return Response.ok(
        jsonEncode({
          'success': true,
          'data': OrcamentoModel.fromEntity(orcamento).toJson(),
          'error': null,
        }),
        headers: {'content-type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(
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
