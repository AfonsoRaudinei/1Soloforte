#!/bin/bash

# 🚀 Build Scripts com Environment Variables

echo "📦 SoloForte Build Scripts"
echo ""

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# ==========================================
# DEVELOPMENT
# ==========================================
dev() {
    echo -e "${BLUE}🔧 Building for DEVELOPMENT...${NC}"
    flutter run -d chrome \
        --web-port=5000 \
        --web-renderer html \
        --dart-define=ENV=dev \
        --dart-define=API_KEY=dev_key_12345
}

# ==========================================
# STAGING
# ==========================================
staging() {
    echo -e "${YELLOW}📦 Building for STAGING...${NC}"
    
    # Android
    flutter build apk \
        --dart-define=ENV=staging \
        --dart-define=API_KEY=staging_key_67890 \
        --dart-define=SENTRY_DSN="${SENTRY_DSN_STAGING}"
    
    echo -e "${GREEN}✅ Staging APK built!${NC}"
    echo "📍 Location: build/app/outputs/flutter-apk/app-release.apk"
}

# ==========================================
# PRODUCTION
# ==========================================
production() {
    echo -e "${GREEN}🚀 Building for PRODUCTION...${NC}"
    
    # Validate environment variables
    if [ -z "$API_KEY_PROD" ]; then
        echo "❌ Error: API_KEY_PROD not set"
        exit 1
    fi
    
    if [ -z "$SENTRY_DSN_PROD" ]; then
        echo "⚠️  Warning: SENTRY_DSN_PROD not set"
    fi
    
    # Clean
    flutter clean
    flutter pub get
    
    # Android APK
    echo "📦 Building Android APK..."
    flutter build apk \
        --release \
        --obfuscate \
        --split-debug-info=build/app/outputs/symbols \
        --dart-define=ENV=prod \
        --dart-define=API_KEY="${API_KEY_PROD}" \
        --dart-define=SENTRY_DSN="${SENTRY_DSN_PROD}"
    
    # Android App Bundle
    echo "📦 Building Android App Bundle..."
    flutter build appbundle \
        --release \
        --obfuscate \
        --split-debug-info=build/app/outputs/symbols-bundle \
        --dart-define=ENV=prod \
        --dart-define=API_KEY="${API_KEY_PROD}" \
        --dart-define=SENTRY_DSN="${SENTRY_DSN_PROD}"
    
    echo ""
    echo -e "${GREEN}✅ Production builds completed!${NC}"
    echo "📍 APK: build/app/outputs/flutter-apk/app-release.apk"
    echo "📍 AAB: build/app/outputs/bundle/release/app-release.aab"
    echo "🔐 Symbols: build/app/outputs/symbols"
    echo ""
    echo "⚠️  IMPORTANT: Upload symbols to Sentry!"
}

# ==========================================
# HELP
# ==========================================
help() {
    echo "Usage: ./build.sh [command]"
    echo ""
    echo "Commands:"
    echo "  dev         - Run in development mode"
    echo "  staging     - Build for staging"
    echo "  production  - Build for production (requires env vars)"
    echo "  help        - Show this help"
    echo ""
    echo "Environment Variables (Production):"
    echo "  API_KEY_PROD      - Production API key (required)"
    echo "  SENTRY_DSN_PROD   - Production Sentry DSN (optional)"
    echo ""
    echo "Example:"
    echo "  export API_KEY_PROD='your_prod_key'"
    echo "  export SENTRY_DSN_PROD='https://...@sentry.io/...'"
    echo "  ./build.sh production"
}

# ==========================================
# MAIN
# ==========================================
case "$1" in
    dev)
        dev
        ;;
    staging)
        staging
        ;;
    production|prod)
        production
        ;;
    help|--help|-h)
        help
        ;;
    *)
        echo "❌ Unknown command: $1"
        echo ""
        help
        exit 1
        ;;
esac
