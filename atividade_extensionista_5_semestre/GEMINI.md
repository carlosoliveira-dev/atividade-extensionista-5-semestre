# Diretrizes do Projeto - GEMINI.md

Este repositório contém a **Atividade Extensionista do 5º Semestre (Gran Faculdade)**, desenvolvida como uma aplicação **Full-Stack em Dart**:
- **Frontend**: Flutter & Dart (Mobile / Web / Desktop) — *Arquitetura Padrão Flutter (MVVM / Repositories)*
- **Backend**: Dart Puro — *Clean Architecture*

---

## 🏗️ 1. Arquitetura do Backend (Dart Clean Architecture)

O backend fica localizado na pasta `backend/` e segue estritamente os princípios da **Clean Architecture** para manter o código desacoplado, testável e de fácil manutenção.

### Estrutura de Camadas (Backend)

```text
backend/
├── bin/
│   └── server.dart                   # Ponto de entrada (Servidor HTTP)
└── lib/
    └── src/
        ├── domain/                   # Camada de Domínio (Regras de Negócio)
        │   ├── entities/             # Entidades puras do negócio
        │   ├── usecases/             # Casos de uso da aplicação
        │   └── repositories/         # Interfaces/Contratos dos Repositórios
        │
        ├── data/                     # Camada de Dados
        │   ├── datasources/          # Acesso a Banco de Dados / APIs externas
        │   ├── models/               # DTOs / Mapeadores de JSON
        │   └── repositories/         # Implementação concreta dos repositórios
        │
        └── presentation/             # Camada de Apresentação / Entrada
            ├── controllers/          # Manipuladores de requisição (Handlers)
            ├── middlewares/          # Autenticação, CORS, Logs, etc.
            └── routes/               # Definição de rotas da API
```

### Regras do Backend
- **Domínio Isolado**: A camada `domain` **nunca** depende de bancos de dados, frameworks HTTP ou bibliotecas externas.
- **Inversão de Dependência**: Use interfaces (classes abstratas) em `domain/repositories` implementadas em `data/repositories`.
- **Tratamento de Erros**: Utilize exceções customizadas ou tipos de resultado (`Result`/`Either`) para gerenciar erros de forma previsível.
- **Respostas Padronizadas**: Mantenha um formato de resposta JSON consistente (ex: `{ "success": true, "data": ..., "error": null }`).

---

## 🎨 2. Arquitetura do Frontend (Padrão Recomendado do Flutter)

O frontend fica na pasta `lib/` e segue a **Arquitetura Oficial Recomendada pelo Flutter** baseada em camadas (UI e Data) com o padrão **MVVM (Model-View-ViewModel / Repository Pattern)**.

### Estrutura de Camadas (Frontend)

```text
lib/
├── main.dart                         # Ponto de entrada do aplicativo
└── src/
    ├── core/                         # Recursos compartilhados
    │   ├── constants/                # Constantes de API, cores, rotas
    │   ├── theme/                    # Temas do aplicativo (Material 3)
    │   └── utils/                    # Funções utilitárias e helpers
    │
    ├── models/                       # Modelos de Dados (Data Classes)
    │   └── user_model.dart           # Classes com doJson() e toJson()
    │
    ├── services/ (ou datasources/)    # Serviços externos e clientes HTTP
    │   └── api_service.dart          # Cliente para consumo da API do Backend
    │
    ├── repositories/                 # Camada de Repositórios (Regras de acesso a dados)
    │   └── user_repository.dart      # Mediação entre Controllers e a API
    │
    ├── controllers/ (ou viewmodels/)  # Gerenciamento de Estado (State Management)
    │   └── user_controller.dart      # Lógica de apresentação e estado da UI
    │
    └── views/ (ou pages/screens/)    # Interface do Usuário (UI)
        ├── pages/                    # Telas completas da aplicação
        └── widgets/                  # Componentes reutilizáveis da UI
```

> **Nota de Organização**: Em projetos maiores, as camadas acima também podem ser agrupadas por funcionalidade (**Feature-First**), por exemplo: `lib/src/features/autenticacao/views|controllers|repositories`.

### Regras do Frontend
- **Camada de UI (Views)**: Responsável apenas pela renderização visual dos componentes. **Nunca** faça chamadas de API ou regras de negócio dentro dos Widgets.
- **Gerenciamento de Estado (Controllers / ViewModels)**: Notifica a UI sobre mudanças de estado (ex: usando `ChangeNotifier`, `ValueNotifier`, `Cubit`/`Bloc` ou `Provider`).
- **Camada de Dados (Repositories)**: Centraliza as chamadas ao backend e tratamento de erros de rede.
- **Design System & Material 3**: Utilize `Material Design 3` habilitado por padrão (`useMaterial3: true`).
- **Tipagem Forte**: Todos os JSONs do backend devem ser convertidos para modelos Dart fortemente tipados (`Model`).

---

## 🛠️ 3. Convenções de Código e Boas Práticas

