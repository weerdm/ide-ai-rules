# Trengo Frontend - Direct Implementation Guide

## 🎯 Objective
Locate and fix the integration hub input alignment issue where `mb-6` classes on input elements cause unwanted top alignment.

## 🔍 Step 1: Locate the Problematic Files

Run these commands in your Trengo frontend repository root:

```bash
# 1. Find all Vue files with mb-6 on input elements
grep -r "class.*mb-6.*input\|input.*mb-6\|mb-6.*w-full\|w-full.*mb-6" src/ --include="*.vue"

# 2. Find integration-related Vue components
find src -name "*.vue" | xargs grep -l "integration\|plugin\|shopify"

# 3. Find files containing "webshop domain" (from screenshot)
grep -r "webshop.*domain\|shop.*domain\|Your shop domain" src/ --include="*.vue"

# 4. Find files with specific input patterns from screenshot
grep -r "placeholder.*shop domain\|name.*webshop_domain" src/ --include="*.vue"
```

## 🛠️ Step 2: Expected File Locations

Based on typical Vue.js project structure, look in:

```
src/
├── components/
│   ├── integrations/
│   ├── plugins/
│   └── settings/
├── views/
│   ├── integrations/
│   └── admin/
└── pages/
    └── integrations/
```

## 🔧 Step 3: Apply the Fixes

### Current Problematic Pattern (what you'll find):
```vue
<template>
  <input 
    class="mb-6 w-full h-full grow input#url.h-full.grow.w-full"
    name="webshop_domain"
    placeholder="Your shop domain (without https://)."
  />
</template>
```

### Fix Option A: Wrap in Container (Recommended)
```vue
<template>
  <div class="mb-6">
    <input 
      class="w-full h-full grow input#url.h-full.grow.w-full"
      name="webshop_domain"
      placeholder="Your shop domain (without https://)."
    />
  </div>
</template>
```

### Fix Option B: Remove mb-6 and Add to Parent
```vue
<template>
  <!-- If there's a parent form element, add mb-6 there -->
  <div class="form-field mb-6">
    <label>Webshop Domain</label>
    <input 
      class="w-full h-full grow input#url.h-full.grow.w-full"
      name="webshop_domain"
      placeholder="Your shop domain (without https://)."
    />
  </div>
</template>
```

## 📝 Step 4: Specific Search & Replace

### For VSCode/Cursor:

1. **Find Pattern**:
   ```regex
   class="([^"]*\s)?mb-6([^"]*)"([^>]*name="webshop_domain")
   ```

2. **Replace With**:
   ```html
   class="$1$2"$3
   ```

3. **Then wrap the input in a div with mb-6**

### For Command Line:

```bash
# Find files containing the pattern
grep -l 'mb-6.*name="webshop_domain"\|name="webshop_domain".*mb-6' src/**/*.vue

# Use sed to remove mb-6 from input class (backup first!)
sed -i.bak 's/class="\([^"]*\)mb-6\([^"]*\)"/class="\1\2"/g' path/to/file.vue
```

## 🎨 Step 5: Add CSS Override (Immediate Fix)

Add this to your main CSS file (likely `src/assets/main.css` or similar):

```css
/* Integration Hub Input Fix - Remove after template fixes */
.integration-settings input,
.plugin-settings input,
[data-testid*="integration"] input,
input[name="webshop_domain"],
input[placeholder*="shop domain"] {
  margin-bottom: 0 !important;
}

/* Apply spacing to containers */
.integration-settings .form-group,
.plugin-settings .form-group,
.integration-hub .form-field {
  margin-bottom: 1.5rem;
}
```

## 📋 Step 6: Testing Checklist

After making changes:

1. **Navigate to Integration Hub**
   - Go to app.trengo.com/admin/integrations/plugins/
   - Click on any plugin (e.g., Shopify)

2. **Visual Verification**
   - [ ] Input fields are centered vertically
   - [ ] No unwanted top alignment
   - [ ] Proper spacing between form elements
   - [ ] Labels align correctly with inputs

3. **Test Multiple Integrations**
   - [ ] Shopify integration settings
   - [ ] Other plugin configurations
   - [ ] Any custom integrations

## 🔄 Step 7: Rollback Plan

If issues occur, you can quickly rollback:

```bash
# Restore from backup files
find src -name "*.vue.bak" -exec sh -c 'mv "$1" "${1%.bak}"' _ {} \;

# Or remove the CSS override
```

## 📱 Step 8: Cross-Browser Testing

Test in:
- [ ] Chrome/Chromium
- [ ] Firefox
- [ ] Safari
- [ ] Edge

## 🚀 Implementation Priority

1. **Immediate (5 min)**: Add CSS override to main stylesheet
2. **Short-term (1-2 hours)**: Fix Vue component templates
3. **Long-term**: Remove CSS override after template fixes

## 📞 Need Help?

If you encounter issues:

1. **Check Console**: Look for CSS conflicts or JavaScript errors
2. **Inspect Element**: Verify that mb-6 classes are properly removed/overridden
3. **Test Incrementally**: Fix one file at a time to isolate any issues

---

**Expected Files to Modify**: 1-3 Vue components
**Time Investment**: 30 minutes - 2 hours
**Risk Level**: Low (CSS override provides safety net)