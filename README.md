# Call Work — Plataforma de serviços locais

Marketplace que conecta microempreendedores, autônomos e freelancers a micro e pequenas empresas.

**Stack**
- **Front-end:** Angular 17 (standalone components)
- **Back-end:** Java 17 + Spring Boot 3
- **Banco:** PostgreSQL 16

```
callwork/
├── backend/        # API Spring Boot
└── frontend/       # App Angular
```

---

## Como rodar

### Pré-requisitos

| Ferramenta | Versão mínima |
|------------|---------------|
| JDK        | 17+           |
| Node / npm | 18+ / 9+      |
| PostgreSQL | 14+           |

### 1. Banco PostgreSQL

Crie o banco uma única vez:

```sql
CREATE DATABASE callwork;
CREATE USER callwork WITH PASSWORD 'callwork';
GRANT ALL PRIVILEGES ON DATABASE callwork TO callwork;
```

> Se preferir mudar usuário/senha, ajuste as variáveis de ambiente abaixo.

### 2. Back-end (Spring Boot)

```bash
cd backend
./mvnw spring-boot:run        # Linux / macOS
mvnw.cmd spring-boot:run      # Windows
```

Na **primeira execução** o Hibernate cria todas as tabelas e os dados de exemplo são inseridos automaticamente.

A API sobe em `http://localhost:8080`.

**Variáveis de ambiente** (os padrões já funcionam com o banco criado acima):

| Variável       | Padrão                                      |
|----------------|---------------------------------------------|
| `DB_URL`       | `jdbc:postgresql://localhost:5432/callwork` |
| `DB_USER`      | `callwork`                                  |
| `DB_PASSWORD`  | `callwork`                                  |
| `CORS_ORIGINS` | `http://localhost:4200`                     |

### 3. Front-end (Angular)

```bash
cd frontend
npm install
npm start
```

Acesse em `http://localhost:4200`.

---

## Endpoints principais

| Método | Rota                                        | Descrição                        |
|--------|---------------------------------------------|----------------------------------|
| GET    | `/api/professionals?q=&category=&meiOnly=`  | Busca/lista profissionais        |
| GET    | `/api/professionals/{id}`                   | Detalhe do profissional          |
| POST   | `/api/professionals`                        | Cadastra um profissional         |
| POST   | `/api/professionals/{id}/requests`          | Solicita um serviço              |
| GET    | `/api/professionals/{id}/requests`          | Lista pedidos recebidos (painel) |
| PATCH  | `/api/requests/{id}/status?value=CONFIRMED` | Aceita/recusa um pedido          |

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
