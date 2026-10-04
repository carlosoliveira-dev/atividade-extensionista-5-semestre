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
