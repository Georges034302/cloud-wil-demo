#!/bin/bash

# Load environment variables 
source .env

# 0. Create Resource Group if it doesn't exist
echo "Creating resource group: $RG in $LOCATION..."
az group create \
  --name "$RG" \
  --location "$LOCATION"

# 1. Create App Service Plan (Linux, Free tier)
echo "Creating App Service Plan: $PLAN_NAME in $RG..."
az appservice plan create \
  --name "$PLAN_NAME" \
  --resource-group "$RG" \
  --sku FREE \
  --is-linux

# 2. Create Web App with Python 3.11 runtime
echo "Creating Web App: $APP_NAME in $RG..."
az webapp create \
  --resource-group "$RG" \
  --plan "$PLAN_NAME" \
  --name "$APP_NAME" \
  --runtime "PYTHON|3.11"

# 3. Zip your app (run this inside the joke-api folder)
echo "Zipping app in joke-api/..."
cd joke-api
zip -r ../app.zip .
cd ..

# 4. Deploy the zipped app to Azure App Service
echo "Deploying app.zip to Azure App Service..."
az webapp deploy \
  --resource-group "$RG" \
  --name "$APP_NAME" \
  --src-path app.zip \
  --type zip

# 5. Get the app's default hostname
echo "Fetching app's default hostname..."
APP_URL=$(az webapp show \
  --name "$APP_NAME" \
  --resource-group "$RG" \
  --query defaultHostName \
  --output tsv)

echo "Deployment complete!"
echo "Visit: https://$APP_URL/joke"