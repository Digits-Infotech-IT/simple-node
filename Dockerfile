# Use official Node.js LTS image
FROM node:18

# Set working directory
WORKDIR /usr/src/app

# Give ownership of the workdir to the non-root user
RUN chown -R node:node /usr/src/app

# Switch to the non-root user that comes with the image
USER node

# Create a writable npm cache folder
RUN mkdir -p /home/node/.npm \
    && npm config set cache /home/node/.npm

# Copy dependency files first (better caching for builds)
COPY --chown=node:node package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY --chown=node:node . .

# Expose application port
EXPOSE 3000

# Start the application
CMD ["node", "app.js"]
