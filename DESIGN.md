# Design System: The Artisanal Interface

## 1. Overview & Creative North Star
**Creative North Star: "The Modern Roastery"**

This design system moves away from the sterile, "SaaS-blue" aesthetics of typical management software. Instead, it draws inspiration from high-end editorial layouts and the tactile nature of premium coffee culture. The goal is to create a digital workspace for baristas that feels as intentional and sophisticated as a pour-over station.

To break the "template" look, we utilize **Tonal Layering** and **Intentional Asymmetry**. We lean into high-contrast typography scales—pairing the structural precision of *Inter* with the architectural elegance of *Manrope*—to create a hierarchy that guides the eye through complex shop data with effortless grace.

---

## 2. Colors & Surface Philosophy
The palette is a sophisticated range of roasted umbers and steamed-milk creams, rooted in a deep, nocturnal base.

### The "No-Line" Rule
**Explicit Instruction:** Traditional 1px solid borders are strictly prohibited for sectioning. Boundaries must be defined solely through background color shifts or subtle tonal transitions. For example:
- Place a `surface_container_low` section sitting directly on a `background` floor.
- Use `surface_container_highest` only for the most critical interactive elements (like an active order card).

### Surface Hierarchy & Nesting
Treat the UI as a series of physical layers—like stacked sheets of fine paper or tinted glass. Use the `surface_container` tiers to define "Importance through Depth":
1. **Base:** `background` (#131313) - The shop floor.
2. **Structural Sections:** `surface_container_low` (#1C1B1B) - Large content blocks.
3. **Interactive Components:** `surface_container_high` (#2A2A2A) - Cards and buttons.
4. **Floating/Alert Elements:** `surface_bright` (#393939) - Modals and popovers.

### Glass & Gradient (The "Soul" Factor)
To move beyond a flat "app" feel:
- **Glassmorphism:** For floating headers or navigation bars, use `surface` colors at 80% opacity with a `20px` backdrop blur.
- **Signature Gradients:** For primary CTAs, use a subtle linear gradient from `primary` (#EABDA0) to `primary_container` (#6F4E37) at a 135-degree angle. This adds "visual soul" and a premium sheen.

---

## 3. Typography: Editorial Authority
The type system prioritizes speed of recognition under the harsh, fluctuating lights of a coffee shop.

*   **Display & Headlines (Manrope):** These are the "Signage" of the app. Use `display-lg` for daily revenue and `headline-md` for station names. The wide apertures of Manrope provide an architectural, premium feel.
*   **Body & Labels (Inter):** Chosen for its exceptional legibility at small sizes. Use `body-md` for ingredient lists and `label-sm` for timestamps. 
*   **Contrast as Navigation:** Use `on_surface` (#E5E2E1) for primary data and `on_surface_variant` (#D4C3BA) for secondary metadata. This 20% shift in tonal value creates hierarchy without needing to change font weight.

---

## 4. Elevation & Depth
In this system, elevation is a product of light and shadow, not lines.

*   **The Layering Principle:** Depth is achieved by "stacking." A `surface_container_lowest` card placed on a `surface_container_low` background creates a natural "recessed" look, perfect for "Completed Orders."
*   **Ambient Shadows:** For elements that must float (like a "New Order" FAB), use a large, diffused shadow: `blur: 24px, y: 8px, opacity: 6%`. The shadow color must be a dark tint of `primary_container` rather than pure black to maintain the warmth of the "Dark Coffee" theme.
*   **The Ghost Border:** If a boundary is required for accessibility, use the `outline_variant` token at **15% opacity**. Never use 100% opaque borders.

---

## 5. Components

### Buttons & Interaction
*   **Primary Action:** Rounded `xl` (1.5rem). Use the Signature Gradient (`primary` to `primary_container`). Text is `on_primary` (#452A16).
*   **Secondary/Utility:** `surface_container_highest` background with `on_surface` text. These should feel like part of the interface until needed.
*   **Barista Quick-Tap:** Use a minimum height of `12` (2.75rem) for all interactive areas to accommodate fast-paced environment handling.

### Cards & Lists (The "Breathable" Grid)
*   **No Dividers:** Forbid the use of divider lines. Separate items in a list using the Spacing Scale—specifically `spacing.4` (0.9rem) of vertical white space or a subtle background shift to `surface_container_low`.
*   **Order Cards:** Use `rounded-lg` (1.0rem). The top-right corner can feature a "Status Chip" using `tertiary_container` for a warm highlight that doesn't scream "Error."

### Inputs & Controls
*   **Fields:** Background should be `surface_container_lowest`. On focus, the "Ghost Border" increases to 40% opacity of the `primary` color.
*   **Selection Chips:** Use `secondary_fixed` for selected states. The organic, rounded shape (`full`) should feel like a smooth coffee bean.

### Specialized Components
*   **The Brew Timer:** A large `display-md` readout using the `accent` color (#D4A373), sitting on a `surface_bright` glass card to ensure it is visible from 5 feet away.

---

## 6. Do’s and Don’ts

### Do:
*   **Do** use asymmetrical spacing (e.g., more padding at the top of a card than the bottom) to create an editorial, premium feel.
*   **Do** rely on the `surface_container` hierarchy to group related items.
*   **Do** use `on_surface_variant` for all non-essential labels to keep the interface "quiet" for the user.

### Don't:
*   **Don't** use pure black (#000000). Always use `background` (#131313) to maintain the "inky" coffee warmth.
*   **Don't** use standard iOS blue for links. Use `accent` (#D4A373) or `secondary` (#E3C19F).
*   **Don't** crowd the screen. If a screen feels busy, increase the spacing from `spacing.4` to `spacing.8`.