# AI Stack — Ignition 8.3 + Claude Code

Complete Docker stack for SCADA/IIoT development with AI assistance.

## Prerequisites

- Docker Desktop (or Docker Engine + Compose)
- Claude Pro subscription (for Claude Code authentication via browser)

## Quick Start

```bash
# 1. Clone or copy this folder to your server
cd ignition-ai-stack

# 2. Configure environment variables
cp .env.example .env
nano .env   # set passwords if you want to change defaults

# 3. Start the stack
docker compose up -d

# 4. Wait for Ignition to initialize (~2 min on first start)
docker compose logs -f ignition   # Ctrl+C when you see "Gateway started"

# 5. Access the Ignition Gateway
# http://localhost:8088

# 6. Enter the Claude Code container
docker compose exec claude bash

# 7. Start Claude Code
claude
# It will show a login URL — open it in your browser
# and authenticate with your Claude Pro account
```

## Services

| Service    | URL/Port                     | Description             |
|------------|------------------------------|-------------------------|
| Ignition   | http://localhost:8088        | Gateway Web UI          |
| Ignition   | https://localhost:8043       | Gateway HTTPS           |
| PostgreSQL | localhost:5432               | Database                |
| Claude     | `docker compose exec claude` | Development container   |

## Project Structure

```
ignition-ai-stack/
│
│  # ─── Infrastructure (stays on host, not inside container) ───
├── docker-compose.yml              # Orchestration of all 3 services
├── .env.example                    # Environment variables template
├── .env                            # Your secrets (do not commit)
├── .gitignore                      # Ignores .env and OS files
├── init-db.sql                     # SQL executed on first Postgres start
├── claude-code/
│   └── Dockerfile                  # Claude Code container image
│
│  # ─── Workspace (mounted as /workspace inside Claude container) ───
└── workspace/
    ├── CLAUDE.md                   # Global context — Claude Code reads this
    ├── .gitignore                  # Project-level ignores
    ├── .claude/
    │   ├── rules/                  # Coding and git conventions
    │   │   ├── coding-standards.md
    │   │   └── git-conventions.md
    │   ├── commands/               # Custom /slash commands (add yours here)
    │   ├── agents/                 # Specialized subagents (add yours here)
    │   └── skills/                 # Skills for Claude Code (add yours here)
    │       ├── ignition-perspective/
    │       └── ignition-scripting/
    └── (your project files go here)
```

### How it maps to the container

| Host path                      | Container path       | Purpose                                    |
|--------------------------------|----------------------|--------------------------------------------|
| `./workspace/`                 | `/workspace`         | Project root — Claude Code works here      |
| `./workspace/CLAUDE.md`        | `/workspace/CLAUDE.md` | Auto-loaded by Claude Code on session start |
| `./workspace/.claude/`         | `/workspace/.claude/`  | Rules, skills, commands, agents            |
| (Docker volume: ignition-data) | `/ignition-data`     | Ignition project JSONs (read-only)         |
| (Docker volume: claude-home)   | `/home/node/.claude`   | Claude Code auth tokens and session data   |

## Useful Commands

```bash
# View logs for all services
docker compose logs -f

# Restart Ignition (without losing data)
docker compose restart ignition

# Enter the Claude Code container
docker compose exec claude bash

# Connect to PostgreSQL
docker compose exec postgres psql -U ignition

# Backup Ignition (via REST API, after setup)
curl -u admin:admin http://localhost:8088/data/api/v1/backup -o backup.gwbk

# Stop everything
docker compose down

# Stop and delete volumes (CAUTION: destroys data)
docker compose down -v
```

## Post-Setup: Configure Ignition

1. Go to http://localhost:8088
2. Complete the initial wizard (user: admin, password: from .env)
3. Go to **Config > Databases > Connections** → add PostgreSQL:
   - JDBC URL: `jdbc:postgresql://postgres:5432/ignition`
   - User: `ignition` / Password: from .env
4. Go to **Config > REST API** → enable and generate an API key
5. Copy the API key to `.env` as `IGNITION_API_KEY`

## Migration to Another Server

```bash
# On current server: export volumes
docker compose down
docker run --rm -v ignition-stack-gateway:/data -v $(pwd):/backup \
  alpine tar czf /backup/ignition-data.tar.gz -C /data .
docker run --rm -v ignition-stack-postgres:/data -v $(pwd):/backup \
  alpine tar czf /backup/postgres-data.tar.gz -C /data .

# Copy to new server: folder + backups
scp -r ignition-ai-stack/ user@new-server:~/
scp *.tar.gz user@new-server:~/ignition-ai-stack/

# On new server: restore
cd ignition-ai-stack
docker compose up -d --no-start
docker run --rm -v ignition-stack-gateway:/data -v $(pwd):/backup \
  alpine sh -c "cd /data && tar xzf /backup/ignition-data.tar.gz"
docker run --rm -v ignition-stack-postgres:/data -v $(pwd):/backup \
  alpine sh -c "cd /data && tar xzf /backup/postgres-data.tar.gz"
docker compose up -d
```

## Next Steps

- [ ] Set up MCP Server (WhiskeyHouse/ignition-mcp) for Claude ↔ Ignition
- [ ] Create specific skills for Perspective, Tags, Named Queries
- [ ] Initialize Git repo inside workspace/
- [ ] Set up CI/CD pipeline
