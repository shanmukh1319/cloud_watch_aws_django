# Use slim Python image
FROM python:3.11-slim-bookworm

# Environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

# Set working directory
WORKDIR /app

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    libpq5 \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements and install
COPY requirements.txt .
RUN pip install -r requirements.txt

# Copy project files
COPY . .

# Create log folder and log files
RUN mkdir -p /var/log/myapp \
    && touch /var/log/myapp/django.log \
    && touch /var/log/myapp/celery-beat.log \
    && touch /var/log/myapp/celery-worker.log \
    && chmod -R 777 /var/log/myapp

# Make entrypoint executable
RUN chmod +x docker/entrypoint-web.sh

# Expose port
EXPOSE 8000

# Default command (can be overridden in docker-compose)
CMD ["gunicorn", "config.wsgi:application", "--bind", "0.0.0.0:8000", "--workers", "1", "--timeout", "120"]