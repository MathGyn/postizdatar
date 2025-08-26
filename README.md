# Postiz Self-Hosted Setup

This directory contains the Docker Compose setup for running Postiz self-hosted.

## What is Postiz?

Postiz is an open-source social media scheduling tool that helps you:
- Schedule social media posts and articles
- Generate posts with AI
- Manage multiple social media accounts
- Exchange or buy posts from other members on the marketplace

## Quick Start

1. **Start the services:**
   ```bash
   docker compose up -d
   ```

2. **Check logs if needed:**
   ```bash
   docker compose logs -f postiz
   ```

3. **Access Postiz:**
   Open your browser and go to: http://localhost:5001

4. **Stop the services:**
   ```bash
   docker compose down
   ```

## Configuration

The main configuration is in the `docker-compose.yml` file. Key environment variables:

- `MAIN_URL`: The main URL where Postiz will be accessed
- `FRONTEND_URL`: Frontend URL (usually same as MAIN_URL)
- `NEXT_PUBLIC_BACKEND_URL`: Backend API URL
- `JWT_SECRET`: Secure token for authentication (already set)
- `DISABLE_REGISTRATION`: Set to "true" after first user registration for security

## Security Notes

- The current setup uses `NOT_SECURED=true` for local development
- For production, set up HTTPS and remove the `NOT_SECURED` variable
- Consider changing the default database passwords in production
- After first user registration, set `DISABLE_REGISTRATION=true`

## Accessing from External Network

To access Postiz from other devices on your network:

1. Find your local IP address:
   ```bash
   ipconfig getifaddr en0  # macOS
   ```

2. Update the URLs in `docker-compose.yml`:
   ```yaml
   MAIN_URL: "http://YOUR_LOCAL_IP:5001"
   FRONTEND_URL: "http://YOUR_LOCAL_IP:5001"
   NEXT_PUBLIC_BACKEND_URL: "http://YOUR_LOCAL_IP:5001/api"
   ```

3. Restart the services:
   ```bash
   docker compose down
   docker compose up -d
   ```

## Data Persistence

Data is stored in Docker volumes:
- `postgres-volume`: Database data
- `postiz-redis-data`: Redis cache data
- `postiz-config`: Configuration files
- `postiz-uploads`: Uploaded media files

## Troubleshooting

1. **Check if services are running:**
   ```bash
   docker compose ps
   ```

2. **View logs:**
   ```bash
   docker compose logs postiz
   ```

3. **Restart services:**
   ```bash
   docker compose restart
   ```

4. **Clean restart (removes containers but keeps data):**
   ```bash
   docker compose down
   docker compose up -d
   ```

## Supported Social Media Platforms

Postiz supports many platforms including:
- X (Twitter)
- LinkedIn (Personal & Pages)
- Facebook
- Instagram
- YouTube
- TikTok
- Reddit
- Discord
- Telegram
- Mastodon
- Bluesky
- And more!

Check the documentation for setting up each provider: https://docs.postiz.com/providers
