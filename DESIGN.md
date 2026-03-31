# CoffeeShopManager Design System

## 1. Purpose
This repo uses a tokenized color system in `Assets.xcassets` with dynamic light/dark variants.
All UI styling should consume named color assets (no hard-coded RGB in SwiftUI views).

## 2. Active Color Tokens

### Core App Tokens (`Theme*`)
Used by shared/settings screens and existing app-level styling.

- `ThemeBackground`
- `ThemeSurface`
- `ThemeText`
- `ThemeSubtext`
- `ThemePrimary`
- `ThemeAccent`

Notes:
- `ThemeBackground`, `ThemeSurface`, `ThemeText`, and `ThemeSubtext` have light+dark variants.
- `ThemePrimary` and `ThemeAccent` are brand/action colors.

### Figma-Aligned Tokens (`Figma*`)
Used by the custom redesigned screens:
- `RootTabView`
- `DashboardView`
- `CoffeePOSView`
- `MenuListView`

Tokens:
- Base/surface: `FigmaBackground`, `FigmaBackgroundDeep`, `FigmaCard`, `FigmaBanner`
- Text: `FigmaTextPrimary`, `FigmaTextSecondary`, `FigmaWhite`, `FigmaBlack`
- Accent/actions: `FigmaAccent`, `FigmaAccentDark`, `FigmaOnAccent`, `FigmaOnAccentSoft`, `FigmaOnAccentDeep`, `FigmaOnAccentDarker`
- Status/utility: `FigmaSuccess`, `FigmaFilterActive`, `FigmaBadgeWarm`, `FigmaCartBadgeText`
- Tile gradients: `FigmaTileBrown`, `FigmaTileBlue`, `FigmaTileNavy`, `FigmaTileCopper`, `FigmaMenuCoffee1`, `FigmaMenuCoffee2`, `FigmaMenuOther2`
- Category tags: `FigmaTagCoffee`, `FigmaTagTea`, `FigmaTagJuice`, `FigmaTagPastry`

Notes:
- Every `Figma*` token is dynamic (`Any` + `Dark`) and auto-switches with system/app theme.

## 3. Theme Mode Behavior
Theme mode is controlled globally from app root:

- Source of truth: `@AppStorage("settings.darkMode")`
- Applied in: `ContentView` via `.preferredColorScheme(...)`

This ensures mode changes from Settings apply to the whole app, not just one screen.

## 4. Rules

### Required
- Use `Color("TokenName")` or generated asset color accessors.
- Add new colors as asset tokens with both light and dark appearances.
- Prefer reusing existing tokens before introducing new ones.

### Forbidden
- New hard-coded literals like `Color(red:..., green:..., blue:...)` in views.
- Screen-local color schemes for dark/light mode.
- One-off color tokens without documented purpose.

## 5. Asset Hygiene
Performed cleanup:
- Removed unused `Light*` color sets (superseded by dynamic `Figma*` tokens).
- Removed unused `ThemeSecondary` color set.

Keep `AccentColor.colorset` because Xcode/asset compilation expects it as the project accent asset.

## 6. Change Checklist (UI/Color PRs)
- Add/update color token in `Assets.xcassets` with light+dark values.
- Replace direct color literals with token references.
- Verify global theme toggle still affects all screens.
- Run build:
  - `xcodebuild -project CoffeeShopManager.xcodeproj -scheme CoffeeShopManager -configuration Debug -destination 'generic/platform=iOS Simulator' CODE_SIGNING_ALLOWED=NO build`
