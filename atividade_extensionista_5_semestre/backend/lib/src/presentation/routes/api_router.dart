import 'package:shelf_router/shelf_router.dart';
import '../controllers/auth_controller.dart';
import '../controllers/orcamento_controller.dart';
import '../controllers/proposta_controller.dart';

Router buildApiRouter({
  required AuthController authController,
  required OrcamentoController orcamentoController,
  required PropostaController propostaController,
}) {
  final router = Router();

  // Rotas de Autenticação
  router.post('/api/auth/login', authController.login);

  // Rotas de Orçamento
  router.post('/api/orcamentos', orcamentoController.criar);
  router.get('/api/orcamentos/pendentes', orcamentoController.listarPendentes);
  router.get('/api/orcamentos/<id>', orcamentoController.obterPorId);

  // Rotas de Proposta e Agenda (Google Calendar)
  router.post('/api/propostas', propostaController.emitir);
  router.get('/api/propostas/detalhes/<id>', propostaController.obterDetalhesPorPropostaId);
  router.get('/api/calendar/horarios-livres', propostaController.consultarHorariosLivres);
  router.get('/api/agendamentos', propostaController.listarAgendamentos);

  return router;
}
