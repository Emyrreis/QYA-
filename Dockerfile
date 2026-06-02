# Imagem enxuta e oficial do Python.
FROM python:3.12-slim

# Boas práticas: não gerar .pyc e não bufferizar logs.
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /code

# Instala dependências primeiro para aproveitar o cache de camadas do Docker.
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copia o restante do código.
COPY . .

EXPOSE 8000

# Sobe a API. Em produção, troque --reload por workers (ex: gunicorn).
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
