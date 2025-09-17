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

## Code Style

### Follow the Flutter Style Guide
- Analyzer configuration lives in [`mobile/analysis_options.yaml`](../mobile/analysis_options.yaml) and [`mobile/analysis_options_custom.yaml`](../mobile/analysis_options_custom.yaml); run `flutter analyze` locally to catch violations early.
- Use `lowerCamelCase` for variables, parameters, and functions, and `UpperCamelCase` for classes, enums, and typedefs.
- Keep indentation at two spaces and let `dart format` handle formatting details.
- Place required named parameters before optional ones (`always_put_required_named_parameters_first`).
- Prefer named arguments over positional booleans—add lightweight wrappers if necessary.

### Readability and Formatting
- Keep lines within 80 characters; rely on trailing commas (`require_trailing_commas`) to help the formatter break widgets cleanly.
- Prefer single quotes for strings unless interpolation or apostrophes require double quotes.
- Use `const` constructors and literals (`prefer_const_*` rules) and mark local variables `final` whenever possible to express immutability.

### Import and Module Hygiene
- Always use `package:` imports instead of relative paths for code under `lib/`.
- Avoid redundant argument values and unused parameters; remove unused private helpers.
- Do not introduce `print` statements—use the shared logger instead.
- Keep module boundaries clear by exposing APIs through public libraries rather than deep relative paths.

### Widgets and Layout
- Provide a `Key` for stateful widgets and list items that need stable identity.
- Avoid wrapping widgets with unnecessary `Container` instances; rely on `Padding`, `SizedBox`, or decoration widgets as appropriate.
- Sort widget constructor arguments so `child`/`children` come last to match Flutter conventions.

### Asynchronous Code
- Avoid `async` methods that return `void`; use `Future<void>` unless implementing callbacks.
- Use `unawaited` from `dart:async` when deliberately dropping a `Future` and document why in code comments when it is not obvious.
- Never return `null` from a `Future`; throw or return a meaningful value instead.
- Make side effects explicit—do not hide network or disk calls behind getters.

### Generated Code
- When you touch code that depends on code generation (`freezed`, `json_serializable`, localizations, etc.), run `./mobile/scripts/clean_up.sh` to clean, fetch dependencies, and rebuild generated files.

### Quality Gates
- Run `./mobile/scripts/checks.sh` locally before opening a pull request; it sorts ARB files, formats Dart, runs the analyzer, enforces Dart Code Metrics, and lints the design system packages.

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
