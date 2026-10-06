-- Script SQL de Criação do Banco de Dados PostgreSQL - Impact Car

-- 1. Tabela: orcamentos
CREATE TABLE IF NOT EXISTS orcamentos (
    id VARCHAR(50) PRIMARY KEY,
    cliente_nome VARCHAR(100) NOT NULL,
    cliente_telefone VARCHAR(20) NOT NULL,
    veiculo_modelo VARCHAR(100) NOT NULL,
    veiculo_placa VARCHAR(10) NOT NULL,
    descricao_dano TEXT,
    status VARCHAR(20) NOT NULL DEFAULT 'pendente',
    data_criacao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 2. Tabela: fotos_orcamentos
CREATE TABLE IF NOT EXISTS fotos_orcamentos (
    id VARCHAR(50) PRIMARY KEY,
    orcamento_id VARCHAR(50) NOT NULL REFERENCES orcamentos(id) ON DELETE CASCADE,
    caminho_arquivo TEXT NOT NULL,
    url_acesso TEXT NOT NULL,
    ordem_categoria VARCHAR(50) NOT NULL
);

-- 3. Tabela: propostas
CREATE TABLE IF NOT EXISTS propostas (
    id VARCHAR(50) PRIMARY KEY,
    orcamento_id VARCHAR(50) NOT NULL REFERENCES orcamentos(id) ON DELETE CASCADE,
    valor_estimado NUMERIC(10, 2) NOT NULL,
    prazo_entrega VARCHAR(50) NOT NULL,
    observacoes TEXT,
    data_envio TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 4. Tabela: agendamentos
CREATE TABLE IF NOT EXISTS agendamentos (
    id VARCHAR(50) PRIMARY KEY,
    proposta_id VARCHAR(50) NOT NULL REFERENCES propostas(id) ON DELETE CASCADE,
    id_evento_externo VARCHAR(100) NOT NULL,
    data_horario_marcados TIMESTAMP NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'confirmado'
);
