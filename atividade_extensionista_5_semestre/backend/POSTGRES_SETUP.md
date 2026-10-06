# Guia de Configuração do PostgreSQL Local - Impact Car

Este guia descreve como instalar, configurar e criar o banco de dados PostgreSQL localmente para executar o backend em Dart.

---

## 🛠️ Passo 1: Instalar o PostgreSQL e pgAdmin

1. Acesse o site oficial de download do PostgreSQL:
   - [Download PostgreSQL para Windows](https://www.postgresql.org/download/windows/)
2. Baixe o instalador oficial (versão 15 ou superior).
3. Durante a instalação:
   - Mantenha marcadas as opções: **PostgreSQL Server**, **pgAdmin 4** e **Command Line Tools**.
   - Defina uma senha para o usuário padrão `postgres` (Recomendado: `postgrespassword` para compatibilidade com o padrão do projeto).
   - Mantenha a porta padrão `5432`.

---

## 🗄️ Passo 2: Criar o Banco de Dados `impactcar_db`

### Opção A: Pelo pgAdmin 4 (Interface Gráfica)
1. Abra o **pgAdmin 4** instalado no seu computador.
2. Na barra lateral esquerda, clique em **Servers** > insira a senha do usuário `postgres`.
3. Clique com o botão direito sobre **Databases** > **Create** > **Database...**
4. No campo **Database**, digite: `impactcar_db`
5. Clique em **Save**.

---

### Opção B: Pelo Terminal / Prompt de Comando (`psql`)
1. Abra o Prompt de Comando ou PowerShell.
2. Conecte ao PostgreSQL com o usuário padrão:
   ```cmd
   psql -U postgres
   ```
3. Digite a senha cadastrada na instalação.
4. Execute o comando SQL para criar o banco de dados:
   ```sql
   CREATE DATABASE impactcar_db;
   ```
5. Para se conectar ao novo banco de dados:
   ```sql
   \c impactcar_db;
   ```

---

## 📋 Passo 3: Executar o Script para Gerar as Tabelas (`schema.sql`)

### Opção A: Executar no pgAdmin 4
1. No pgAdmin 4, selecione o banco de dados `impactcar_db` recém-criado na árvore à esquerda.
2. Clique no ícone de **Query Tool** (ou pressione `ALT + SHIFT + Q`).
3. Abra ou copie todo o conteúdo do arquivo [backend/schema.sql](file:///C:/Users/trade/AndroidStudioProjects/Atividade%20Extensionista%205%20Semestre/atividade_extensionista_5_semestre/backend/schema.sql):

```sql
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
```
4. Clique no botão **Play / Execute** (F5).
5. As 4 tabelas serão criadas com sucesso!

---

### Opção B: Executar via Terminal (`psql`)
No Prompt de Comando, acesse a pasta `backend` do projeto e execute:
```cmd
psql -U postgres -d impactcar_db -f schema.sql
```

---

## 🚀 Passo 4: Executar o Backend em Dart

1. Certifique-se de que as variáveis de conexão estão corretas no arquivo de ambiente (ou usando os valores padrão abaixo):
   - **DB_HOST**: `localhost`
   - **DB_PORT**: `5432`
   - **DB_NAME**: `impactcar_db`
   - **DB_USER**: `postgres`
   - **DB_PASSWORD**: `postgrespassword` (ou a senha configurada no seu PostgreSQL local)

2. No terminal, navegue até a pasta do backend e execute:
   ```cmd
   cd backend
   dart pub get
   dart run bin/server.dart
   ```

3. O servidor conectará ao PostgreSQL local e exibirá:
   ```text
   ✅ Conectado com sucesso ao PostgreSQL (impactcar_db@localhost:5432)
   Servidor Backend Impact Car iniciado em http://0.0.0.0:8080
   ```
