import '../../domain/entities/chapeador.dart';

class ChapeadorModel extends Chapeador {
  const ChapeadorModel({
    required super.id,
    required super.nome,
    required super.email,
    required super.senha,
  });

  factory ChapeadorModel.fromMap(Map<String, dynamic> map) {
    return ChapeadorModel(
      id: map['id'] as String,
      nome: map['nome'] as String,
      email: map['email'] as String,
      senha: map['senha'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'senha': senha,
    };
  }
}
