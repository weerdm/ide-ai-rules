# Integration Hub CSS Fix - Implementation Guide

## 🚨 Issue Summary
Input elements in the integration hub have unwanted `mb-6` classes causing 24px bottom margin, making them align to the top instead of center.

## 🔧 Quick Fix Solutions

### Option 1: CSS Override (Immediate Fix)
Add this CSS to your main stylesheet or integration hub specific CSS file:

```css
/* Fix for integration hub input alignment */
.integration-hub input,
.integration-hub .input-field,
[data-testid*="integration"] input {
  margin-bottom: 0 !important;
}

/* Apply proper spacing to form containers instead */
.integration-hub .form-group,
.integration-hub .field-wrapper {
  margin-bottom: 1.5rem;
}

.integration-hub .form-group:last-child,
.integration-hub .field-wrapper:last-child {
  margin-bottom: 0;
}
```

### Option 2: Template/Component Fix (Preferred)
Find components/templates with patterns like:

```html
<!-- CURRENT (PROBLEMATIC) -->
<input class="mb-6 w-full border rounded" name="webshop_domain" />

<!-- FIXED VERSION -->
<div class="mb-6">
  <input class="w-full border rounded" name="webshop_domain" />
</div>
```

### Option 3: Tailwind Utility Fix
If you need to quickly override without changing templates:

```css
/* Add to your CSS file */
.integration-hub input.mb-6 {
  margin-bottom: 0 !important;
}
```

## 📁 Files to Check

Based on the screenshots, look for these likely locations:
- Integration hub form components
- Shopify integration settings
- Any files with form inputs in integration contexts
- Global input styling files

## 🔍 Search Commands

Use these commands to find the problematic code:

```bash
# Find mb-6 classes on input elements
grep -r "input.*mb-6\|mb-6.*input" .

# Find integration hub related files
find . -name "*integration*" -type f

# Search for webshop domain inputs (from screenshot)
grep -r "webshop.*domain\|shop.*domain" .
```

## ✅ Testing

After applying the fix:
1. Check that inputs are properly centered in their containers
2. Verify form spacing still looks good
3. Test on different screen sizes
4. Ensure no other forms are affected

## 🎯 Expected Result

- Input fields should be vertically centered in their containers
- No unwanted top alignment
- Proper spacing between form fields maintained
- Clean, professional appearance in integration hub

---

**Priority**: High - This affects user experience in integration setup
**Estimated Time**: 15-30 minutes for CSS override, 1-2 hours for complete template fixes