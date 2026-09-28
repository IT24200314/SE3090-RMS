# =================================================================================================
# Dockerfile: Python 3.11 LangGraph Multi-Agent Microservice for Cloud Deployment
# =================================================================================================

FROM python:3.11-slim

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy source code
COPY . .

# Environment
ENV PORT=8000
EXPOSE 8000

# Start FastAPI Uvicorn server (adapt to Render's dynamic $PORT)
CMD ["sh", "-c", "uvicorn main:app --host 0.0.0.0 --port ${PORT:-8000}"]
