FROM python:3.11-slim

# Force Python to unbuffer stdout/stderr so logs show up immediately
ENV PYTHONUNBUFFERED=1

# System deps: tesseract for pytesseract OCR, and libs Playwright's Chromium needs
RUN apt-get update && apt-get install -y --no-install-recommends \
    tesseract-ocr \
    wget \
    ca-certificates \
    fonts-liberation \
    libnss3 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libcups2 \
    libdrm2 \
    libgbm1 \
    libasound2 \
    libxkbcommon0 \
    libxcomposite1 \
    libxdamage1 \
    libxfixes3 \
    libxrandr2 \
    libpango-1.0-0 \
    libpangocairo-1.0-0 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Install Playwright's browser binary (chromium only, keep image smaller)
RUN pip install --no-cache-dir playwright && playwright install --with-deps chromium

COPY . .

RUN chmod +x entrypoint.sh

# This is a one-off batch job, not a web server.
# Railway: set Restart Policy = Never, and override the Start Command
# per-deploy if you want to run Amoa.py / Emoa.py instead of Moa.py.
ENTRYPOINT ["./entrypoint.sh"]
CMD ["python", "Moa.py"]
