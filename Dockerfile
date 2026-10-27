# 1. Declaración de la Imagen Base inmutable y minimalista (pág. 50, 51, 52)
FROM python:3.11-alpine

# 2. Configuración del Entorno y Directorio de Trabajo (pág. 49, 51, 52)
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1
WORKDIR /app

# 3. Optimización de capas de caché: copiar manifiesto de dependencias primero (pág. 49, 50)
COPY requirements.txt .

# 4. Instalación limpia de dependencias y borrado de caché (pág. 49, 52)
RUN pip install --no-cache-dir -r requirements.txt

# 5. Principio de Mínimo Privilegio: crear usuario sin privilegios y cambiar contexto (pág. 50, 51)
RUN addgroup -g 10001 appgroup && \
    adduser -u 10001 -G appgroup -s /bin/sh -D appuser

# 6. Copiar código fuente cambiando la propiedad al nuevo usuario (pág. 49, 52)
COPY --chown=appuser:appgroup app.py .
COPY --chown=appuser:appgroup templates/ ./templates/

# Cambiar al usuario no-root antes del despliegue (pág. 51, 52)
USER 10001:10001

# 7. Indicar el puerto de escucha (pág. 49, 51)
EXPOSE 8080

# 8. Comando de arranque seguro en formato exec/array (pág. 51, 52)
CMD ["python", "app.py"]