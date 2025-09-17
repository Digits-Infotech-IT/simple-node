# Use the official Node.js image (LTS recommended instead of 21)
FROM node:18

# Set working directory
WORKDIR /usr/src/app

# Ensure the node user owns the app dir
RUN chown -R node:node /usr/src/app

# Switch to the non-root user provided by the image
USER node

# Set a writable npm cache location
RUN mkdir -p /home/node/.npm && npm config set cache /home/node/.npm --global

# Copy package.json and package-lock.json
COPY --chown=node:node package*.json ./

# Install dependencies (no need for chmod, npm does it)
RUN npm install

# Copy the rest of the application code
COPY --chown=node:node . .

# Expose app port
EXPOSE 3000

# Start the app
CMD ["node", "app.js"]
