import '../../domain/entities/orcamento.dart';
import 'foto_orcamento_model.dart';
import 'proposta_model.dart';

class OrcamentoModel extends Orcamento {
  OrcamentoModel({
    required super.id,
    required super.clienteNome,
    required super.clienteTelefone,
    required super.veiculoModelo,
    required super.veiculoPlaca,
    required super.descricaoDano,
    required super.status,
    required super.dataCriacao,
    super.fotos = const [],
    super.proposta,
  });

  factory OrcamentoModel.fromJson(Map<String, dynamic> json) {
    return OrcamentoModel(
      id: json['id'] as String,
      clienteNome: json['cliente_nome'] as String? ?? json['clienteNome'] as String,
      clienteTelefone: json['cliente_telefone'] as String? ?? json['clienteTelefone'] as String,
      veiculoModelo: json['veiculo_modelo'] as String? ?? json['veiculoModelo'] as String,
      veiculoPlaca: json['veiculo_placa'] as String? ?? json['veiculoPlaca'] as String,
      descricaoDano: json['descricao_dano'] as String? ?? json['descricaoDano'] as String,
      status: StatusOrcamento.values.firstWhere(
        (e) => e.name == (json['status'] as String),
        orElse: () => StatusOrcamento.pendente,
      ),
      dataCriacao: DateTime.parse(json['data_criacao'] as String? ?? json['dataCriacao'] as String),
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
      'status': status.name,
      'dataCriacao': dataCriacao.toIso8601String(),
      'fotos': fotos.map((f) => FotoOrcamentoModel.fromEntity(f).toJson()).toList(),
      'proposta': proposta != null ? PropostaModel.fromEntity(proposta!).toJson() : null,
    };
  }

  factory OrcamentoModel.fromEntity(Orcamento entity) {
    return OrcamentoModel(
      id: entity.id,
      clienteNome: entity.clienteNome,
      clienteTelefone: entity.clienteTelefone,
      veiculoModelo: entity.veiculoModelo,
      veiculoPlaca: entity.veiculoPlaca,
      descricaoDano: entity.descricaoDano,
      status: entity.status,
      dataCriacao: entity.dataCriacao,
      fotos: entity.fotos,
      proposta: entity.proposta,
    );
  }
}
