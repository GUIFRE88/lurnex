# Guia de Configuração Passo a Passo

## Passos para Criar o Projeto Rails Dentro do Docker

### Passo 1: Configurar variáveis de ambiente

```bash
cp env.example .env
```

Edite o arquivo `.env` se necessário (por padrão já está configurado).

### Passo 2: Construir a imagem Docker

```bash
make build
```

Ou:

```bash
docker-compose build
```

### Passo 3: Criar o projeto Rails

**IMPORTANTE:** Execute este comando apenas uma vez para criar o projeto Rails:

```bash
docker-compose run --rm web rails new . --database=postgresql --force --skip-bundle
```

Este comando irá:
- Criar a estrutura básica do Rails
- Configurar o PostgreSQL como banco de dados
- Pular a instalação do bundle (faremos isso depois)

**Nota:** O Rails pode perguntar se você quer sobrescrever alguns arquivos. Responda `Y` (Yes) para todos, pois queremos manter nossa configuração Docker.

### Passo 4: Ajustar o Dockerfile (se necessário)

Após criar o projeto Rails, verifique se o `Dockerfile` precisa de ajustes. O Rails pode ter adicionado algumas configurações específicas.

### Passo 5: Configurar o database.yml

Edite o arquivo `config/database.yml` para usar variáveis de ambiente:

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

### Passo 6: Instalar as dependências

```bash
make bundle-install
```

Ou:

```bash
docker-compose run --rm web bundle install
```

### Passo 7: Subir os containers

```bash
make up
```

Ou:

```bash
docker-compose up -d
```

### Passo 8: Criar o banco de dados

```bash
make db-create
```

Ou:

```bash
docker-compose exec web rails db:create
```

### Passo 9: Executar migrações (se houver)

```bash
make db-migrate
```

Ou:

```bash
docker-compose exec web rails db:migrate
```

### Passo 10: Acessar a aplicação

Abra seu navegador e acesse: **http://localhost:3000**

Você deve ver a página inicial do Rails!

## Comandos Rápidos

### Setup completo (após criar o projeto Rails)

```bash
make setup
```

Este comando executa: `build + up + db-create + db-migrate`

### Ver logs

```bash
make logs
```

### Acessar o console do Rails

```bash
make rails-console
```

### Parar os containers

```bash
make down
```

## Próximos Passos

1. Crie seus modelos e migrações
2. Configure suas rotas em `config/routes.rb`
3. Crie seus controllers e views
4. Desenvolva sua aplicação!

## Troubleshooting

### Erro: "Could not find gem 'rails'"

Execute novamente:
```bash
make bundle-install
```

### Erro: "Connection refused" ao criar o banco

Certifique-se de que os containers estão rodando:
```bash
docker-compose ps
```

Se não estiverem, execute:
```bash
make up
```

Aguarde alguns segundos para o PostgreSQL inicializar completamente.

### Erro: Porta 3000 já em uso

Altere a porta no `docker-compose.yml`:
```yaml
ports:
  - "3001:3000"  # Use outra porta
```

### Limpar tudo e começar do zero

```bash
make clean
```

Depois refaça os passos de configuração.
