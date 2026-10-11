# Guia de Deploy - Impact Car (Frontend Android & Backend Ubuntu)

Este documento apresenta o passo a passo completo para realizar o empacotamento do **Frontend Flutter para Android** e a compilação do **Backend Dart para um binário executável nativo no Ubuntu (Linux x64)**.

---

## 📱 PARTE 1: Deploy do Frontend (Flutter / Android)

### 1. Configuração da API de Produção
Antes de gerar a versão de produção, certifique-se de que o aplicativo aponta para o endereço IP ou domínio público onde o seu backend em Dart está hospedado.
- No arquivo de configuração de ambiente (ex: `assets/.env`), ajuste a URL da API:
  ```env
  API_URL=https://api.suaoficina.com
  ```
  *(Nota: O `.env` empacotado no app Flutter deve conter apenas variáveis públicas. Nunca inclua senhas ou segredos de servidor no app).*

### 2. Geração do APK para Testes Finais
Para gerar um APK otimizado e assinado para instalação direta em dispositivos Android:
```bash
flutter build apk --release
```
- **Localização do arquivo gerado**: `build/app/outputs/flutter-apk/app-release.apk`

### 3. Geração do Android App Bundle (.aab) para a Google Play Store
Para publicar o aplicativo oficialmente na **Google Play Store**, a Google exige o formato AAB (*Android App Bundle*):
```bash
flutter build appbundle --release
```
- **Localização do arquivo gerado**: `build/app/outputs/bundle/release/app-release.aab`
- Este arquivo deve ser enviado diretamente ao **Google Play Console** após configurar sua chave de assinatura (*Keystore*).

---

## 💻 PARTE 2: Geração do Executável Nativo do Backend para Ubuntu (Linux x64)

Conforme os Requisitos Não Funcionais do projeto (`RNF03`), o backend em Dart puro é compilado para um binário executável nativo, dispensando a instalação do SDK do Dart no servidor de produção.

### 1. Compilação no Servidor (ou Máquina Linux)
Acesse a pasta do backend no seu servidor Ubuntu (ou máquina Linux de build):
```bash
cd backend
```

Garanta que as dependências estão atualizadas:
```bash
dart pub get
```

Compile o projeto para um binário executável nativo (`server`):
```bash
dart compile exe bin/server.dart -o server
```
- Isso gerará um arquivo executável otimizado chamado `server`.

### 2. Configuração do Banco de Dados e Autenticação
Certifique-se de executar o script [schema.sql](file:///C:/Users/trade/AndroidStudioProjects/Atividade%20Extensionista%205%20Semestre/atividade_extensionista_5_semestre/backend/schema.sql) no seu banco de dados PostgreSQL para criar todas as tabelas necessárias, incluindo a tabela `chapeadores` responsável pela autenticação do painel administrativo.
- Credencial padrão de acesso cadastrada automaticamente pelo script:
  - **E-mail**: `chapeador@impactcar.com`
  - **Senha**: `123456`

Na mesma pasta onde o executável `server` foi gerado no servidor, crie o arquivo `.env` de produção contendo as credenciais reais do PostgreSQL:
```env
PORT=8080
DB_HOST=localhost
DB_PORT=5432
DB_NAME=impact_car_db
DB_USER=postgres
DB_PASSWORD=sua_senha_segura_aqui
```

### 3. Executando o Servidor com Tmux (Gerenciador de Sessões)
Para manter o servidor rodando em segundo plano de forma persistente utilizando o `tmux`:

1. **Criar uma nova sessão no Tmux**:
   ```bash
   tmux new -s impact-car
   ```
2. **Executar o binário do servidor na sessão**:
   ```bash
   ./server
   ```
3. **Desacoplar da sessão (deixando o servidor rodando em background)**:
   - Pressione as teclas `Ctrl + B`, solte, e depois pressione a tecla `D`.
4. **Retornar à sessão do Tmux (para visualizar os logs ou o status do servidor)**:
   ```bash
   tmux attach -t impact-car
   ```
5. **Listar as sessões ativas do Tmux**:
   ```bash
   tmux ls
   ```

---

## 🔒 Resumo de Segurança & Boas Práticas
- **Frontend**: O APK contém apenas assets visuais e a URL pública da API. Nenhuma chave secreta ou credencial de banco de dados fica embutida no aplicativo móvel.
- **Backend**: O binário executável (`server`) roda isolado no Ubuntu, protegido por variáveis de ambiente (`.env`) restritas e conectado ao PostgreSQL local, validando o acesso administrativo dos chapeadores por e-mail e senha.
