#!/bin/bash

RG=lab7-rg
LOCATION=australiaeast
PLAN_NAME=app-service-plan-$RANDOM
APP_NAME=web-app-$RANDOM

echo "Setting environment variables and saving to .env file..."

# Overwrite .env on each execution
cat > .env <<EOF
export RG=$RG
export LOCATION=$LOCATION
export PLAN_NAME=$PLAN_NAME
export APP_NAME=$APP_NAME
EOF

echo "Done! Environment variables written to .env:"
echo "  RG=$RG"
echo "  LOCATION=$LOCATION"
echo "  PLAN_NAME=$PLAN_NAME"
echo "  APP_NAME=$APP_NAME"
echo "Use 'source .env' to load them into your current shell."

# Add .env to .gitignore if not already ignored
if ! grep -qxF '.env' .gitignore; then
  echo ".env" >> .gitignore
  echo "🛡️  .env file added to .gitignore for safety."
else
  echo "✅ .env already in .gitignore"
fi