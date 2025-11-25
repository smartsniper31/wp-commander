#!/bin/bash

echo "⚡ Starting Performance Optimization..."

# Nettoyer le projet
echo "🧹 Cleaning project..."
flutter clean

# Obtenir les dépendances
echo "📦 Getting dependencies..."
flutter pub get

# Analyser le code
echo "🔍 Analyzing code..."
flutter analyze

# Build en mode release pour analyser la taille
echo "🏗️ Building release version..."
flutter build apk --release --analyze-size

# Générer les icôs et splash screens optimisés
echo "🎨 Optimizing assets..."
flutter pub run flutter_launcher_icons:main

# Code splitting et tree shaking
echo "🌳 Running tree shaking..."
flutter build apk --release --shrink

# Générer le rapport de performance
echo "📊 Generating performance report..."
flutter build apk --profile --analyze-size > performance_report.txt

echo "✅ Performance optimization completed!"
echo "📋 Check performance_report.txt for details"