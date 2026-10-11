import '../../data/datasources/database_datasource.dart';
import '../../data/models/chapeador_model.dart';

class AutenticarChapeadorUseCase {
  final DatabaseDatasource datasource;

  AutenticarChapeadorUseCase(this.datasource);

  Future<ChapeadorModel?> executar(String email, String senha) async {
    final chapeador = await datasource.buscarChapeadorPorEmail(email);
    if (chapeador == null) return null;
    if (chapeador.senha != senha) return null;
    return chapeador;
  }
}
