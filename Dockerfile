FROM python:3.12

# Install required packages
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        git \
        sudo\
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# Create a non-root user
RUN useradd --create-home appuser \
    && echo "appuser ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/appuser \
    && chmod 0440 /etc/sudoers.d/appuser

# Switch to the non-root user
USER appuser

# Set up work directory
WORKDIR /home/appuser/app

# Install pipx
RUN python3 -m pip install --upgrade pip \
    && python3 -m pip install crewai[tools]

# Set file permissions for the app directory
RUN chmod -R 755 /home/appuser/app

# Switch back to the non-root user
USER appuser

COPY . /home/appuser/app/

# Set the entrypoint
ENTRYPOINT ["/usr/bin/bash"] 
