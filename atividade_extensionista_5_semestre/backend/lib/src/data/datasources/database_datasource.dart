import 'package:postgres/postgres.dart';
import '../../core/config/database_config.dart';
import '../models/agendamento_model.dart';
import '../models/chapeador_model.dart';
import '../models/foto_orcamento_model.dart';
import '../models/orcamento_model.dart';
import '../models/proposta_model.dart';
import '../../domain/entities/orcamento.dart';
import '../../domain/entities/agendamento.dart';

class DatabaseDatasource {
  Connection? _connection;

  DatabaseDatasource();

  Future<void> inicializar() async {
    final config = DatabaseConfig.carregar();

    try {
      final endpoint = Endpoint(
        host: config.host,
        port: config.port,
        database: config.dbName,
        username: config.user,
        password: config.password,
      );

      _connection = await Connection.open(
        endpoint,
        settings: const ConnectionSettings(
          sslMode: SslMode.disable,
        ),
      );

      print('✅ Conectado com sucesso ao PostgreSQL (${config.dbName}@${config.host}:${config.port})');
    } catch (e) {
      print('❌ FALHA CRÍTICA AO CONECTAR AO POSTGRESQL: $e');
      rethrow;
    }
  }

  Connection get _conn {
    if (_connection == null) {
      throw StateError('Conexão com o PostgreSQL não foi estabelecida.');
    }
    return _connection!;
  }

  Future<OrcamentoModel> salvarOrcamento(OrcamentoModel orcamento) async {
    await _conn.execute(
      Sql.named(
        'INSERT INTO orcamentos (id, cliente_nome, cliente_telefone, veiculo_modelo, veiculo_placa, descricao_dano, status, data_criacao) '
        'VALUES (@id, @nome, @tel, @modelo, @placa, @desc, @status, @data)',
      ),
      parameters: {
        'id': orcamento.id,
        'nome': orcamento.clienteNome,
        'tel': orcamento.clienteTelefone,
        'modelo': orcamento.veiculoModelo,
        'placa': orcamento.veiculoPlaca,
        'desc': orcamento.descricaoDano,
        'status': orcamento.status.name,
        'data': orcamento.dataCriacao,
      },
    );

    for (final foto in orcamento.fotos) {
      await _conn.execute(
        Sql.named(
          'INSERT INTO fotos_orcamentos (id, orcamento_id, caminho_arquivo, url_acesso, ordem_categoria) '
          'VALUES (@id, @orcId, @caminho, @url, @ordem)',
        ),
        parameters: {
          'id': foto.id,
          'orcId': orcamento.id,
          'caminho': foto.caminhoArquivo,
          'url': foto.urlAcesso,
          'ordem': foto.ordemCategoria,
        },
      );
    }
    return orcamento;
  }

  Future<List<OrcamentoModel>> buscarPendentes() async {
    final rows = await _conn.execute(
      Sql.named('SELECT * FROM orcamentos WHERE status = @status ORDER BY data_criacao DESC'),
      parameters: {'status': 'pendente'},
    );

    final List<OrcamentoModel> lista = [];
    for (final row in rows) {
      final map = row.toColumnMap();
      final id = map['id'] as String;

      final fotoRows = await _conn.execute(
        Sql.named('SELECT * FROM fotos_orcamentos WHERE orcamento_id = @orcId'),
        parameters: {'orcId': id},
      );

      final fotos = fotoRows
          .map((fRow) => FotoOrcamentoModel.fromJson(fRow.toColumnMap()))
          .toList();

      final model = OrcamentoModel(
        id: id,
        clienteNome: map['cliente_nome'] as String,
        clienteTelefone: map['cliente_telefone'] as String,
        veiculoModelo: map['veiculo_modelo'] as String,
        veiculoPlaca: map['veiculo_placa'] as String,
        descricaoDano: map['descricao_dano'] as String? ?? '',
        status: StatusOrcamento.pendente,
        dataCriacao: map['data_criacao'] as DateTime,
        fotos: fotos,
      );
      lista.add(model);
    }
    return lista;
  }

  Future<OrcamentoModel?> buscarOrcamentoPorId(String id) async {
    final rows = await _conn.execute(
      Sql.named('SELECT * FROM orcamentos WHERE id = @id'),
      parameters: {'id': id},
    );

    if (rows.isEmpty) return null;
    final map = rows.first.toColumnMap();

    final fotoRows = await _conn.execute(
      Sql.named('SELECT * FROM fotos_orcamentos WHERE orcamento_id = @orcId'),
      parameters: {'orcId': id},
    );

    final fotos = fotoRows
        .map((fRow) => FotoOrcamentoModel.fromJson(fRow.toColumnMap()))
        .toList();

    return OrcamentoModel(
      id: id,
      clienteNome: map['cliente_nome'] as String,
      clienteTelefone: map['cliente_telefone'] as String,
      veiculoModelo: map['veiculo_modelo'] as String,
      veiculoPlaca: map['veiculo_placa'] as String,
      descricaoDano: map['descricao_dano'] as String? ?? '',
      status: StatusOrcamento.values.firstWhere(
        (e) => e.name == (map['status'] as String),
        orElse: () => StatusOrcamento.pendente,
      ),
      dataCriacao: map['data_criacao'] as DateTime,
      fotos: fotos,
    );
  }

