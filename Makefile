.PHONY: setup start stop restart logs clean test-log help


GREEN = \033[0;32m
NC = \033[0m

setup: ## Setup ELK Stack directory.
	@echo "$(GREEN)Criando estrutura de diretórios...$(NC)"
	@mkdir -p logstash/config logstash/pipeline
	@cp -n logstash.yml logstash/config/ 2>/dev/null || true
	@cp -n logstash.conf logstash/pipeline/ 2>/dev/null || true
	@echo "$(GREEN)Estrutura criada com sucesso!$(NC)"

start: setup ## Start env
	@echo "$(GREEN)Iniciando ELK Stack...$(NC)"
	docker compose up -d
	@echo "$(GREEN)ELK Stack iniciado com sucesso!$(NC)"
	@echo "$(GREEN)Elasticsearch: http://localhost:9200$(NC)"
	@echo "$(GREEN)Kibana: http://localhost:5601$(NC)"
	@echo "$(GREEN)Logstash HTTP: http://localhost:5000$(NC)"

stop: 
	@echo "$(GREEN)Parando ELK Stack...$(NC)"
	docker compose down
	@echo "$(GREEN)ELK Stack parado com sucesso!$(NC)"

restart: stop start ## 

logs: ## show containers logs
	docker compose logs -f

status: ## show containers status
	docker compose ps

clean: stop ## Remove env
	@echo "$(GREEN)Removendo volumes e dados...$(NC)"
	docker compose down -v
	@echo "$(GREEN)Limpeza concluída com sucesso!$(NC)"

test-log: ## Generate a log event.
	@echo "$(GREEN)Enviando log de teste para o Logstash...$(NC)"
	@curl -X POST -H "Content-Type: application/json" -d '{"timestamp":"'$$(date -u +"%Y-%m-%dT%H:%M:%SZ")'","level":"INFO","message":"Teste de log do frontend","service":"frontend-app","user":"test-user"}' http://localhost:5000
	@echo "\n$(GREEN)Log enviado com sucesso!$(NC)"

help:
	@echo "$(GREEN)Makefile para gerenciamento do ELK Stack$(NC)"
	@echo ""
	@echo "$(GREEN)Comandos disponíveis:$(NC)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

# Default Cmd
.DEFAULT_GOAL := help