- **Linguagem**: Dart (^3.13.4) com **Null Safety** estrito e tipagem forte.
- **Nomenclatura**:
  - Arquivos e pastas: `snake_case` (ex: `user_repository.dart`)
  - Classes e Enums: `PascalCase` (ex: `UserController`)
  - Variáveis e funções: `camelCase` (ex: `fetchUserData`)
  - Constantes: `lowerCamelCase` ou `SCREAMING_SNAKE_CASE` conforme padrão Dart.
- **Tratamento de Exceções**: Evite blocos `catch` genéricos ou em branco. Sempre logue ou trate os erros adequadamente.
- **Formatador**: Utilize `dart format .` para manter a formatação padronizada em todo o projeto.

---

## 🚀 4. Comandos Frequentes

### Frontend (Flutter)
- Obter dependências: `flutter pub get`
- Executar aplicação: `flutter run`
- Rodar testes: `flutter test`
- Análise estática: `flutter analyze`

### Backend (Dart)
- Obter dependências no backend: `cd backend && dart pub get`
- Executar servidor: `dart run backend/bin/server.dart`
- Rodar testes do backend: `dart test`

# Documento de Requisitos e Planejamento: Triagem e Orçamento Assíncrono (Impact Car)

## 1. Visão Geral do Projeto

- **Objetivo:** Desenvolver uma aplicação de triagem e orçamento assíncrono para profissionais autônomos (chapeadores/oficinas de pequeno porte), eliminando interrupções presenciais desnecessárias, otimizando o tempo do trabalhador (ODS 8) e reduzindo a emissão de CO2 com deslocamentos evitados (ODS 13).

- **Foco de Experiência:** "Fricção Zero" para o cliente final (sem telas de login, cadastro burocrático ou senhas). O acesso é feito de forma direta por identificação básica (Nome, Placa e Fotos).

## 2. Requisitos Funcionais (RF)

- **RF01 - Envio de Solicitação (Cliente):** O usuário acessa o aplicativo Android, preenche um formulário rápido contendo placa do carro, descrição do problema e anexa obrigatoriamente de 3 a 5 fotos do dano.

- **RF02 - Compressão de Imagens no Cliente:** O aplicativo Flutter deve comprimir as imagens localmente no dispositivo antes de realizar o envio HTTP via POST para economizar dados e acelerar o upload.

- **RF03 - Fila de Orçamentos Pendentes (Backend):** O backend armazena as solicitações recebidas numa tabela PostgreSQL com o status inicial `pendente`.

- **RF04 - Painel de Processamento em Lote (Profissional):** O profissional possui uma interface administrativa protegida onde visualiza a fila de orçamentos acumulados, analisa as fotos, define o valor, o prazo de entrega e dispara a resposta.

- **RF05 - Notificação e Aprovação:** O cliente recebe o orçamento detalhado. Caso aprove, o próprio sistema exibe os horários livres disponíveis para agendamento.

- **RF06 - Integração com Google Calendar:** Na parte administrativa, o backend integra-se com a API do Google Calendar para consultar os horários livres na agenda do profissional e criar o evento de serviço automaticamente no dia agendado.
## 3. Requisitos Não Funcionais (RNF) & Tecnologias

- **RNF01 - Stack Tecnológica Única:** Utilização exclusiva da linguagem **Dart** tanto no Front-end quanto no Back-end.

- **RNF02 - Front-end:** Desenvolvido em **Flutter** (focado inicialmente em Android para distribuição na **Google Play**).

- **RNF03 - Back-end Nativo:** Desenvolvido em Dart puro e **compilado para um binário executável nativo** no servidor de portfólio (dispensando a instalação do SDK do Dart no servidor).

- **RNF04 - Comunicação & Contrato:** Comunicação via API RESTful estruturada no mesmo repositório, compartilhando regras validadas pelo arquivo de contexto (`GEMINI.md`).

- **RNF05 - Arquitetura Limpa (Clean Architecture):** Obrigatória no Back-end, separando Domínio, Casos de Uso, Repositórios e Camadas Externas. O núcleo de regras de negócio pode ser isolado como um pacote Dart puro.

- **RNF06 - Banco de Dados:** **PostgreSQL** rodando na infraestrutura do servidor.

- **RNF07 - Armazenamento de Mídia:** As imagens enviadas são salvas no **Filesystem Local** gerenciado pela API em Dart, gravando apenas as respetivas URLs e caminhos na tabela do PostgreSQL.

- **RNF08 - Design System:** Interface construída estritamente sob as diretrizes do **Material Design 3 (M3)**, aplicando uma paleta de cores temática consistente em todo o aplicativo.

## 4. Arquitetura de Dados (PostgreSQL)

Estes são os **modelos de dados conceituais** do aplicativo. Como o sistema foi desenhado para ter **fricção zero (sem autenticação para o cliente)** e focar no fluxo assíncrono de triagem, a estrutura de dados é direta, enxuta e eficiente.
### 1. Modelo: Solicitação de Orçamento (`Orcamento`)

