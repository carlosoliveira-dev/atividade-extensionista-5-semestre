# 🚗 Impact Car — Triagem & Avaliação Online

> **Atividade Extensionista do 5º Semestre — Gran Faculdade**  
> *Ciência da Computação*

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter" />
  <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart" />
  <img src="https://img.shields.io/badge/PostgreSQL-4169E1?style=for-the-badge&logo=postgresql&logoColor=white" alt="PostgreSQL" />
  <img src="https://img.shields.io/badge/Material_Design_3-757575?style=for-the-badge&logo=material-design&logoColor=white" alt="Material Design 3" />
  <img src="https://img.shields.io/badge/Clean_Architecture-222222?style=for-the-badge" alt="Clean Architecture" />
</p>

---

## 📖 Sobre o Projeto

O **Impact Car** é uma aplicação *Full-Stack* desenvolvida inteiramente em **Dart** (Front-end em **Flutter** e Back-end em **Dart puro**) projetada para otimizar o fluxo de triagem e **Avaliação Online** de funilaria e pintura para profissionais autônomos (chapeadores e oficinas de pequeno porte).

O sistema elimina interrupções presenciais desnecessárias no expediente do profissional, permitindo que o cliente envie fotos e descrições do dano veicular de forma flexível, enquanto o chapeador processa as avaliações em lote no final do dia.

---

## 🎯 Alinhamento com os ODS (ONU)

Este projeto apoia diretamente os Objetivos de Desenvolvimento Sustentável da ONU:

- 🟢 **ODS 8 — Trabalho Decente e Crescimento Econômico**: Elimina interrupções no expediente do profissional autônomo, permitindo foco e organização no trabalho.
- ♻️ **ODS 12 — Consumo e Produção Sustentáveis (Meta 12.5)**: Promoção do "Selo de Oficina Verde" com gestão e descarte consciente de resíduos químicos da funilaria (tintas, solventes e lixas) e incentivo à recuperação e reuso de peças.
- 🌍 **ODS 13 — Ação Contra a Mudança Global do Clima**: Reduz significativamente a emissão de CO2 ao evitar deslocamentos desnecessários para orçamentos presenciais.

---

## 🏗️ Arquitetura do Sistema

O repositório é estruturado em uma arquitetura limpa e desacoplada:

```text
atividade_extensionista_5_semestre/
├── backend/                          # 🧠 Back-end (Dart puro - Clean Architecture)
│   ├── bin/server.dart               # Ponto de entrada do Servidor HTTP (Shelf)
│   ├── lib/src/                      # Domínio, Casos de Uso, Datasources, Repositórios
│   └── schema.sql                    # Script PostgreSQL (inclui tabela de chapeadores)
│
└── lib/                              # 📱 Front-end (Flutter & MVVM / Repository)
    ├── src/core/                     # Temas (Material 3), Constantes e Acessibilidade
    ├── src/controllers/              # Gerenciamento de Estado e Autenticação
    ├── src/views/pages/              # Telas (Home, Novo Orçamento, Admin, Sobre, etc.)
    └── main.dart                     # Ponto de entrada do Aplicativo Móvel
```

---

## ✨ Principais Funcionalidades

### 📱 Para o Cliente (Fricção Zero)
- **Sem Cadastro ou Senha**: Acesso direto informando apenas Nome, Telefone, Modelo, Placa e o relato do dano.
- **Compressão de Imagens no Cliente**: Reduz o tamanho das fotos localmente antes do envio HTTP para economizar dados e acelerar a requisição.
- **Interface Inclusiva (Material Design 3)**:
  - Suporte completo a **Modo Escuro (Dark Mode)** com alternância rápida na interface.
  - **Acessibilidade de Fonte**: Painel interativo para aumentar ou diminuir o tamanho dos textos em tempo real.

### 💻 Para o Profissional (Chapeador)
- **Painel Administrativo Protegido**: Login seguro por e-mail e senha (`chapeador@impactcar.com` / `123456`).
- **Fila de Avaliações Pendentes**: Visualização organizada em lote das solicitações enviadas pelos clientes, com miniaturas das fotos.
- **Emissão de Propostas & Agendamento**: Definição de valores e prazos, com sincronização automática na agenda de serviços.

---

## 🚀 Como Executar o Projeto

### Pré-requisitos
- [Flutter SDK](https://docs.flutter.dev/get-started/install) instalado (^3.13.0+)
- [Dart SDK](https://dart.dev/) installed
- [PostgreSQL](https://www.postgresql.org/) (Opcional: o backend possui fallback automático para armazenamento em memória caso o banco não esteja ativo).

### 1. Clonar o Repositório
```bash
git clone https://github.com/seu-usuario/atividade_extensionista_5_semestre.git
cd atividade_extensionista_5_semestre
```

### 2. Executar o Back-end (Dart Server)
```bash
cd backend
dart pub get
dart run bin/server.dart
```
*O servidor estará rodando em `http://localhost:8080` (e acessível via emulador Android em `http://10.0.2.2:8080`).*

### 3. Executando o Front-end (Flutter App)
Em outro terminal, na raiz do projeto:
```bash
flutter pub get
flutter run
```

---

## 📦 Guia de Deploy

Consulte o arquivo [DEPLOY_GUIDE.md](atividade_extensionista_5_semestre/DEPLOY_GUIDE.md) para instruções detalhadas sobre:
- **Geração do APK** (`flutter build apk --release`) e **App Bundle** (`.aab`) para a Google Play Store.
- **Compilação do Backend em Binário Nativo** para servidores Ubuntu (`dart compile exe`) rodando em segundo plano com `tmux`.

---

## 👥 Equipe & Autoria
Desenvolvido como parte da **Atividade Extensionista do 5º Semestre** da **Gran Faculdade**.
