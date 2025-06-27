# Trengo Frontend - Integration Hub CSS Fix

## 🚨 Issue
Integration hub input elements have `mb-6` classes causing unwanted 24px bottom margin, making inputs align to the top instead of being properly centered.

**Affected Area**: Integration Hub → Plugin Settings (e.g., Shopify integration)
**Visual Problem**: Input fields appear aligned to top of container instead of center

## 🎯 Target Files (Likely Locations)

Based on the screenshots, search for these patterns in the Trengo frontend:

```bash
# Search for integration hub related files
find src -name "*integration*" -type f
find src -name "*plugin*" -type f
find src -name "*shopify*" -type f

# Search for the specific input with mb-6
grep -r "mb-6.*input\|input.*mb-6" src/
grep -r "webshop.*domain\|shop.*domain" src/
```

## 🔧 Immediate CSS Fix

Add this CSS to your main stylesheet or create a specific integration hub CSS file:

```css
/* Integration Hub Input Fix */
.integration-settings input,
.plugin-settings input,
[data-testid*="integration"] input,
.integration-hub input {
  margin-bottom: 0 !important;
}

/* Apply proper spacing to form groups instead */
.integration-settings .form-group,
.plugin-settings .form-group,
.integration-hub .form-field {
  margin-bottom: 1.5rem;
}

.integration-settings .form-group:last-child,
.plugin-settings .form-group:last-child,
.integration-hub .form-field:last-child {
  margin-bottom: 0;
}

/* Specific fix for webshop domain input */
input[name="webshop_domain"],
input[placeholder*="shop domain"] {
  margin-bottom: 0 !important;
}
```

## 📝 Template Fixes

### Current Problematic Pattern (likely in Vue components):
```vue
<template>
  <!-- PROBLEMATIC: Direct margin on input -->
  <input 
    class="mb-6 w-full h-full grow w-full mb-6"
    name="webshop_domain"
    placeholder="Your shop domain ..."
  />
</template>
```

### Fixed Pattern:
```vue
<template>
  <!-- FIXED: Margin on container -->
  <div class="mb-6">
    <input 
      class="w-full h-full grow input#url.h-full.grow.w-full"
      name="webshop_domain"
      placeholder="Your shop domain ..."
    />
  </div>
</template>
```

## 🔍 Specific Files to Check

Look for these likely file patterns in your Vue components:

1. **Integration Settings Components**:
   - `src/components/integrations/**/*.vue`
   - `src/views/integrations/**/*.vue`
   - `src/pages/integrations/**/*.vue`

2. **Plugin Configuration Components**:
   - `src/components/plugins/**/*.vue`
   - `src/views/plugins/**/*.vue`

3. **Shopify Specific Components**:
   - `**/shopify/**/*.vue`
   - `**/*shopify*.vue`

## 🛠️ Search & Replace Commands

Use these commands in your IDE or terminal:

```bash
# Find files with the problematic pattern
grep -r "class.*mb-6.*input\|input.*mb-6" src/ --include="*.vue"

# Find webshop domain inputs specifically
grep -r 'name="webshop_domain"' src/ --include="*.vue"

# Find integration-related Vue files
find src -name "*.vue" | xargs grep -l "integration\|plugin\|shopify" 
```

## 📋 Implementation Steps

1. **Identify the specific Vue component** containing the integration hub form
2. **Locate the input element** with `mb-6` class
3. **Apply one of these solutions**:

### Option A: Remove mb-6 from input class
```vue
<!-- Before -->
<input class="mb-6 w-full border rounded" />

<!-- After -->
<input class="w-full border rounded" />
```

### Option B: Wrap in container with spacing
```vue
<!-- Before -->
<input class="mb-6 w-full border rounded" />

<!-- After -->
<div class="mb-6">
  <input class="w-full border rounded" />
</div>
```

### Option C: Add CSS override (quick fix)
```css
/* Add to your CSS file */
.integration-hub input.mb-6,
input[name="webshop_domain"].mb-6 {
  margin-bottom: 0 !important;
}
```

## ✅ Testing Checklist

After applying the fix:

- [ ] Input fields are centered vertically in their containers
- [ ] No unwanted top alignment
- [ ] Form spacing between fields looks correct
- [ ] Integration hub loads without visual issues
- [ ] Shopify integration settings display properly
- [ ] Other integrations are not affected

## 📱 Responsive Testing

Test on different screen sizes to ensure the fix works across:
- Desktop (1920px+)
- Tablet (768px - 1024px) 
- Mobile (320px - 767px)

## 🔄 Alternative Solutions

If the CSS override doesn't work, try these approaches:

### 1. Scoped Component Fix
```vue
<style scoped>
.form-input {
  margin-bottom: 0;
}
.form-group {
  margin-bottom: 1.5rem;
}
</style>
```

### 2. Tailwind Class Replacement
```vue
<!-- Replace mb-6 with mb-0 and add container spacing -->
<div class="space-y-6">
  <input class="mb-0 w-full border rounded" />
</div>
```

---

**Priority**: 🔴 High - Affects user experience in integration setup
**Estimated Fix Time**: 15-30 minutes for CSS override, 1-2 hours for template fixes
**Testing Time**: 30 minutes across different integrations