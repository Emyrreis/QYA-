# 📬 Serviço de Notificações — Case 5

> **UniCatólica — Engenharia de Software**  
> Disciplina: Testes e Qualidade de Software

API assíncrona para disparo de notificações por **E-mail** e **SMS**, construída com **FastAPI + Celery + Redis/RabbitMQ**.

---

## Arquitetura

```
FastAPI  ──►  BackgroundTasks / Celery  ──►  Redis/RabbitMQ (Broker)
                                        ──►  Mock Email / Mock SMS
```

| Camada | Tecnologia |
|--------|-----------|
| API | FastAPI + Pydantic v2 |
| Worker | Celery 5 |
| Broker | Redis (dev) / RabbitMQ (prod) |
| Testes | pytest + pytest-cov |
| CI/CD | GitHub Actions |

---

## Como rodar

### Localmente (sem Docker)

```bash
# 1. Criar e ativar ambiente virtual
python -m venv .venv
source .venv/bin/activate  # Linux/Mac
.venv\Scripts\activate     # Windows

# 2. Instalar dependências
pip install -r requirements.txt

# 3. Iniciar a API
uvicorn app.main:app --reload

# 4. Acessar docs interativos
# http://localhost:8000/docs
```

### Com Docker Compose

```bash
docker-compose up --build
```

Serviços disponíveis:
- API: http://localhost:8000/docs
- RabbitMQ UI: http://localhost:15672 (guest/guest)

---

## Endpoints

| Método | Rota | Descrição |
|--------|------|-----------|
| `GET` | `/health` | Health check |
| `POST` | `/notifications/` | Cria e enfileira notificação |
| `GET` | `/notifications/` | Lista todas as notificações |
| `GET` | `/notifications/{id}` | Consulta status por ID |

### Exemplo de requisição

```bash
curl -X POST http://localhost:8000/notifications/ \
  -H "Content-Type: application/json" \
  -d '{
    "event_type": "nova_reserva",
    "recipient": "usuario@email.com",
    "notification_type": "email",
    "message": "Sua reserva foi confirmada!"
  }'
```

---

## Testes

```bash
# Rodar todos os testes com cobertura
pytest

# Apenas unitários
pytest tests/unit/

# Apenas integração
pytest tests/integration/
```

### Estratégia de testes

| Tipo | Descrição |
|------|-----------|
| **Unitários** | Validação de modelos Pydantic, lógica de criação, mocks de envio |
| **Integração** | Endpoints via TestClient (FastAPI) |
| **Quality Gate** | Teste de carga leve — latência média < 500ms |

---

## 📁 Estrutura do projeto

```
notification-service/
├── app/
│   ├── main.py               # Ponto de entrada FastAPI
│   ├── models/
│   │   └── schemas.py        # Modelos Pydantic
│   ├── routers/
│   │   ├── notifications.py  # Endpoints de notificação
│   │   └── health.py         # Health check
│   ├── services/
│   │   └── notification_service.py  # Lógica de negócio + mocks
│   └── workers/
│       └── tasks.py          # Tasks Celery
├── tests/
│   ├── unit/
│   │   └── test_notification_service.py
│   └── integration/
│       └── test_api_endpoints.py
├── .github/workflows/
│   └── ci.yml                # Pipeline GitHub Actions
├── docker-compose.yml
├── Dockerfile
├── requirements.txt
├── pytest.ini
└── README.md
```

---

## ⚙️ Pipeline CI/CD

O pipeline roda automaticamente em `push` para `main` / `develop`:

1. **Testes** — pytest com cobertura mínima de 70%
2. **Quality Gate** — 20 requisições, latência média < 500ms

---

## Riscos & Ética

- Consentimento simulado para envio de mensagens
- Privacidade de números de telefone (não logados)
- Limite de frequência para evitar spam
