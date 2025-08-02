# Stage 1: Use the official Eclipse Temurin UBI 9 Minimal image as the base.
FROM eclipse-temurin:21-jdk-ubi9-minimal

# Set environment variables for the container.
ENV CODE_SERVER_PORT=8080
ENV GRADLE_VERSION=8.5

# Install base dependencies using microdnf.
RUN microdnf install -y \
    shadow-utils \
    sudo \
    git \
    gnupg2 \
    maven \
    unzip \
    && microdnf clean all

# --- Manual Gradle Installation ---
RUN set -x && \
    curl -L -o gradle.zip "https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip" && \
    unzip gradle.zip && \
    mv "gradle-${GRADLE_VERSION}" /opt/gradle && \
    ln -s /opt/gradle/bin/gradle /usr/bin/gradle && \
    rm gradle.zip

# Create a non-root user 'coder' for security and better user experience.
RUN useradd -m -s /bin/bash coder && \
    echo "coder ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/coder

# Switch to the non-root user.
USER coder
WORKDIR /home/coder

# Download and install code-server using the official install script.
RUN curl -fsSL https://code-server.dev/install.sh | sh

# Create a workspace directory where projects will live.
RUN mkdir -p /home/coder/workspace
WORKDIR /home/coder/workspace

# Expose the port code-server will run on.
EXPOSE ${CODE_SERVER_PORT}

# Define the entrypoint to start code-server.
ENTRYPOINT ["code-server", "--bind-addr", "0.0.0.0:8080", "--auth", "password", "--disable-telemetry", "."]
