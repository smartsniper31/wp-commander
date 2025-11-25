#!/bin/bash

echo "📸 Generating Marketing Screenshots..."

# Créer le dossier de sortie
mkdir -p marketing/screenshots

echo "1. Dashboard screenshot..."
flutter test integration_test/dashboard_screenshot.dart

echo "2. Site detail screenshot..."  
flutter test integration_test/site_detail_screenshot.dart

echo "3. Add site screenshot..."
flutter test integration_test/add_site_screenshot.dart

echo "4. Health monitor screenshot..."
flutter test integration_test/health_screenshot.dart

echo "✅ Screenshots generated in marketing/screenshots/"