# Implementação de Login do Chapeador (Google OAuth 2.0) e Integração Dinâmica com Google Calendar

Este plano detalha a arquitetura e as etapas para adicionar autenticação via Conta Google (Google Sign-In) na área administrativa do chapeador, eliminando a necessidade do arquivo estático `credentials.json`.

## User Review Required

> [!IMPORTANT]
> A introdução do login do chapeador altera o fluxo do painel administrativo, exigindo que o profissional se autentique com sua conta Google na primeira vez que acessar a área restrita.

## Open Questions

- O login deve ser restrito a um e-mail específico do chapeador (ex: `chapeador@impactcar.com`) ou qualquer conta Google pode acessar o painel de testes?

## Proposed Changes

### 1. Frontend (Flutter)
- **[MODIFY] [pubspec.yaml](file:///C:/Users/trade/AndroidStudioProjects/Atividade%20Extensionista%205%20Semestre/atividade_extensionista_5_semestre/pubspec.yaml)**: Adicionar dependência `google_sign_in`.
- **[NEW] [chapeador_login_page.dart](file:///C:/Users/trade/AndroidStudioProjects/Atividade%20Extensionista%205%20Semestre/atividade_extensionista_5_semestre/lib/src/views/pages/chapeador_login_page.dart)**: Tela de login com botão "Entrar com o Google".
- **[MODIFY] [admin_dashboard_page.dart](file:///C:/Users/trade/AndroidStudioProjects/Atividade%20Extensionista%205%20Semestre/atividade_extensionista_5_semestre/lib/src/views/pages/admin_dashboard_page.dart)**: Proteger a rota exigindo o token de autenticação do Google.

### 2. Backend (Dart Clean Architecture)
- **[MODIFY] [backend/lib/src/data/datasources/google_calendar_datasource.dart](file:///C:/Users/trade/AndroidStudioProjects/Atividade%20Extensionista%205%20Semestre/atividade_extensionista_5_semestre/backend/lib/src/data/datasources/google_calendar_datasource.dart)**: Atualizar para aceitar e utilizar o *Access Token* dinâmico do chapeador logado nas chamadas da API do Google Calendar.
- **[NEW] [backend/lib/src/domain/usecases/autenticar_chapeador_usecase.dart](file:///C:/Users/trade/AndroidStudioProjects/Atividade%20Extensionista%205%20Semestre/atividade_extensionista_5_semestre/backend/lib/src/domain/usecases/autenticar_chapeador_usecase.dart)**: Validar o token OAuth recebido do Google.

## Verification Plan

### Automated Tests
- Executar `flutter analyze` e testes unitários do backend para garantir que a estrutura Clean Architecture foi respeitada.

### Manual Verification
- Testar o fluxo de login com conta Google no Flutter.
- Verificar se a listagem de horários e criação de eventos no Google Calendar utilizam o token do usuário logado.
