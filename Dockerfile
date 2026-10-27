
FROM python:3.11.9-slim-bookworm AS builder

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /install

COPY requirements.txt .
RUN pip install --no-cache-dir --prefix=/install/deps -r requirements.txt


FROM python:3.11.9-slim-bookworm AS runner

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

RUN groupadd -g 10001 appgroup && \
    useradd -u 10001 -g appgroup -s /bin/bash -m appuser

WORKDIR /app

COPY --from=builder /install/deps /usr/local

COPY app.py .
COPY templates/ ./templates/

RUN chown -R appuser:appgroup /app

USER 10001:10001

EXPOSE 8080

CMD ["python", "app.py"]