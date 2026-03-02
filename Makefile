.PHONY: help build up down restart logs shell rails-console db-create db-migrate db-reset db-seed setup clean

help: ## Mostra esta mensagem de ajuda
	@echo "Comandos disponíveis:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

build: ## Constrói as imagens Docker
	docker-compose build

up: ## Inicia os containers em background
	docker-compose up -d

down: ## Para e remove os containers
	docker-compose down

restart: ## Reinicia os containers
	docker-compose restart

logs: ## Mostra os logs dos containers
	docker-compose logs -f

logs-web: ## Mostra apenas os logs do web
	docker-compose logs -f web

logs-db: ## Mostra apenas os logs do banco
	docker-compose logs -f db

shell: ## Acessa o shell do container web
	docker-compose exec web bash

rails-console: ## Abre o console do Rails
	docker-compose exec web rails console

db-create: ## Cria o banco de dados
	docker-compose exec web rails db:create

db-migrate: ## Executa as migrações
	docker-compose exec web rails db:migrate

db-reset: ## Reseta o banco de dados
	docker-compose exec web rails db:reset

db-seed: ## Popula o banco com dados iniciais
	docker-compose exec web rails db:seed

db-rollback: ## Reverte a última migração
	docker-compose exec web rails db:rollback

setup: build up db-create db-migrate ## Configura o projeto completo (build + up + db:create + db:migrate)
	@echo "✅ Projeto configurado com sucesso!"
	@echo "🌐 Acesse: http://localhost:3000"

clean: ## Remove containers, volumes e imagens
	docker-compose down -v --rmi all

test: ## Executa os testes
	docker-compose exec web rails test

bundle-install: ## Instala as gems
	docker-compose exec web bundle install

bundle-update: ## Atualiza as gems
	docker-compose exec web bundle update

generate: ## Gera um novo arquivo (use: make generate ARGS="model User name:string")
	docker-compose exec web rails generate $(ARGS)
