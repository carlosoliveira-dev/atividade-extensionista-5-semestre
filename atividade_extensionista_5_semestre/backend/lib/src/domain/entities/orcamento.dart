import 'foto_orcamento.dart';
import 'proposta.dart';

enum StatusOrcamento {
  pendente,
  enviado,
  aprovado,
  recusado,
}

class Orcamento {
  final String id;
  final String clienteNome;
  final String clienteTelefone;
  final String veiculoModelo;
  final String veiculoPlaca;
  final String descricaoDano;
  final StatusOrcamento status;
  final DateTime dataCriacao;
  final List<FotoOrcamento> fotos;
  final Proposta? proposta;

  Orcamento({
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

  bool get temMinimoFotos => fotos.length >= 3 && fotos.length <= 5;

  Orcamento copyWith({
    String? id,
    String? clienteNome,
    String? clienteTelefone,
    String? veiculoModelo,
    String? veiculoPlaca,
    String? descricaoDano,
    StatusOrcamento? status,
    DateTime? dataCriacao,
    List<FotoOrcamento>? fotos,
    Proposta? proposta,
  }) {
    return Orcamento(
      id: id ?? this.id,
      clienteNome: clienteNome ?? this.clienteNome,
      clienteTelefone: clienteTelefone ?? this.clienteTelefone,
      veiculoModelo: veiculoModelo ?? this.veiculoModelo,
      veiculoPlaca: veiculoPlaca ?? this.veiculoPlaca,
      descricaoDano: descricaoDano ?? this.descricaoDano,
      status: status ?? this.status,
      dataCriacao: dataCriacao ?? this.dataCriacao,
      fotos: fotos ?? this.fotos,
      proposta: proposta ?? this.proposta,
    );
  }
}
