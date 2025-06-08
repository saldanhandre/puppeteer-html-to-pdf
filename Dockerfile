FROM node:18-slim

# Install system dependencies needed for Chromium
RUN apt-get update && apt-get install -y \
    ca-certificates \
    fonts-liberation \
    libappindicator3-1 \
    libasound2 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libcups2 \
    libdbus-1-3 \
    libgdk-pixbuf2.0-0 \
    libnspr4 \
    libnss3 \
    libx11-xcb1 \
    libxcomposite1 \
    libxdamage1 \
    libxrandr2 \
    wget \
    xdg-utils \
    --no-install-recommends && \
    apt-get clean

# Set working directory
WORKDIR /app

# Copy files
COPY . .

# Disable Chromium download
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true

# Install dependencies
RUN npm install

# Download Chromium manually and install it into Puppeteer's expected location
RUN npx puppeteer install

# Expose the port
EXPOSE 3000

# Start the app
CMD ["node", "index.js"]
