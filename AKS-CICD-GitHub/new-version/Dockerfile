# Use nginx base image version 1.24.0
FROM nginx:1.24.0

# Update and install necessary packages
RUN curl -sL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get update -y \
    && apt-get install -y git curl nodejs \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Hugo 0.124.1 instead of 0.72.0 as weblink is not working
RUN curl -sL https://github.com/gohugoio/hugo/releases/download/v0.124.1/hugo_extended_0.124.1_Linux-64bit.tar.gz | tar -xz hugo && mv hugo /usr/bin && npm i -g postcss-cli autoprefixer postcss

# Clone the GitHub repository for the website
RUN git clone https://github.com/MicrosoftDocs/mslearn-aks-deployment-pipeline-github-actions /contoso-website

# Set working directory
WORKDIR /contoso-website/src

# Update Hugo theme submodule
RUN git submodule update --init themes/introduction

# Generate static website using Hugo and move it to NGINX's HTML directory
RUN hugo && mv public/* /usr/share/nginx/html

# Expose port 80
EXPOSE 80
