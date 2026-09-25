FROM python:3.11-slim-bookworm

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PYTHONPATH=/app \
    HOME=/home/user \
    XDG_CACHE_HOME=/home/user/.cache \
    IMAGEIO_FFMPEG_EXE=/usr/bin/ffmpeg

RUN apt-get update \
    && apt-get install -y --no-install-recommends ffmpeg libgomp1 fonts-dejavu-core \
    && rm -rf /var/lib/apt/lists/* \
    && useradd --create-home --uid 1000 user

WORKDIR /app
COPY requirements.txt ./
RUN pip install --no-cache-dir --retries 3 -r requirements.txt
COPY --chown=user:user . .
RUN mkdir -p /app/storage /home/user/.cache \
    && chown user:user /app \
    && chown -R user:user /app/storage /home/user/.cache

USER user
EXPOSE 7860
CMD ["streamlit", "run", "webui/Main.py", "--server.address=0.0.0.0", "--server.port=7860", "--server.headless=true", "--browser.gatherUsageStats=false", "--server.enableCORS=true", "--server.enableXsrfProtection=true", "--client.toolbarMode=minimal"]
