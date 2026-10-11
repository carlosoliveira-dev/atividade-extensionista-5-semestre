import 'dart:convert';
import 'package:shelf/shelf.dart';
import '../../domain/usecases/autenticar_chapeador_usecase.dart';

class AuthController {
  final AutenticarChapeadorUseCase autenticarChapeadorUseCase;

  AuthController({required this.autenticarChapeadorUseCase});

  Future<Response> login(Request request) async {
    try {
      final bodyStr = await request.readAsString();
      final body = jsonDecode(bodyStr) as Map<String, dynamic>;

      final email = body['email'] as String?;
      final senha = body['senha'] as String?;

      if (email == null || email.isEmpty || senha == null || senha.isEmpty) {
        return Response.badRequest(
          body: jsonEncode({
            'success': false,
            'message': 'E-mail e senha são obrigatórios.',
          }),
          headers: {'content-type': 'application/json'},
        );
      }

      final chapeador = await autenticarChapeadorUseCase.executar(email, senha);

      if (chapeador == null) {
        return Response.forbidden(
          jsonEncode({
            'success': false,
            'message': 'E-mail ou senha inválidos.',
          }),
          headers: {'content-type': 'application/json'},
        );
      }

      return Response.ok(
        jsonEncode({
          'success': true,
          'data': {
            'id': chapeador.id,
            'nome': chapeador.nome,
            'email': chapeador.email,
          },
        }),
        headers: {'content-type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({
          'success': false,
          'message': 'Erro interno ao realizar login: $e',
        }),
        headers: {'content-type': 'application/json'},
      );
    }
  }
}
