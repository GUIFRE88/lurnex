# Lurnex - Projeto Rails 8 com Docker

Projeto Ruby on Rails 8 dockerizado com PostgreSQL.

## Pré-requisitos

- Docker
- Docker Compose
- Make (opcional, mas recomendado)

## Configuração Inicial

### 1. Configurar variáveis de ambiente

Copie o arquivo `.env.example` para `.env`:

```bash
cp .env.example .env
```

Edite o arquivo `.env` com suas configurações se necessário.

### 2. Criar o projeto Rails dentro do Docker

Execute os seguintes comandos para criar o projeto Rails:

```bash
# Construir a imagem Docker
make build

# Criar o projeto Rails (execute apenas uma vez)
docker-compose run --rm web rails new . --database=postgresql --force --skip-bundle

# Instalar as dependências
make bundle-install

# Ou se preferir usar docker-compose diretamente:
docker-compose run --rm web bundle install
```

**Nota:** O comando `rails new` irá sobrescrever alguns arquivos. Você precisará ajustar o `Dockerfile` e `docker-compose.yml` se necessário após a criação.

### 3. Configurar o banco de dados

Edite o arquivo `config/database.yml` para usar as variáveis de ambiente:

```yaml
default: &default
  adapter: postgresql
  encoding: unicode
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  host: <%= ENV.fetch("DATABASE_HOST") { "localhost" } %>
  username: <%= ENV.fetch("DATABASE_USERNAME") { "postgres" } %>
  password: <%= ENV.fetch("DATABASE_PASSWORD") { "postgres" } %>
  database: <%= ENV.fetch("DATABASE_NAME") { "lurnex_development" } %>

development:
  <<: *default

test:
  <<: *default
  database: <%= ENV.fetch("DATABASE_NAME") { "lurnex_test" } %>

production:
  <<: *default
  database: <%= ENV.fetch("DATABASE_NAME") { "lurnex_production" } %>
```

### 4. Subir o projeto

```bash
# Criar o banco de dados
make db-create

# Executar migrações (se houver)
make db-migrate

# Subir os containers
make up

# Ou usar o setup completo
make setup
```

### 5. Acessar a aplicação

Acesse: http://localhost:3000

## Comandos Úteis

### Makefile

```bash
make help          # Lista todos os comandos disponíveis
make build         # Constrói as imagens Docker
make up            # Inicia os containers
make down          # Para os containers
make restart       # Reinicia os containers
make logs          # Mostra os logs
make logs-web      # Mostra apenas logs do web
make logs-db       # Mostra apenas logs do banco
make shell         # Acessa o shell do container web
make rails-console # Abre o console do Rails
make db-create     # Cria o banco de dados
make db-migrate    # Executa as migrações
make db-reset      # Reseta o banco de dados
make db-seed       # Popula o banco com dados iniciais
make db-rollback   # Reverte a última migração
make setup         # Configura o projeto completo
make clean         # Remove containers, volumes e imagens
make test          # Executa os testes
make bundle-install # Instala as gems
make bundle-update # Atualiza as gems
make generate ARGS="model User name:string" # Gera um novo arquivo
```

### Docker Compose (alternativa ao Makefile)

```bash
docker-compose up -d              # Inicia os containers
docker-compose down                # Para os containers
docker-compose logs -f             # Mostra os logs
docker-compose exec web bash       # Acessa o shell
docker-compose exec web rails console  # Console do Rails
docker-compose exec web rails db:create    # Cria o banco
docker-compose exec web rails db:migrate   # Executa migrações
```

## Estrutura do Projeto

```
lurnex/
├── Dockerfile              # Configuração da imagem Docker
├── docker-compose.yml      # Orquestração dos containers
├── Makefile               # Comandos úteis
├── .dockerignore          # Arquivos ignorados pelo Docker
├── .env.example           # Exemplo de variáveis de ambiente
├── Gemfile                # Dependências Ruby
└── README.md              # Este arquivo
```

## Desenvolvimento

### Acessar o console do Rails

```bash
make rails-console
```

### Criar uma migração

```bash
make generate ARGS="migration CreateUsers name:string email:string"
```

### Executar migrações

```bash
make db-migrate
```

### Executar testes

```bash
make test
```

## Troubleshooting

### Problema: Porta 3000 já está em uso

Altere a porta no `docker-compose.yml`:

```yaml
ports:
  - "3001:3000"  # Altere 3001 para a porta desejada
```

### Problema: Erro de permissão

Se houver problemas de permissão, execute:

```bash
sudo chown -R $USER:$USER .
```

### Limpar tudo e começar do zero

```bash
make clean
```

Depois refaça os passos de configuração inicial.

## Versões

- Ruby: 3.3.0
- Rails: 8.0
- PostgreSQL: 15-alpine
