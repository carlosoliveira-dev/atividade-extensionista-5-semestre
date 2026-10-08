import 'package:flutter/material.dart';
import 'src/core/constants/api_constants.dart';
import 'src/core/theme/app_theme.dart';
import 'src/views/pages/admin_dashboard_page.dart';
import 'src/views/pages/agendamentos_page.dart';
import 'src/views/pages/chapeador_hub_page.dart';
import 'src/views/pages/home_page.dart';
import 'src/views/pages/novo_orcamento_page.dart';
import 'src/views/pages/sucesso_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ApiConstants.loadEnv();
  runApp(const ImpactCarApp());
}

class ImpactCarApp extends StatelessWidget {
  const ImpactCarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Impact Car - Triagem & Orçamento',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/novo_orcamento': (context) => const NovoOrcamentoPage(),
        '/sucesso': (context) => const SucessoPage(),
        '/chapeador_hub': (context) => const ChapeadorHubPage(),
        '/admin': (context) => const AdminDashboardPage(),
        '/agendamentos': (context) => const AgendamentosPage(),
      },
    );
  }
}
