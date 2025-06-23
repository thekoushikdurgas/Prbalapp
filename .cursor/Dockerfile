# Use Ubuntu as base image for Flutter development
FROM ubuntu:22.04

# Avoid prompts from apt
ENV DEBIAN_FRONTEND=noninteractive

# Set up user and working directory as recommended for background agents
RUN useradd -m -s /bin/bash ubuntu
USER ubuntu
WORKDIR /home/ubuntu

# Switch back to root to install packages
USER root

# Update and install essential packages
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    zip \
    libglu1-mesa \
    openjdk-8-jdk \
    wget \
    file \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install Android SDK
ENV ANDROID_SDK_ROOT=/opt/android-sdk
ENV PATH=${PATH}:${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin:${ANDROID_SDK_ROOT}/platform-tools

RUN mkdir -p ${ANDROID_SDK_ROOT}/cmdline-tools && \
    wget -q https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip && \
    unzip commandlinetools-linux-9477386_latest.zip -d ${ANDROID_SDK_ROOT}/cmdline-tools && \
    mv ${ANDROID_SDK_ROOT}/cmdline-tools/cmdline-tools ${ANDROID_SDK_ROOT}/cmdline-tools/latest && \
    rm commandlinetools-linux-9477386_latest.zip

# Accept Android licenses and install SDK packages
RUN yes | sdkmanager --licenses && \
    sdkmanager "platform-tools" "platforms;android-33" "build-tools;33.0.0"

# Install Flutter
ENV FLUTTER_ROOT=/opt/flutter
ENV PATH=${PATH}:${FLUTTER_ROOT}/bin

RUN git clone https://github.com/flutter/flutter.git ${FLUTTER_ROOT} && \
    cd ${FLUTTER_ROOT} && \
    git checkout stable && \
    flutter doctor

# Set proper ownership for the ubuntu user
RUN chown -R ubuntu:ubuntu ${FLUTTER_ROOT} ${ANDROID_SDK_ROOT}

# Switch back to ubuntu user
USER ubuntu

# Set environment variables for Flutter
ENV PATH=${PATH}:${FLUTTER_ROOT}/bin:${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin:${ANDROID_SDK_ROOT}/platform-tools

# Pre-download Flutter dependencies and run doctor
RUN flutter doctor --android-licenses && \
    flutter config --enable-web && \
    flutter config --enable-linux-desktop && \
    flutter config --enable-windows-desktop && \
    flutter config --enable-macos-desktop

# Set working directory to home as recommended
WORKDIR /home/ubuntu

# Note: Code will be cloned by the agent, so we don't copy it here
