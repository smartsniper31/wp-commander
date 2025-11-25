#!/bin/bash

echo "📦 Creating Final Package for CodeCanyon..."

# Créer le dossier de distribution
mkdir -p dist/wp_commander_package

echo "1. Copying Flutter app..."
cp -r . dist/wp_commander_package/flutter_app/

echo "2. Copying WordPress plugin..."
cp -r wp_plugin/wp-commander dist/wp_commander_package/wordpress_plugin/

echo "3. Copying documentation..."
cp -r documentation/ dist/wp_commander_package/
cp README.md dist/wp_commander_package/

echo "4. Copying marketing assets..."
cp -r marketing/ dist/wp_commander_package/

echo "5. Creating ZIP package..."
cd dist/wp_commander_package
zip -r ../wp_commander_v1.0.0.zip .

echo "✅ Final package created: dist/wp_commander_v1.0.0.zip"

echo ""
echo "📋 Package Contents:"
echo "├── flutter_app/          # Complete Flutter source code"
echo "├── wordpress_plugin/     # WordPress plugin"
echo "├── documentation/        # User and technical docs"
echo "├── marketing/           # Screenshots and descriptions"
echo "└── README.md            # Quick start guide"
