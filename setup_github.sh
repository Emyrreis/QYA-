#!/bin/bash
# ============================================================
# setup_github.sh
# Cria o repositório no GitHub e faz push do projeto completo
# Pré-requisito: ter o GitHub CLI instalado (https://cli.github.com)
# ============================================================

set -e

REPO_NAME="notification-service-case5"
DESCRIPTION="Case 5 - Serviço de Notificações Email/SMS | FastAPI + Celery + Redis | UniCatólica"

echo "🔐 Verificando autenticação no GitHub CLI..."
if ! gh auth status &>/dev/null; then
  echo "Faça login primeiro:"
  gh auth login
fi

echo ""
echo "📁 Inicializando repositório Git local..."
cd "$(dirname "$0")"
git init
git add .
git commit -m "feat: initial commit - Case 5 Serviço de Notificações

- FastAPI app com endpoints de notificação (email/sms)
- Pydantic v2 para validação de dados
- Celery worker + Redis broker
- 24 testes (unitários e integração) - 100% passando
- Pipeline CI/CD com GitHub Actions
- Docker + docker-compose
- README completo"

echo ""
echo "🚀 Criando repositório no GitHub..."
gh repo create "$REPO_NAME" \
  --description "$DESCRIPTION" \
  --public \
  --source=. \
  --remote=origin \
  --push

echo ""
echo "✅ Repositório criado e código enviado com sucesso!"
echo ""
gh repo view --web
