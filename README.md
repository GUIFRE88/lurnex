# Lurnex 🚀

Projeto Rails criado para experimentar o ecossistema moderno com **Ruby 4** e **Rails 8** ✨

O objetivo principal deste repositório e validar, na pratica, os recursos nativos mais recentes da stack, reduzindo dependencias externas e aproveitando o que o framework ja oferece por padrao.

## Objetivo do projeto 🎯

- Testar a experiencia de desenvolvimento com Ruby 4 + Rails 8 🧪
- Avaliar recursos nativos de autenticacao e infraestrutura de aplicacao 🛠️
- Servir como base para evolucao de um LMS (Learning Management System) 📚

## Principais inovacoes testadas 🆕

### 1) Authentication (Rails 8) 🔐

Implementacao de autenticacao nativa do Rails, sem Devise, incluindo:

- login/logout;
- recuperacao de senha;
- sessao persistente;
- fluxo de cadastro.

Arquivos principais:

- `app/controllers/concerns/authentication.rb`
- `app/controllers/sessions_controller.rb`
- `app/controllers/passwords_controller.rb`
- `app/models/user.rb`
- `app/models/session.rb`

### 2) Solid Queue 🧵

Fila de jobs nativa baseada em banco de dados, para processamento assincrono sem depender de Redis.

Gem no projeto:

- `solid_queue`

### 3) Solid Cache ⚡

Camada de cache nativa persistida no banco, simplificando setup de cache em ambientes de desenvolvimento e producao.

Gem no projeto:

- `solid_cache`

### 4) Solid Cable 🔌

Backend do Action Cable com persistencia em banco, eliminando necessidade de infraestrutura adicional para WebSockets em cenarios iniciais.

Gem no projeto:

- `solid_cable`

## Stack 🧱

- Ruby 4
- Rails 8.1.x
- PostgreSQL
- Docker / Docker Compose

## Como rodar o projeto ▶️

### 1. Subir os servicos 🐳

```bash
docker compose up -d
```

### 2. Preparar o banco 🗄️

```bash
docker compose run --rm web bin/rails db:prepare
```

### 3. Acessar a aplicacao 🌐

- URL: [http://localhost:3000](http://localhost:3000)

## Rodar testes ✅

```bash
docker compose run --rm web bin/rails test
```

## Observacao 💡

Este repositorio tem foco em aprendizado e validacao tecnica de recursos recentes do Rails.
Conforme o produto evoluir, novos modulos do LMS serao adicionados sobre essa base.
