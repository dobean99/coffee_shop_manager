# Repository Guidelines

## Project Structure & Module Organization
- `CoffeeShopManager/` contains all app source and assets.
- Entry point: `CoffeeShopManagerApp.swift`.
- Main UI view: `ContentView.swift`.
- Asset catalogs live in `CoffeeShopManager/Assets.xcassets/` and preview-only assets in `CoffeeShopManager/Preview Content/Preview Assets.xcassets/`.
- Xcode project configuration is in `CoffeeShopManager.xcodeproj/`.
- There is currently no separate test target; add one as `CoffeeShopManagerTests/` when introducing tests.

## Build, Test, and Development Commands
- Open in Xcode:
  - `open CoffeeShopManager.xcodeproj`
- Build from CLI (Debug):
  - `xcodebuild -project CoffeeShopManager.xcodeproj -scheme CoffeeShopManager -configuration Debug build`
- Clean build artifacts:
  - `xcodebuild -project CoffeeShopManager.xcodeproj -scheme CoffeeShopManager clean`
- Run tests (after adding a test target):
  - `xcodebuild -project CoffeeShopManager.xcodeproj -scheme CoffeeShopManager -destination 'platform=iOS Simulator,name=iPhone 16' test`

## Coding Style & Naming Conventions
- Language: Swift + SwiftUI.
- Follow standard Swift API Design Guidelines and Xcode defaults (4-space indentation, no tabs).
- Types use `UpperCamelCase` (`CoffeeShopManagerApp`), properties/functions use `lowerCamelCase`.
- Keep SwiftUI views small and composable; extract reusable UI into dedicated `View` structs.
- Name files after the primary type they contain (for example, `OrderListView.swift`).
- No formatter/linter is configured yet; if adding `SwiftFormat`/`SwiftLint`, include config files in the repo.

## Testing Guidelines
- Preferred framework: `XCTest`.
- Add unit tests under `CoffeeShopManagerTests/` and UI tests under `CoffeeShopManagerUITests/`.
- Test names should follow `test_<Scenario>_<ExpectedResult>()`.
- Prioritize coverage for view models, business logic, and state transitions before UI snapshot-style checks.

## Commit & Pull Request Guidelines
- Current history starts with `Initial Commit`; use short, imperative commit messages going forward (for example, `Add order summary view`).
- Keep commits focused to one logical change.
- PRs should include:
  - Purpose and scope
  - Linked issue (if available)
  - Screenshots/video for UI changes
  - Test notes (what was run, and results)
