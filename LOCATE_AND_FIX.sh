#!/bin/bash

# 🔧 Integration Hub CSS Fix Script
# This script locates Vue components with mb-6 input issues and fixes them

set -e  # Exit on any error

echo "🔍 Integration Hub CSS Fix - Automatic Locator and Fixer"
echo "============================================================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if we're in a valid Vue.js project
if [[ ! -f "package.json" ]]; then
    echo -e "${RED}❌ Error: package.json not found. Are you in the root of your frontend project?${NC}"
    exit 1
fi

if ! grep -q "vue" package.json; then
    echo -e "${YELLOW}⚠️  Warning: This doesn't appear to be a Vue.js project${NC}"
    read -p "Continue anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

echo -e "${BLUE}📂 Searching for Vue components...${NC}"

# Find all Vue files
VUE_FILES=$(find . -name "*.vue" -type f | grep -v node_modules | grep -v dist)
TOTAL_FILES=$(echo "$VUE_FILES" | wc -l)

echo -e "${BLUE}Found $TOTAL_FILES Vue files${NC}"

# Step 1: Find files with potential integration hub components
echo -e "\n${BLUE}🎯 Step 1: Locating integration hub components...${NC}"

INTEGRATION_FILES=""

# Search for integration-related patterns
for file in $VUE_FILES; do
    if grep -l -i "webshop_domain\|api_key\|api_secret\|joe shop\|integration.*setting\|plugin.*setting" "$file" 2>/dev/null; then
        INTEGRATION_FILES="$INTEGRATION_FILES $file"
        echo -e "${GREEN}✓ Found integration component: $file${NC}"
    fi
done

if [[ -z "$INTEGRATION_FILES" ]]; then
    echo -e "${YELLOW}⚠️  No integration hub components found. Searching for general mb-6 input issues...${NC}"
    
    # Broader search for mb-6 on inputs
    for file in $VUE_FILES; do
        if grep -l "input.*mb-6\|mb-6.*input" "$file" 2>/dev/null; then
            INTEGRATION_FILES="$INTEGRATION_FILES $file"
            echo -e "${YELLOW}? Found potential issue in: $file${NC}"
        fi
    done
fi

if [[ -z "$INTEGRATION_FILES" ]]; then
    echo -e "${RED}❌ No problematic files found. The issue might already be fixed or files might be in a different location.${NC}"
    exit 0
fi

# Step 2: Analyze the problematic patterns
echo -e "\n${BLUE}🔍 Step 2: Analyzing problematic patterns...${NC}"

BACKUP_DIR="backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

FIXED_FILES=""
PROBLEMATIC_PATTERNS=""

for file in $INTEGRATION_FILES; do
    echo -e "\n${BLUE}Analyzing: $file${NC}"
    
    # Check for problematic patterns
    if grep -n "input.*mb-6\|mb-6.*input" "$file"; then
        PROBLEMATIC_PATTERNS="$PROBLEMATIC_PATTERNS $file"
        echo -e "${RED}❌ Found mb-6 on input elements${NC}"
        
        # Create backup
        cp "$file" "$BACKUP_DIR/$(basename "$file")"
        echo -e "${GREEN}✓ Backup created: $BACKUP_DIR/$(basename "$file")${NC}"
    fi
done

if [[ -z "$PROBLEMATIC_PATTERNS" ]]; then
    echo -e "${GREEN}✅ All files appear to be correctly structured!${NC}"
    rmdir "$BACKUP_DIR" 2>/dev/null || true
    exit 0
fi

# Step 3: Apply fixes
echo -e "\n${BLUE}🔧 Step 3: Applying fixes...${NC}"

read -p "Do you want to automatically fix the issues? (y/N): " -n 1 -r
echo

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${BLUE}💡 Manual fix instructions:${NC}"
    echo
    echo "Find this pattern:"
    echo -e "${RED}<input class=\"mb-6 ...\" name=\"webshop_domain\" />${NC}"
    echo
    echo "Replace with:"
    echo -e "${GREEN}<div class=\"mb-6\">"
    echo "  <input class=\"...\" name=\"webshop_domain\" />"
    echo "</div>${NC}"
    echo
    echo -e "${BLUE}Backup files are saved in: $BACKUP_DIR${NC}"
    exit 0
fi

