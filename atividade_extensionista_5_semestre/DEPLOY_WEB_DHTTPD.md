# 🚀 Guia de Deploy: Servindo o Flutter Web com Dart (`dhttpd`)

Este documento detalha o passo a passo para hospedar e servir a versão compilada do **Impact Car Web** utilizando o **`dhttpd`**, o pacote oficial de servidor HTTP estático desenvolvido no ecossistema **Dart**.

---

## 📌 O que é o `dhttpd`?
O `dhttpd` é uma ferramenta leve e oficial em Dart que permite transformar qualquer diretório do seu computador ou servidor em um servidor web estático funcional com um único comando. Por ser nativo do ecossistema Dart, ele se integra perfeitamente a projetos Full-Stack Dart como o Impact Car.

---

## 🛠️ Passo a Passo Completo para o Deploy

### 1. Pré-requisitos no Servidor (Ubuntu / Linux)
Certifique-se de que o **Dart SDK** está instalado na sua máquina virtual ou servidor de hospedagem:
```bash
dart --version
```

### 2. Instalação Global do `dhttpd`
Instale o pacote `dhttpd` globalmente no seu ambiente executando o comando:
```bash
dart pub global activate dhttpd
```
*(Nota: Certifique-se de que o diretório global do Dart/Pub esteja adicionado ao `PATH` do seu sistema para conseguir chamar o comando diretamente).*

### 3. Compilar a Versão Web no Computador de Desenvolvimento
Na raiz do seu projeto Flutter (`atividade_extensionista_5_semestre`), gere a build otimizada de produção para web:
```bash
flutter build web --release
```
Isso criará todos os arquivos estáticos (HTML, JS, assets) dentro da pasta:
`build/web/`

### 4. Enviar os Arquivos para o Servidor
Transfira a pasta `build/web/` (ou apenas o seu conteúdo) para o seu servidor remoto. Por exemplo, colocando em `/var/www/impactcar-web`.

### 5. Iniciar o Servidor com um Único Comando
No servidor, acesse a pasta onde está o conteúdo web e execute:
```bash
dhttpd --path atividade5/atividade_extensionista_5_semestre/build/web/ --host 0.0.0.0 --port 8080
```
---

## 🔄 Mantendo o Servidor Rodando em Segundo Plano (`tmux`)

Como o comando do `dhttpd` ocupa o terminal atual, recomenda-se utilizá-lo dentro de uma sessão **`tmux`** para que ele continue rodando 24/7 mesmo se você fechar o SSH:

1. Criar uma nova sessão tmux para a Web:
   ```bash
   tmux new -s impact-car-web
   ```
2. Executar o servidor estático:
   ```bash
   dhttpd --path /var/www/impactcar-web --port 80
   ```
3. Desacoplar da sessão (deixando rodando em background):
   Pressione `Ctrl + B`, solte e pressione `D`.

Para retornar à sessão e ver os logs:
```bash
tmux attach -t impact-car-web
```

---

## ✅ Vantagens dessa Abordagem
* **100% Dart**: Mantém toda a stack do projeto (Front-end, Back-end e Servidor Web estático) alinhada ao ecossistema Dart.
* **Simplicidade**: Dispensa instalações complexas de servidores robustos como Nginx ou Apache para pequenos projetos ou ambientes acadêmicos.
* **Performance**: Excelente velocidade de entrega de arquivos estáticos gerados pelo Flutter Web.
