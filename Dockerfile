FROM ghcr.io/void-linux/void-glibc:20261001r1

RUN xbps-install -Suy git uv bash curl iproute2 libxcb \
    tesseract-ocr \
    tesseract-ocr-chi_sim \
    tesseract-ocr-chi_tra \
    tesseract-ocr-eng \
    tesseract-ocr-script-HanS \
    tesseract-ocr-script-HanT \
    && xbps-remove -Oo

COPY requirements.txt .
RUN uv pip install --system --break-system-packages --no-cache-dir -r requirements.txt

WORKDIR /workspace