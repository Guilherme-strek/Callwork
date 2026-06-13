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

```python
markdown_content_creative = """# 🚀 CallWork — A Sua Montra Digital de Serviços Autónomos ✨

---

## 📅 1. Cronograma & Metas de Entrega
* **📆 Data Limite de Entrega:** 12/06/2026
* **🎯 Missão Principal:** Apresentar uma solução funcional, testável e robusta do **CallWork**, validando as decisões arquiteturais de design e engenharia através de uma abordagem técnica multidisciplinar integrada! 🔥
* **🎥 Demonstração em Vídeo (4-5 min):** `[Coloque aqui o Link do YouTube/Drive]` 🍿
* **🌐 Web App em Produção:** `[Coloque aqui o Link do Deploy do Front-End]` 🚀

---

## 📱 2. Protótipo Executável & Funcionalidades Centrais

O **CallWork** nasceu para revolucionar a forma como clientes encontram prestadores de serviços de confiança, eliminando intermediários e valorizando o talento local! 🤝

### 🌟 As 3 Funcionalidades Pilares (Implementadas no MVP):
1. **🔐 Autenticação Inteligente & Gestão de Perfis (`AuthController`):** Portais de acesso segregados e seguros para **Clientes** (`CustomerController`) e **Profissionais** (`ProfessionalController`), permitindo uma experiência personalizada desde o primeiro clique.
2. **🔍 Motor de Busca & Filtro Avançado:** Localização em tempo real de prestadores categorizados por especialidade (Eletricistas, Canalizadores, Limpeza) com exibição automática da reputação média de cada um (`ServiceController`, `ReviewRepository`).
3. **📦 Painel Interativo de Pedidos (Service Requests):** Fluxo dinâmico ponta a ponta! O cliente cria o pedido, o profissional recebe o alerta e atualiza os estados (*Pendente ⏳ -> Em Progresso 🛠️ -> Concluído ✅*) em total sincronismo (`ServiceRequestController`).

### 📱 Experiência Mobile-First Responsiva
Esqueça a fricção de downloads pesados nas lojas! O nosso front-end foi esculpido em **Angular** usando os padrões de **Web App Responsivo (PWA)**. 
* 🌍 Adaptação fluida a qualquer tamanho de ecrã (Smartphones, Tablets ou Desktop).
* ⚡ Leve, seguro e pronto para ser encapsulado nativamente via *Capacitor* no futuro.
* 📂 Os ecrãs mobile detalhados podem ser consultados diretamente no ficheiro `/docs/mockup_mobile.html`.

---

## ⚡ 3. Engenharia de Back-end Avançada (Spring Boot)

O motor do CallWork foi desenvolvido sob a arquitetura resiliente do **Spring Boot (Java 17+)** ☕, focado em alta performance e escalabilidade.

* **📡 Endpoints RESTful de Elite:** Comunicação assíncrona ultraveloz utilizando objetos de transferência de dados (**DTOs** JSON), garantindo que dados confidenciais do banco nunca fiquem expostos na rede.
* **🐳 Docker & PostgreSQL:** Infraestrutura moderna e isolada! Com um único comando, o banco de dados relacional robusto **PostgreSQL** é instanciado em contêineres Docker (`docker-compose.yml`).
* **🚀 Controlo de Migrações (Flyway):** O ciclo de vida do banco é versionado de forma profissional! O histórico de evolução estrutural está mapeado nos ficheiros de migração, desde a fundação à gestão financeira (`V1__init.sql` a `V5__customers_and_payment.sql`).
* **🛡️ Escudo Global de Exceções:** Implementámos um interceptor central de erros via `@ControllerAdvice` (`GlobalExceptionHandler`). Caso um recurso suma ou um parâmetro falte, o sistema devolve respostas HTTP limpas e semanticamente perfeitas (ex: `NotFoundException` com status 404).
* **🧪 Testes de Cobertura Blindados:** O ficheiro `CallWorkServiceTest.java` corre de forma automatizada na pipeline para garantir que nenhuma alteração quebre as regras de negócio cruciais.

---

## 🧠 4. Estruturas de Dados, Algoritmos & Análise de Complexidade (Big-O)

Para suportar milhares de acessos em simultâneo sem perder performance, aplicámos conceitos avançados de ciência da computação:

### 📊 Estruturas de Dados Utilizadas
* **`ArrayList`:** Utilizada na camada de serviço para tráfego linear de dados com tempo de leitura ultra-rápido `O(1)`.
* **`HashMap`:** Mapeamento de chave-valor em memória para associações rápidas de sessões e DTOs.
* **Árvores B (B-Trees):** Implementadas implicitamente a nível do PostgreSQL através de índices nas tabelas principais.

### ⚙️ Desempenho Algorítmico (Big-O)

| Operação | Estrutura / Algoritmo | Complexidade de Tempo | Justificação |
| :--- | :--- | :--- | :--- |
| **🔍 Procura de Profissionais** | Índices B-Tree (Base de Dados) | **`O(log N)`** | A busca não percorre a tabela linha a linha; divide o espaço de busca de forma logarítmica. |
| **📐 Ordenação por Avaliação** | *TimSort* (`Collections.sort()`) | **`O(N log N)`** | Algoritmo nativo do Java altamente otimizado que garante estabilidade e rapidez. |

---

## 🚀 5. Manual de Instalação Rápida (Developer Quickstart)

### 🛠️ Pré-requisitos Cósmicos
Certifique-se de que tem instalado na sua máquina:
1. **Docker & Docker Compose** 🐳
2. **Java 17 JDK** ☕
3. **Node.js (v18+) & Angular CLI** 📦

### 🛸 Decolagem em 3 Passos:

**1º Passo: Ligar o Coração dos Dados (PostgreSQL)**

```

