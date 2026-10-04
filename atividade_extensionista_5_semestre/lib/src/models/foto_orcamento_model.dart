class FotoOrcamentoModel {
  final String id;
  final String orcamentoId;
  final String caminhoArquivo;
  final String urlAcesso;
  final String ordemCategoria;

  FotoOrcamentoModel({
    required this.id,
    required this.orcamentoId,
    required this.caminhoArquivo,
    required this.urlAcesso,
    required this.ordemCategoria,
  });

  factory FotoOrcamentoModel.fromJson(Map<String, dynamic> json) {
    return FotoOrcamentoModel(
      id: json['id'] as String? ?? '',
      orcamentoId: json['orcamentoId'] as String? ?? '',
      caminhoArquivo: json['caminhoArquivo'] as String? ?? '',
      urlAcesso: json['urlAcesso'] as String? ?? '',
      ordemCategoria: json['ordemCategoria'] as String? ?? 'Geral',
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
}
