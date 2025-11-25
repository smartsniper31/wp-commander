#!/bin/bash

# Script de build pour la publication
echo "🏗️  Building WP Commander for Release..."

# Nettoyer le projet
flutter clean

# Obtenir les dépendances
flutter pub get

# Générer les mocks pour les tests
flutter pub run build_runner build --delete-conflicting-outputs

# Analyser le code
echo "📋 Running code analysis..."
flutter analyze

# Exécuter les tests
echo "🧪 Running tests..."
flutter test

# Build pour Android
echo "🤖 Building Android release..."
flutter build apk --release

# Build pour iOS (sur Mac seulement)
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "🍏 Building iOS release..."
    flutter build ios --release
fi

echo "✅ Build completed successfully!"
echo "📱 APK: build/app/outputs/flutter-apk/app-release.apk"
