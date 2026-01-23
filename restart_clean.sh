#!/bin/bash

# Script para limpar cache e reiniciar servidor Flutter Web
# Uso: ./restart_clean.sh

echo "🧹 Limpando cache do Flutter..."
flutter clean

echo "📦 Reinstalando dependências..."
flutter pub get

echo "🔧 Regenerando arquivos SQLite Web Worker..."
dart run sqflite_common_ffi_web:setup --force

echo "✅ Setup completo!"
echo ""
echo "Agora execute:"
echo "  flutter run -d chrome --web-port 55894"
echo ""
echo "E no Chrome:"
echo "  1. Abra DevTools (F12)"
echo "  2. Application → Clear storage → Clear site data"
echo "  3. Recarregue a página (Cmd+Shift+R)"
