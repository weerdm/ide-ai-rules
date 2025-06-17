# 📏 Frontend Development Rules

<div align="center">
  <p><em>Standardized rules for consistent, high-quality frontend development</em></p>
</div>

## 📚 Overview

This repository contains standardized rules to improve code generation and maintain consistency across Trengo repositories. These rules help teams follow best practices and reduce errors when developing with modern tooling and AI assistance.

> This repository also provides rules formatted for Cursor, allowing teams using Cursor to benefit from the same standards in an automated way. See [rules/cursor/README.md](./rules/cursor/README.md) for details.

## 🗂️ Repository Structure

```
.rules/
  rules/
    frontend/           # Rules for the main frontend repository
    ui/                 # Rules for the UI components library
    icons/              # Rules for the icons library
    ai-helpmate/        # Rules for the AI helpmate frontend
  cursor-rules/
    frontend/           # Cursor-formatted rules for the main frontend repository
  README.md             # This file
```

## 🔍 All Rules

### 🌐 Frontend Rules

| 📄 Rule File                                                        | 📝 Description                                                            |
| ------------------------------------------------------------------- | ------------------------------------------------------------------------- |
| [📌 General Guidelines](./rules/frontend/00-general.mdc)            | Code organization, directory structure, file naming, and component styles |
| [🧩 Component Patterns](./rules/frontend/01-component-patterns.mdc) | Best practices for components, props, events, and state management        |
| [⚡ Performance Guidelines](./rules/frontend/02-performance.mdc)    | Optimization tips for components, rendering, and bundle size              |

### 🎨 UI Rules

| 📄 Rule File                                                      | 📝 Description                                                |
| ----------------------------------------------------------------- | ------------------------------------------------------------- |
| [🧱 Component Guidelines](./rules/ui/00-component-guidelines.mdc) | Standards for UI components, accessibility, and documentation |
| [🎭 Design System](./rules/ui/01-design-system.mdc)               | Guidelines for colors, typography, spacing, and more          |

### 🔣 Icons Rules

| 📄 Rule File                                               | 📝 Description                                            |
| ---------------------------------------------------------- | --------------------------------------------------------- |
| [🖼️ Icon Guidelines](./rules/icons/00-icon-guidelines.mdc) | Structure, naming conventions, and optimization for icons |

### 🤖 AI Helpmate Rules

| 📄 Rule File                                                           | 📝 Description                                         |
| ---------------------------------------------------------------------- | ------------------------------------------------------ |
| [📋 General Guidelines](./rules/ai-helpmate/00-general-guidelines.mdc) | Project structure, component organization, and testing |
| [📦 Modules Structure](./rules/ai-helpmate/01-modules.mdc)             | Module organization, communication, and registration   |

## 🚀 How to Use These Rules

### 🔌 With IDE Integration

Many modern IDEs and editors can integrate with these standardized rules:

1. 📥 Configure your IDE to recognize the `.rules` directory
2. 🔄 Some IDEs can automatically apply these standards during development
3. 💻 AI coding assistants can be configured to follow these guidelines

### 📖 Without Integration

Even without direct IDE integration, you can still benefit from these rules by:

1. 📚 Reading them to understand the project's coding standards
2. 📋 Referencing them during code reviews and development
3. 🔍 Using them as a guide for new feature implementation

## 🤝 Contributing

To contribute to these rules:

1. 📝 Make changes to the appropriate Markdown files
2. 📏 Follow the existing format and structure
3. 🔀 Submit a pull request for review

## ❓ Questions and Feedback

If you have questions about these rules or want to provide feedback, please reach out to the development team.

<div align="center">
  <p><em>Build reliable software with consistent standards</em></p>
</div>
