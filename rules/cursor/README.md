# 🖱️ Cursor-Formatted Frontend Rules

This directory contains frontend development rules reformatted for use with the [Cursor](https://www.cursor.so/) editor. These rules are designed for automated enforcement and guidance within Cursor, ensuring consistent standards across your codebase.

## 📚 What Are Cursor Rules?

Cursor rules use a special Markdown format with YAML front matter and structured pattern/rule sections. This enables Cursor to:
- Automatically check your code for best practices
- Provide actionable suggestions and enforcement
- Help teams maintain high-quality, consistent code

> **Note:** The rules in this folder are functionally identical to those in `rules/frontend`, but are reformatted to meet Cursor's requirements for rule definition and automation.

## 🗂️ Folder Structure

```
frontend/
  general.mdc            # General guidelines for code organization and structure
  component-patterns.mdc # Best practices for components, props, emits, and forms
  performance.mdc        # Performance optimization rules for components and assets
```

## 📝 Rule Format Example

Each rule file uses this structure:

```markdown
---
description: "Short summary of what this rule file covers."
globs: ["src/**/*.{ts,vue}", ...]
alwaysApply: true
---

### Pattern: Descriptive Name
glob/pattern/**/*.vue

### Rule
Rule description and best practices.
```

- The `---` block at the top is YAML front matter for metadata.
- Each rule is defined by a `### Pattern:` and a `### Rule` section.
- No `---` separators between rules (only for front matter).

## 📄 Available Cursor Rules

| Rule File | Description |
| --------- | ----------- |
| [general.mdc](./frontend/general.mdc) | General guidelines for code organization, structure, and imports |
| [component-patterns.mdc](./frontend/component-patterns.mdc) | Best practices for components, props, emits, composables, and forms |
| [performance.mdc](./frontend/performance.mdc) | Performance tips for components, rendering, async ops, and asset optimization |

## 🚀 Using Cursor Rules

- **In Cursor:** These files are automatically recognized and enforced by Cursor if placed in your project.
- **In Other Editors:** You can read and follow these rules manually, but automated enforcement is only available in Cursor.

## ℹ️ More Information

- For the original (non-Cursor) rules, see the [rules/frontend](../frontend) directory.
- For project-wide standards and contribution guidelines, see the main [README](../../README.md). 