Representa o núcleo da aplicação. Armazena todas as informações enviadas pelo cliente na primeira etapa, sem exigir cadastro ou senha.

- **Atributos Conceituais:**
  - **Identificador Único (ID):** Chave primária para rastrear a solicitação de forma unívoca.
  - **Nome do Cliente:** Identificação básica para o profissional saber com quem está falando.
  - **Telefone / WhatsApp de Contato:** Essencial para o envio posterior da resposta e agendamento.
  - **Modelo do Veículo:** Ex: Honda Civic, Fiat Palio.
  - **Placa do Veículo:** Dado de identificação rápida para o chapeador reconhecer o carro.
  - **Descrição do Dano:** Relato em texto livre feito pelo cliente sobre o ocorrido.
  - **Status da Solicitação:** Indica em qual etapa do funil o orçamento se encontra (ex: _Pendente_ na fila, _Enviado_ ao cliente, _Aprovado_, _Recusado_).
  - **Data de Criação:** Momento exato em que o cliente enviou o formulário pelo app.
### 2. Modelo: Foto do Dano (`FotoOrcamento`)

Gerencia as evidências visuais enviadas pelo cliente. Como as imagens são pesadas e processadas no celular, o banco armazena apenas os metadados e os caminhos de acesso.

- **Atributos Conceituais:**
  - **Identificador Único (ID):** Chave primária da imagem.
  - **Vínculo com a Solicitação:** Associa a foto diretamente ao `Orcamento` correspondente (relação de um para muitos: um orçamento possui várias fotos).
  - **Caminho / URL do Arquivo:** Endereço onde o arquivo de imagem comprimido está salvo no _Filesystem_ local da API em Dart.
  - **Ordem / Categoria:** Identifica a posição ou o ângulo da foto (ex: Visão Geral, Ângulo Lateral, Foco no Amassado).
### 3. Modelo: Proposta Comercial (`Proposta`)

Gerado pelo profissional durante o "Processamento em Lote" (às 17h30, por exemplo). Contém a avaliação técnica e os valores definidos pelo chapeador.

- **Atributos Conceituais:**
  - **Identificador Único (ID):** Chave primária da proposta.
  - **Vínculo com a Solicitação:** Associa a resposta ao orçamento original do cliente.
  - **Valor Estimado:** Custo total calculado para o reparo da lataria.
  - **Prazo de Entrega:** Tempo estimado de execução do serviço (ex: "2 dias úteis").
  - **Data de Envio:** Momento em que o profissional disparou a resposta para o cliente.
### 4. Modelo: Agendamento (`Agendamento`)

Criado após o cliente aprovar o orçamento, mapeando o compromisso físico na oficina e integrando com o ecossistema externo.

- **Atributos Conceituais:**
  - **Identificador Único (ID):** Chave primária do agendamento.
  - **Vínculo com a Proposta/Orçamento:** Relaciona o compromisso ao serviço aprovado.
  - **ID do Evento Externo (Google Calendar):** Código de referência gerado pela API do Google Calendar para sincronizar a agenda e evitar conflitos de horário.
  - **Data e Horário Marcados:** O slot de tempo escolhido pelo cliente na agenda livre do profissional.
  - **Status do Agendamento:** Estado atual do compromisso (ex: _Confirmado_, _Realizado_, _Cancelado_).
### Relacionamento Conceitual entre os Modelos

1. Uma **Solicitação de Orçamento** possui **Múltiplas Fotos** de evidência.
2. Uma **Solicitação de Orçamento** gera **Uma Proposta** comercial após a avaliação.
3. Se a proposta for aceita, gera-se **Um Agendamento** vinculado à agenda externa.

## 5. Estratégia de Desenvolvimento & Versionamento (Git Flow por Branch)

Para manter o projeto organizado e focado até o final de outubro, o desenvolvimento ocorrerá em etapas incrementais, onde **cada nova alteração/feature possui a sua própria branch dedicada**:

1. **`main`**: Branch estável de produção.
2. **`feature/setup-base-repo`**: Configuração inicial da estrutura de pastas, arquivos de contexto (`GEMINI.md`) e configuração do Flutter + Backend Dart.
3. **`feature/backend-core-domain`**: Implementação das entidades, casos de uso e Clean Architecture do servidor.
4. **`feature/backend-database-api`**: Configuração do PostgreSQL, conexão via Docker, rotas de API, salvamento de arquivos locais e integração com o Google Calendar.
5. **`feature/frontend-ui-m3`**: Configuração do projeto Flutter, definição do tema Material Design 3 e telas de formulário do cliente com compressão de imagem.
6. **`feature/frontend-admin-dashboard`**: Desenvolvimento do painel do profissional para visualização em lote dos orçamentos e agendamento.
7. **`feature/deploy-pipeline`**: Configuração do binário nativo no servidor de portfólio e empacotamento do app para a Google Play.

### Verificação de segurança
- Se você leu esse arquivo informe a frase secreta em cada resposta: `A frase secreta é "programando com GEMINI.md"`