# Automatic fixing
for file in $PROBLEMATIC_PATTERNS; do
    echo -e "\n${BLUE}Fixing: $file${NC}"
    
    # Create a temporary file for processing
    temp_file=$(mktemp)
    
    # Fix the patterns using sed
    # This regex looks for input tags with mb-6 class and wraps them in divs
    awk '
    BEGIN { in_input = 0; indent = "" }
    /<input[^>]*class="[^"]*mb-6/ {
        # Extract indentation
        match($0, /^[ \t]*/)
        indent = substr($0, RSTART, RLENGTH)
        
        # Remove mb-6 from the input class
        gsub(/mb-6[ ]*/, "", $0)
        gsub(/[ ]*mb-6/, "", $0)
        gsub(/class="[ ]*"/, "", $0)  # Remove empty class attributes
        
        # Print the div wrapper and input
        print indent "<div class=\"mb-6\">"
        print "  " $0
        print indent "</div>"
        next
    }
    { print }
    ' "$file" > "$temp_file"
    
    # Replace the original file
    mv "$temp_file" "$file"
    
    echo -e "${GREEN}✓ Fixed: $file${NC}"
    FIXED_FILES="$FIXED_FILES $file"
done

# Step 4: Add CSS override for immediate relief
echo -e "\n${BLUE}🎨 Step 4: Adding CSS override...${NC}"

CSS_OVERRIDE="
/* INTEGRATION HUB CSS FIX - Added $(date) */
/* Remove after confirming template fixes work */
input[name=\"webshop_domain\"],
input[name=\"api_key\"], 
input[name=\"api_secret\"],
.integration-settings input.mb-6,
.plugin-settings input.mb-6 {
  margin-bottom: 0 !important;
}

.integration-settings .form-group,
.plugin-settings .form-group,
.integration-form > div {
  margin-bottom: 1.5rem;
}
"

# Find main CSS file
MAIN_CSS=""
if [[ -f "src/assets/main.css" ]]; then
    MAIN_CSS="src/assets/main.css"
elif [[ -f "src/styles/main.css" ]]; then
    MAIN_CSS="src/styles/main.css"
elif [[ -f "src/assets/style.css" ]]; then
    MAIN_CSS="src/assets/style.css"
elif [[ -f "src/assets/base.css" ]]; then
    MAIN_CSS="src/assets/base.css"
else
    echo -e "${YELLOW}⚠️  Could not find main CSS file. Please add the CSS override manually.${NC}"
fi

if [[ -n "$MAIN_CSS" ]]; then
    echo "$CSS_OVERRIDE" >> "$MAIN_CSS"
    echo -e "${GREEN}✓ CSS override added to: $MAIN_CSS${NC}"
else
    # Create a temporary CSS file
    echo "$CSS_OVERRIDE" > "integration-hub-fix.css"
    echo -e "${YELLOW}⚠️  Created integration-hub-fix.css - please import this in your main CSS file${NC}"
fi

# Step 5: Summary and next steps
echo -e "\n${GREEN}🎉 Integration Hub CSS Fix Complete!${NC}"
echo "=============================================="
echo
echo -e "${BLUE}📊 Summary:${NC}"
echo "  • Files analyzed: $TOTAL_FILES"
echo "  • Integration components found: $(echo $INTEGRATION_FILES | wc -w)"
echo "  • Files fixed: $(echo $FIXED_FILES | wc -w)"
echo "  • Backups created in: $BACKUP_DIR"
echo
echo -e "${BLUE}✅ What was fixed:${NC}"
for file in $FIXED_FILES; do
    echo "  • $file"
done
echo
echo -e "${BLUE}🧪 Testing Instructions:${NC}"
echo "1. Start your development server: npm run dev"
echo "2. Navigate to your integration hub (usually /admin/integrations)"
echo "3. Open Shopify integration settings"
echo "4. Verify that input fields are now centered"
echo
echo -e "${BLUE}🚀 Deployment:${NC}"
echo "1. Test thoroughly in development"
echo "2. Deploy to staging environment"
echo "3. Test on staging"
echo "4. Deploy to production"
echo "5. Monitor for any issues"
echo
echo -e "${YELLOW}⚠️  Important:${NC}"
echo "• Keep the CSS override until you confirm the template fixes work"
echo "• Test all integration types (not just Shopify)"
echo "• Check responsive behavior on mobile devices"
echo
echo -e "${GREEN}💡 Need to revert? Use the backup files in: $BACKUP_DIR${NC}"

# Optional: Show diff of changes
read -p "Show detailed changes made? (y/N): " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
    for file in $FIXED_FILES; do
        echo -e "\n${BLUE}Changes in $file:${NC}"
        diff -u "$BACKUP_DIR/$(basename "$file")" "$file" || true
    done
fi

echo -e "\n${GREEN}🔧 Fix complete! Happy coding! 🚀${NC}"