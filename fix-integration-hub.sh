#!/bin/bash

# Trengo Frontend - Integration Hub CSS Fix Script
# This script helps locate and fix the mb-6 input alignment issues

set -e

echo "🔍 Trengo Frontend - Integration Hub CSS Fix"
echo "============================================"

# Check if we're in the right directory
if [ ! -d "src" ]; then
    echo "❌ Error: src directory not found. Please run this script from the Trengo frontend root directory."
    exit 1
fi

echo "📍 Current directory: $(pwd)"
echo ""

# Step 1: Find problematic files
echo "🔍 Step 1: Searching for problematic files..."
echo ""

echo "🔎 Looking for Vue files with mb-6 on inputs..."
PROBLEMATIC_FILES=$(grep -r "class.*mb-6.*input\|input.*mb-6\|mb-6.*w-full\|w-full.*mb-6" src/ --include="*.vue" -l 2>/dev/null || true)

if [ -n "$PROBLEMATIC_FILES" ]; then
    echo "📁 Found files with potential mb-6 issues:"
    echo "$PROBLEMATIC_FILES"
else
    echo "✅ No obvious mb-6 + input patterns found"
fi

echo ""

# Step 2: Find integration-related files
echo "🔎 Looking for integration-related Vue files..."
INTEGRATION_FILES=$(find src -name "*.vue" | xargs grep -l "integration\|plugin\|shopify" 2>/dev/null || true)

if [ -n "$INTEGRATION_FILES" ]; then
    echo "📁 Found integration-related files:"
    echo "$INTEGRATION_FILES"
else
    echo "⚠️  No integration-related Vue files found"
fi

echo ""

# Step 3: Find specific webshop domain files
echo "🔎 Looking for webshop domain inputs..."
WEBSHOP_FILES=$(grep -r "webshop.*domain\|shop.*domain\|Your shop domain\|name.*webshop_domain" src/ --include="*.vue" -l 2>/dev/null || true)

if [ -n "$WEBSHOP_FILES" ]; then
    echo "📁 Found webshop domain files:"
    echo "$WEBSHOP_FILES"
    
    echo ""
    echo "📝 Showing webshop domain input patterns:"
    grep -r "webshop.*domain\|shop.*domain\|Your shop domain\|name.*webshop_domain" src/ --include="*.vue" -n 2>/dev/null || true
else
    echo "⚠️  No webshop domain inputs found"
fi

echo ""
echo "============================================"

# Step 4: Check for CSS files to add override
echo "🎨 Step 2: Checking for CSS files..."
CSS_FILES=$(find src -name "*.css" -o -name "main.css" -o -name "app.css" -o -name "styles.css" 2>/dev/null || true)

if [ -n "$CSS_FILES" ]; then
    echo "📁 Found CSS files where you can add the override:"
    echo "$CSS_FILES"
else
    echo "⚠️  No obvious CSS files found. Look for your main stylesheet."
fi

echo ""

# Step 5: Create backup and fix suggestions
echo "🔧 Step 3: Fix recommendations..."
echo ""

if [ -n "$WEBSHOP_FILES" ]; then
    echo "📋 RECOMMENDED ACTIONS:"
    echo ""
    echo "1. 🛡️  BACKUP first:"
    echo "   cp -r src src_backup_$(date +%Y%m%d_%H%M%S)"
    echo ""
    
    echo "2. 🎨 ADD CSS OVERRIDE (immediate fix):"
    echo "   Add to your main CSS file:"
    echo "   /* Integration Hub Input Fix */"
    echo "   input[name=\"webshop_domain\"], input[placeholder*=\"shop domain\"] {"
    echo "     margin-bottom: 0 !important;"
    echo "   }"
    echo ""
    
    echo "3. 🔧 FIX TEMPLATES (for each file):"
    for file in $WEBSHOP_FILES; do
        echo "   📄 $file"
        echo "      - Remove 'mb-6' from input class attribute"
        echo "      - Wrap input in <div class=\"mb-6\">...</div>"
    done
    
    echo ""
    echo "4. ✅ TEST:"
    echo "   - Navigate to app.trengo.com/admin/integrations/plugins/"
    echo "   - Check Shopify integration input alignment"
    echo "   - Verify inputs are vertically centered"
    
else
    echo "🎯 GENERIC RECOMMENDATIONS:"
    echo ""
    echo "1. Search manually for integration hub components"
    echo "2. Look in src/components/integrations/ or similar"
    echo "3. Find inputs with mb-6 classes"
    echo "4. Apply the CSS override as immediate fix"
fi

echo ""
echo "============================================"
echo "📖 For detailed instructions, see:"
echo "   - DIRECT_IMPLEMENTATION_GUIDE.md"
echo "   - trengo-frontend-integration-hub-fix.md"
echo ""
echo "🆘 Need help? Check the fix guides or contact the development team."
echo "============================================"

# Optional: Interactive mode
read -p "🤔 Would you like to create a backup now? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    BACKUP_DIR="src_backup_$(date +%Y%m%d_%H%M%S)"
    echo "📦 Creating backup: $BACKUP_DIR"
    cp -r src "$BACKUP_DIR"
    echo "✅ Backup created successfully!"
    echo "💡 To restore: rm -rf src && mv $BACKUP_DIR src"
else
    echo "⚠️  Skipping backup. Remember to backup before making changes!"
fi

echo ""
echo "🎯 Next steps: Follow the implementation guide to fix the templates."
echo "✨ Good luck with the fix!"