# vytalLink Code Standards and Guidelines

This document outlines the coding standards and best practices for the vytalLink Flutter project.

## Language Requirements

### English-Only Policy
- All source code (variables, functions, classes, comments) must be written in English.
- Repository documentation (READMEs, markdown files, commit messages, pull requests) must also be in English.
- Do not add Spanish or other non-English words unless they are part of brand names or external APIs.

## Localization Requirements

### No Hardcoded User-Facing Strings
- All user-facing text must use `AppLocalizations`.
- No hardcoded strings for UI text.

### Adding New Localized Strings
1. Add the key-value pair to `lib/l10n/intl_en.arb`.
2. Run `flutter gen-l10n` to regenerate localization files.
3. Use `AppLocalizations.of(context)!.your_key` in the code.

## Logging Standards

### Use Logger Instead of Print
- All output must use the `Logger` class from `lib/core/common/logger.dart`.
- No `print()` statements allowed.

### Log Levels
- `Logger.d()` - Debug information.
- `Logger.i()` - General information.
- `Logger.w()` - Warnings.
- `Logger.e()` - Errors.

## File Organization

### Import Order
1. Dart/Flutter core imports.
2. Third-party package imports.
3. Local project imports.

### Import Guidelines
- Use `package:` imports for all internal dependencies.
- Group related imports together.
- Remove unused imports.

## Error Handling

### Exception Guidelines
- Use descriptive English exception messages.
- Create custom exception types when appropriate.
- Log errors appropriately before re-throwing.

## Design System Requirements

### No Hardcoded Colors
- All colors used in the application must come from the Design System.
- No hardcoded color values (e.g., `Color(0xFF123456)`) are allowed.
- Use the `customColors` or `colorScheme` provided by the Design System.

### Adding New Colors
1. Define the new color in the Design System.
2. Use the appropriate extension or theme property to access the color in the code.
