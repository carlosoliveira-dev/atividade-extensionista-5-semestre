import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_static/shelf_static.dart';

import 'package:backend/src/data/datasources/database_datasource.dart';
import 'package:backend/src/data/datasources/google_calendar_datasource.dart';
import 'package:backend/src/data/repositories/agendamento_repository_impl.dart';
import 'package:backend/src/data/repositories/google_calendar_repository_impl.dart';
import 'package:backend/src/data/repositories/orcamento_repository_impl.dart';
import 'package:backend/src/data/repositories/proposta_repository_impl.dart';
import 'package:backend/src/domain/usecases/consultar_horarios_livres_usecase.dart';
import 'package:backend/src/domain/usecases/criar_orcamento_usecase.dart';
import 'package:backend/src/domain/usecases/emitir_proposta_usecase.dart';
import 'package:backend/src/domain/usecases/listar_orcamentos_pendentes_usecase.dart';
import 'package:backend/src/domain/usecases/obter_orcamento_usecase.dart';
import 'package:backend/src/presentation/controllers/orcamento_controller.dart';
import 'package:backend/src/presentation/controllers/proposta_controller.dart';
import 'package:backend/src/presentation/middlewares/cors_middleware.dart';
import 'package:backend/src/presentation/routes/api_router.dart';

void main(List<String> args) async {
  // Configuração das camadas Clean Architecture
  final dbDatasource = DatabaseDatasource();
  final calendarDatasource = GoogleCalendarDatasource();

  final orcamentoRepository = OrcamentoRepositoryImpl(dbDatasource);
  final propostaRepository = PropostaRepositoryImpl(dbDatasource);
  final agendamentoRepository = AgendamentoRepositoryImpl(dbDatasource);
  final calendarRepository = GoogleCalendarRepositoryImpl(calendarDatasource);

  final criarOrcamentoUseCase = CriarOrcamentoUseCase(orcamentoRepository);
  final listarPendentesUseCase = ListarOrcamentosPendentesUseCase(orcamentoRepository);
  final obterOrcamentoUseCase = ObterOrcamentoUseCase(orcamentoRepository);

  final emitirPropostaUseCase = EmitirPropostaUseCase(
    orcamentoRepository: orcamentoRepository,
    propostaRepository: propostaRepository,
    agendamentoRepository: agendamentoRepository,
    calendarRepository: calendarRepository,
  );
  final consultarHorariosUseCase = ConsultarHorariosLivresUseCase(calendarRepository);

  final orcamentoController = OrcamentoController(
    criarOrcamentoUseCase: criarOrcamentoUseCase,
    listarPendentesUseCase: listarPendentesUseCase,
    obterOrcamentoUseCase: obterOrcamentoUseCase,
  );

  final propostaController = PropostaController(
    emitirPropostaUseCase: emitirPropostaUseCase,
    consultarHorariosLivresUseCase: consultarHorariosUseCase,
  );

  final apiRouter = buildApiRouter(
    orcamentoController: orcamentoController,
    propostaController: propostaController,
  );

  // Servidor de arquivos estáticos para foto de uploads se houver
  final uploadsDir = Directory('uploads');
  if (!await uploadsDir.exists()) {
    await uploadsDir.create(recursive: true);
  }
  final staticHandler = createStaticHandler('uploads', defaultDocument: '');

  final cascade = Cascade()
      .add(apiRouter.call)
      .add(staticHandler);

  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(corsMiddleware())
      .addHandler(cascade.handler);

  final ip = InternetAddress.anyIPv4;
  final port = int.parse(Platform.environment['PORT'] ?? '8080');

  final server = await io.serve(handler, ip, port);
  print('Servidor Backend Impact Car iniciado em http://${server.address.host}:${server.port}');
}