  Future<void> atualizarStatusOrcamento(String id, StatusOrcamento novoStatus) async {
    await _conn.execute(
      Sql.named('UPDATE orcamentos SET status = @status WHERE id = @id'),
      parameters: {
        'status': novoStatus.name,
        'id': id,
      },
    );
  }

  Future<PropostaModel> salvarProposta(PropostaModel proposta) async {
    await _conn.execute(
      Sql.named(
        'INSERT INTO propostas (id, orcamento_id, valor_estimado, prazo_entrega, observacoes, data_envio) '
        'VALUES (@id, @orcId, @valor, @prazo, @obs, @data)',
      ),
      parameters: {
        'id': proposta.id,
        'orcId': proposta.orcamentoId,
        'valor': proposta.valorEstimado,
        'prazo': proposta.prazoEntrega,
        'obs': proposta.observacoes,
        'data': proposta.dataEnvio,
      },
    );
    return proposta;
  }

  Future<PropostaModel?> buscarPropostaPorOrcamentoId(String orcamentoId) async {
    final rows = await _conn.execute(
      Sql.named('SELECT * FROM propostas WHERE orcamento_id = @orcId'),
      parameters: {'orcId': orcamentoId},
    );

    if (rows.isEmpty) return null;
    final map = rows.first.toColumnMap();
    final valRaw = map['valor_estimado'];
    final double valor = valRaw is num ? valRaw.toDouble() : double.tryParse(valRaw.toString()) ?? 0.0;

    return PropostaModel(
      id: map['id'] as String,
      orcamentoId: map['orcamento_id'] as String,
      valorEstimado: valor,
      prazoEntrega: map['prazo_entrega'] as String,
      observacoes: map['observacoes'] as String?,
      dataEnvio: map['data_envio'] as DateTime,
    );
  }

  Future<PropostaModel?> buscarPropostaPorId(String propostaId) async {
    final rows = await _conn.execute(
      Sql.named('SELECT * FROM propostas WHERE id = @id'),
      parameters: {'id': propostaId},
    );

    if (rows.isEmpty) return null;
    final map = rows.first.toColumnMap();
    final valRaw = map['valor_estimado'];
    final double valor = valRaw is num ? valRaw.toDouble() : double.tryParse(valRaw.toString()) ?? 0.0;

    return PropostaModel(
      id: map['id'] as String,
      orcamentoId: map['orcamento_id'] as String,
      valorEstimado: valor,
      prazoEntrega: map['prazo_entrega'] as String,
      observacoes: map['observacoes'] as String?,
      dataEnvio: map['data_envio'] as DateTime,
    );
  }

  Future<AgendamentoModel> salvarAgendamento(AgendamentoModel agendamento) async {
    await _conn.execute(
      Sql.named(
        'INSERT INTO agendamentos (id, proposta_id, id_evento_externo, data_horario_marcados, status) '
        'VALUES (@id, @propId, @extId, @data, @status)',
      ),
      parameters: {
        'id': agendamento.id,
        'propId': agendamento.propostaId,
        'extId': agendamento.idEventoExterno,
        'data': agendamento.dataHorarioMarcados,
        'status': agendamento.status.name,
      },
    );
    return agendamento;
  }

  Future<List<AgendamentoModel>> buscarAgendamentos() async {
    final rows = await _conn.execute(Sql.named('SELECT * FROM agendamentos'));
    return rows.map((r) {
      final map = r.toColumnMap();
      return AgendamentoModel(
        id: map['id'] as String,
        propostaId: map['proposta_id'] as String,
        idEventoExterno: map['id_evento_externo'] as String,
        dataHorarioMarcados: map['data_horario_marcados'] as DateTime,
        status: StatusAgendamento.values.firstWhere(
          (e) => e.name == (map['status'] as String),
          orElse: () => StatusAgendamento.confirmado,
        ),
      );
    }).toList();
  }

  Future<ChapeadorModel?> buscarChapeadorPorEmail(String email) async {
    final rows = await _conn.execute(
      Sql.named('SELECT * FROM chapeadores WHERE email = @email'),
      parameters: {'email': email},
    );
    if (rows.isEmpty) return null;
    return ChapeadorModel.fromMap(rows.first.toColumnMap());
  }
}
