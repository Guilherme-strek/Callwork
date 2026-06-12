# Call Work — Plataforma de serviços locais

Marketplace que conecta microempreendedores, autônomos e freelancers a micro e pequenas empresas.

**Stack**
- **Front-end:** Angular 17 (standalone components, web)
- **Back-end:** Java 17 + Spring Boot 3
- **Banco:** PostgreSQL 16 (migrations com Flyway)

```
callwork/
├── backend/        # API Spring Boot
├── frontend/       # App Angular
└── docker-compose.yml
```

---

## Opção A — Subir tudo com Docker (mais simples)

Pré-requisito: Docker e Docker Compose.

```bash
cd callwork
docker compose up --build
```

Isso sobe o PostgreSQL e a API. A API fica em `http://localhost:8080`.
O Flyway cria o schema e popula os dados de exemplo automaticamente.

Depois, rode o front-end (ver abaixo).

---

## Opção B — Rodar cada parte manualmente

### 1. Banco PostgreSQL

Suba um PostgreSQL local (via Docker, por exemplo):

```bash
docker run --name callwork-db -e POSTGRES_DB=callwork \
  -e POSTGRES_USER=callwork -e POSTGRES_PASSWORD=callwork \
  -p 5432:5432 -d postgres:16-alpine
```

### 2. Back-end (Spring Boot)

Pré-requisitos: JDK 17+ e Maven.

```bash
cd backend
./mvnw spring-boot:run      # ou: mvn spring-boot:run
```

Variáveis de ambiente (têm padrão para desenvolvimento):

| Variável       | Padrão                                         |
|----------------|------------------------------------------------|
| `DB_URL`       | `jdbc:postgresql://localhost:5432/callwork`    |
| `DB_USER`      | `callwork`                                      |
| `DB_PASSWORD`  | `callwork`                                       |
| `CORS_ORIGINS` | `http://localhost:4200`                         |

A API sobe em `http://localhost:8080`. O Flyway aplica as migrations em `src/main/resources/db/migration`.

Testes:

```bash
mvn test
```

### 3. Front-end (Angular)

Pré-requisitos: Node 18+ e npm.

```bash
cd frontend
npm install
npm start            # ng serve em http://localhost:4200
```

Em desenvolvimento, o front usa `http://localhost:8080/api` (ver `src/environments/environment.development.ts`).

---

## Endpoints principais

| Método | Rota                                   | Descrição                                   |
|--------|----------------------------------------|---------------------------------------------|
| GET    | `/api/professionals?q=&category=&meiOnly=` | Busca/lista profissionais (com filtros) |
| GET    | `/api/professionals/{id}`              | Detalhe do profissional (serviços + avaliações) |
| POST   | `/api/professionals`                   | Cadastra um profissional                    |
| POST   | `/api/professionals/{id}/requests`     | Solicita um serviço                         |
| GET    | `/api/professionals/{id}/requests`     | Lista pedidos recebidos (painel)            |
| PATCH  | `/api/requests/{id}/status?value=CONFIRMED` | Aceita/recusa um pedido                |

Exemplo:

```bash
curl "http://localhost:8080/api/professionals?category=Limpeza&meiOnly=true"
```

---

## Telas do front-end

- **Início** (`/`) — landing com proposta e destaques
- **Buscar** (`/buscar`) — filtros por categoria, texto e MEI verificado
- **Perfil** (`/perfil/:id`) — serviços, preços, avaliações e solicitação
- **Painel** (`/painel`) — pedidos recebidos (aceitar/recusar) e métricas
- **Cadastro** (`/cadastro`) — formulário com validação de MEI/CNPJ

---

## Notas de modelagem

- Preços são guardados em **centavos** (`price_cents`) no banco e formatados em reais pela API, evitando erros de ponto flutuante.
- Um profissional com CNPJ preenchido é marcado como **MEI verificado**; sem CNPJ, fica como **autônomo**.
- O schema é gerido **exclusivamente pelo Flyway**; o Hibernate roda em modo `validate`.
