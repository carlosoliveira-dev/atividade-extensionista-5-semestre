import 'foto_orcamento_model.dart';
import 'proposta_model.dart';

class OrcamentoModel {
  final String id;
  final String clienteNome;
  final String clienteTelefone;
  final String veiculoModelo;
  final String veiculoPlaca;
  final String descricaoDano;
  final String status;
  final DateTime dataCriacao;
  final List<FotoOrcamentoModel> fotos;
  final PropostaModel? proposta;

  OrcamentoModel({
    required this.id,
    required this.clienteNome,
    required this.clienteTelefone,
    required this.veiculoModelo,
    required this.veiculoPlaca,
    required this.descricaoDano,
    required this.status,
    required this.dataCriacao,
    this.fotos = const [],
    this.proposta,
  });

  factory OrcamentoModel.fromJson(Map<String, dynamic> json) {
    return OrcamentoModel(
      id: json['id'] as String? ?? '',
      clienteNome: json['clienteNome'] as String? ?? '',
      clienteTelefone: json['clienteTelefone'] as String? ?? '',
      veiculoModelo: json['veiculoModelo'] as String? ?? '',
      veiculoPlaca: json['veiculoPlaca'] as String? ?? '',
      descricaoDano: json['descricaoDano'] as String? ?? '',
      status: json['status'] as String? ?? 'pendente',
      dataCriacao: DateTime.parse(
        json['dataCriacao'] as String? ?? DateTime.now().toIso8601String(),
      ),
      fotos: (json['fotos'] as List<dynamic>?)
              ?.map((f) => FotoOrcamentoModel.fromJson(f as Map<String, dynamic>))
              .toList() ??
          [],
      proposta: json['proposta'] != null
          ? PropostaModel.fromJson(json['proposta'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clienteNome': clienteNome,
      'clienteTelefone': clienteTelefone,
      'veiculoModelo': veiculoModelo,
      'veiculoPlaca': veiculoPlaca,
      'descricaoDano': descricaoDano,
      'status': status,
      'dataCriacao': dataCriacao.toIso8601String(),
      'fotos': fotos.map((f) => f.toJson()).toList(),
      'proposta': proposta?.toJson(),
    };
  }
}
