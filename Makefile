# Сборка бинарника
.PHONY: build
build:
	@echo "Building application..."
	go build -o bin/api cmd/api/main.go

# Запуск в обычном режиме
.PHONY: run
run:
	@echo "Running application..."
	go run cmd/api/main.go

# Установка зависимостей
.PHONY: deps
deps:
	@echo "Downloading dependencies..."
	go mod download
	go mod tidy

# Запуск линтера
.PHONY: lint
lint:
	@echo "Running linter..."
	golangci-lint run ./...

# Форматирование кода
.PHONY: fmt
fmt:
	@echo "Formatting code..."
	go fmt ./...

# Проверка кода
.PHONY: vet
vet:
	@echo "Running go vet..."
	go vet ./...

# Запуск тестов
.PHONY: test
test:
	@echo "Running tests..."
	go test -v -race -coverprofile=coverage.out ./...
	go tool cover -html=coverage.out -o coverage.html

# Создание .env из примера
.PHONY: init
init:
	@if [ ! -f .env ]; then \
		cp .env.example .env; \
		echo ".env file created. Please update DB_PASSWORD!"; \
	else \
		echo ".env file already exists"; \
	fi

# Jaeger — это система распределенной трассировки
.PHONY: jaeger-up
jaeger-up:
	docker run -d --name jaeger \
		-p 4317:4317 \
		-p 16686:16686 \
		jaegertracing/all-in-one

.PHONY: jaeger-stop
jaeger-stop:
	docker stop jaeger || true

.PHONY: jaeger-rm
jaeger-rm:
	docker rm jaeger || true

.PHONY: jaeger-down
jaeger-down: jaeger-stop jaeger-rm
