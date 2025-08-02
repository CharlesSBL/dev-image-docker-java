# Stage 1: Use the official Eclipse Temurin UBI 9 Minimal image as the base.
FROM eclipse-temurin:21-jdk-ubi9-minimal

# Set environment variables for the container.
# - CODE_SERVER_PORT: Defines the port for code-server.
# - PASSWORD: This will be set at runtime for security.
ENV CODE_SERVER_PORT=8080

# Install essential development tools and dependencies using microdnf.
# - We use -y to auto-confirm the installation.
# - shadow-utils: Provides useradd/groupadd commands.
# - sudo: to allow the non-root user to perform some privileged operations.
# - curl, git: standard dev tools.
# - gnupg2: needed by the code-server install script.
# - maven, gradle: The most common Java build tools.
# - We clean up the cache afterwards to keep the image small.
RUN microdnf install -y \
    shadow-utils \
    sudo \
    curl \
    git \
    gnupg2 \
    maven \
    gradle \
    && microdnf clean all

# Create a non-root user 'coder' for security and better user experience.
# Give this user passwordless sudo privileges.
RUN useradd -m -s /bin/bash coder && \
    echo "coder ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/coder

# Switch to the non-root user.
USER coder
WORKDIR /home/coder

# Download and install code-server using the official install script.
# This script is OS-agnostic and will work on UBI.
# We run this as the 'coder' user; the script will use sudo where needed.
RUN curl -fsSL https://code-server.dev/install.sh | sh

# Install essential VS Code extensions for Java development.
# This makes the environment ready to use out-of-the-box.
RUN code-server --install-extension vscjava.vscode-java-pack && \
    code-server --install-extension vmware.vscode-spring-boot && \
    code-server --install-extension vscjava.vscode-gradle && \
    code-server --install-extension gabrielbb.vscode-lombok && \
    code-server --install-extension eamodio.gitlens

# Create a workspace directory where projects will live.
RUN mkdir -p /home/coder/workspace
WORKDIR /home/coder/workspace

# Expose the port code-server will run on.
EXPOSE ${CODE_SERVER_PORT}

# Define the entrypoint to start code-server.
# - Binds to 0.0.0.0 to be accessible from outside the container.
# - Uses password authentication (password is passed via the PASSWORD env var).
# - Disables telemetry by default.
# - Opens the current working directory (/home/coder/workspace).
ENTRYPOINT ["code-server", "--bind-addr", "0.0.0.0:8080", "--auth", "password", "--disable-telemetry", "."]