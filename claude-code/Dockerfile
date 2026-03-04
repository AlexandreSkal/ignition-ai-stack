###############################################################################
# Claude Code Development Container
# Base: Node 20 (for Claude Code) + Python 3 (for Ignition/MCP scripts)
###############################################################################

FROM node:20-bookworm-slim

# ─── System packages ───
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    curl \
    wget \
    sudo \
    ca-certificates \
    ripgrep \
    fd-find \
    jq \
    tree \
    htop \
    unzip \
    nano \
    python3 \
    python3-pip \
    python3-venv \
    postgresql-client \
    && rm -rf /var/lib/apt/lists/*

# ─── Claude Code CLI ───
RUN npm install -g @anthropic-ai/claude-code

# ─── Python tools for Ignition development ───
RUN python3 -m pip install --break-system-packages \
    httpx \
    python-dotenv \
    pyyaml

# ─── Non-root user ───
ARG USERNAME=node
ARG USER_UID=1000
ARG USER_GID=1000

RUN groupmod --gid $USER_GID $USERNAME \
    && usermod --uid $USER_UID --gid $USER_GID $USERNAME \
    && mkdir -p /home/$USERNAME/.claude \
    && chown -R $USERNAME:$USERNAME /home/$USERNAME

# ─── Passwordless sudo (for installing extra packages on the fly) ───
RUN echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME

USER $USERNAME
WORKDIR /workspace

# ─── Default git config ───
RUN git config --global init.defaultBranch main \
    && git config --global core.editor "nano"

CMD ["sleep", "infinity"]