```text
README Super Criativo e com Emojis gerado com sucesso!

```bash
docker-compose up -d

```

*✨ O PostgreSQL irá iniciar silenciosamente em background na porta 5432.*

**2º Passo: Disparar os Motores do Back-end (Spring Boot)**

```bash
cd backend
./mvnw clean install
./mvnw spring-boot:run

```

*📡 API online e pronta a receber pedidos em: `http://localhost:8080*`

**3º Passo: Iluminar a Interface (Angular Front-end)**

```bash
cd ../frontend
npm install
ng serve

```

*🎨 Abra as asas e aceda à aplicação mobile/web no seu navegador: `http://localhost:4200*`

---

## 🎨 6. IHC: Interface Humano-Computador & Experiência do Utilizador (UX)

### 📐 Protótipos de Alta Fidelidade (UI)

As nossas interfaces gráficas foram desenhadas meticulosamente para maximizar a conversão. Os ficheiros de design encontram-se na pasta `/docs`:

* 🖥️ `CALL_WORK_mockup_web.pdf` — Visão expandida para computadores.
* 📱 `CALL_WORK_mockup.pdf` & `mockup_mobile.html` — Versão tátil mobile focada em usabilidade com uma mão.

### 👁️ Auditoria Heurística (As Regras de Ouro de Jakob Nielsen)

1. **Visibilidade do Estado do Sistema 🔄:** O utilizador nunca fica às escuras! Adicionámos barras de progresso táteis e notificações flutuantes instantâneas (*Toasts*) a cada alteração de estado dos pedidos.
2. **Prevenção de Erros 🛡️:** Os formulários criados com `ReactiveForms` no Angular validam e-mails, passwords e campos obrigatórios em tempo real, desativando botões de submissão inválidos antes de sobrecarregar o back-end.
3. **Controlo e Liberdade do Utilizador 🔓:** Botões claros para cancelar ou editar solicitações de serviço antes do prestador aceitar o trabalho.

---

## 📈 7. Relatório de Imersão Profissional & Visão de Futuro

### 🔄 Sprint Retrospective (Transparência Radical)

* **🟢 O que correu lindamente:** O alinhamento da equipa com o ambiente Docker baniu o famoso *"na minha máquina funciona"*. A integração entre os modelos do Angular e os endpoints do Spring funcionou como um relógio!
* **🔴 O que falhou / Desafio Superado:** Inicialmente, deparámo-nos com um erro catastrófico de *Recursão Infinita (StackOverflowError)* ao serializar as entidades JPA devido ao relacionamento bidirecional entre Profissionais e Pedidos. **Solução:** Isolámos as entidades de banco de dados e criámos DTOs leves para a camada controller, resolvendo a falha por completo.

### 🗺️ Proposta de Valor Atualizada (Value Proposition Canvas)

> **"Para o Cliente:** Rapidez, preços transparentes e profissionais avaliados à distância de um toque.
> **Para o Prestador:** Autonomia financeira, liberdade de horários e uma montra digital justa que premeia o bom trabalho através de estrelas de reputação real."

### 📋 Roadmap do Produto (Product Backlog Simplificado)

* **🚀 Sprint 1:** Integração com Gateway de Pagamento Seguro (Stripe/Paypal) com retenção de garantia (*Escrow*).
* **💬 Sprint 2:** Chat interno via WebSockets para conversas diretas e partilha de fotografias do problema.
* **📍 Sprint 3:** Sistema de geolocalização por raio de distância usando a API do Google Maps.
* **📦 Sprint 4:** Empacotamento do app via *Capacitor* para publicação direta na Google Play Store e Apple App Store.

---

## 🌍 8. Impacto no Planeta: Contribuição para as ODS da ONU

A nossa tecnologia não serve apenas para gerar linhas de código; ela foi desenhada para criar impacto socioeconómico real, alinhando-se com os **Objetivos de Desenvolvimento Sustentável**:

* **💼 ODS 8 — Trabalho Digno e Crescimento Económico:** O CallWork atua diretamente no combate ao desemprego, dando visibilidade e ferramentas digitais gratuitas para trabalhadores informais e prestadores de serviços autónomos se formalizarem e expandirem o seu portfólio.
* **⚖️ ODS 10 — Redução das Desigualdades:** Democratizámos o mercado de trabalho. No CallWork, o algoritmo de recomendação foca-se exclusivamente na competência técnica (avaliações dadas pelos clientes) e na proximidade, garantindo oportunidades iguais para todos, independentemente do seu background social.

---

### 🛠️ Desenvolvido com muito ☕, 💻 e paixão por engenharia de software!

