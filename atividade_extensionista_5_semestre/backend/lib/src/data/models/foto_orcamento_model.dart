import '../../domain/entities/foto_orcamento.dart';

class FotoOrcamentoModel extends FotoOrcamento {
  FotoOrcamentoModel({
    required super.id,
    required super.orcamentoId,
    required super.caminhoArquivo,
    required super.urlAcesso,
    required super.ordemCategoria,
  });

  factory FotoOrcamentoModel.fromJson(Map<String, dynamic> json) {
    return FotoOrcamentoModel(
      id: json['id'] as String,
      orcamentoId: json['orcamento_id'] as String? ?? json['orcamentoId'] as String,
      caminhoArquivo: json['caminho_arquivo'] as String? ?? json['caminhoArquivo'] as String,
      urlAcesso: json['url_acesso'] as String? ?? json['urlAcesso'] as String,
      ordemCategoria: json['ordem_categoria'] as String? ?? json['ordemCategoria'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orcamentoId': orcamentoId,
      'caminhoArquivo': caminhoArquivo,
      'urlAcesso': urlAcesso,
      'ordemCategoria': ordemCategoria,
    };
  }

  factory FotoOrcamentoModel.fromEntity(FotoOrcamento entity) {
    return FotoOrcamentoModel(
      id: entity.id,
      orcamentoId: entity.orcamentoId,
      caminhoArquivo: entity.caminhoArquivo,
      urlAcesso: entity.urlAcesso,
      ordemCategoria: entity.ordemCategoria,
    );
  }
}
