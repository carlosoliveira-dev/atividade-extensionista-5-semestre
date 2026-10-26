# 🚗 IMPACT CAR: Triagem & Avaliação Online
**Atividade Extensionista do 5º Semestre — Gran Faculdade**  
*Curso: Ciência da Computação*

---

## 📋 1. Resumo Executivo e O Conceito de Avaliação Online
O **Impact Car** é uma aplicação *Full-Stack* desenvolvida inteiramente na linguagem **Dart** (Front-end em **Flutter** e Back-end em **Dart Puro**). 

### O que significa "Avaliação Online"?
Diferente dos orçamentos tradicionais (que exigem que o motorista pare seu dia, vá até a oficina e espere o chapeador avaliar o carro em tempo real), o modelo de **Avaliação Online** desconecta o envio da resposta:
- O **cliente** envia as fotos e os dados do dano no momento que for mais conveniente para ele, sem filas ou agendamentos presenciais.
- O **chapeador** analisa as evidências visuais e calcula o orçamento em lote quando seu expediente estiver calmo (ex: ao final do dia), respondendo de forma organizada e sem interrupções indesejadas.

---

## 🎯 2. Alinhamento com os ODS (ONU)
- **ODS 8 (Trabalho Decente e Crescimento Econômico)**: Protege o tempo e o foco do profissional autônomo, eliminando interrupções presenciais.
- **ODS 12 (Consumo e Produção Sustentáveis — Meta 12.5)**: Promoção do "Selo de Oficina Verde" com gestão e descarte consciente de resíduos químicos da funilaria (tintas, solventes e lixas) e incentivo ao reuso e recuperação de peças metálicas em vez de descarte.
- **ODS 13 (Ação Contra a Mudança Global do Clima)**: Evita deslocamentos desnecessários de veículos para simples orçamentos, reduzindo a emissão de CO2.

---

## 🔄 3. Como Funciona (Fluxo de Funcionamento)

### 📱 Fluxo do Cliente (Fricção Zero - Sem Login)
1. O motorista acessa o aplicativo no Android.
2. Preenche dados básicos: **Nome**, **Telefone/WhatsApp**, **Modelo do Veículo**, **Placa** e **Descrição do Dano**.
3. Anexa obrigatoriamente de **3 a 5 fotos** do dano (com compressão local automática).
4. Envia a solicitação de forma instantânea sem precisar criar senhas ou cadastros.

### 💻 Fluxo do Profissional (Painel Administrativo)
1. O chapeador acessa a **Área do Chapeador** com login de **E-mail e Senha**.
2. Visualiza a **Fila de Orçamentos Pendentes** com as miniaturas das fotos enviadas.
3. Toca em qualquer foto para abri-la em **Tela Cheia com Zoom por Pinça (InteractiveViewer)**.
4. Define o **Valor Estimado (R$)** e o **Prazo de Entrega**, integrando automaticamente com o **Google Calendar**.

---

## 🏗️ 4. Arquitetura Técnica & Tecnologias
- **Front-end**: **Flutter** (Mobile Android) — Padrão MVVM, Material Design 3 (M3), Dark Mode e acessibilidade de fontes.
- **Back-end**: **Dart Puro** — Desenvolvido sob os princípios da **Clean Architecture** (Domínio, Casos de Uso e Dados).
- **Banco de Dados**: **PostgreSQL** — Persistência relacional com armazenamento de imagens em Base64 para portabilidade total.

---

## 🚀 5. Conclusão
O Impact Car demonstra a versatilidade do ecossistema **Dart**, unindo alta performance no app móvel e robustez em servidores nativos, entregando uma solução real com impacto social e ambiental positivo.
