#!/bin/bash

echo "🧪 Starting Test Suite..."

# Tests unitaires
echo "📋 Running unit tests..."
flutter test test/domain/
flutter test test/data/
flutter test test/presentation/

# Tests d'intégration
echo "🔗 Running integration tests..."
flutter test test/integration/

# Tests de performance
echo "⚡ Running performance tests..."
flutter test test/performance/

# Tests avec coverage
echo "📊 Generating test coverage..."
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html

echo "✅ All tests completed!"
echo "📁 Coverage report: coverage/html/index.html"
