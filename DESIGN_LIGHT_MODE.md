# Design System Strategy: The Artisanal Light Mode

## 1. Overview & Creative North Star
**Creative North Star: "The Modern Atelier"**
This design system moves away from the cold, clinical nature of traditional SaaS interfaces and embraces the warmth of a high-end, sun-drenched cafe. We are not building a generic dashboard; we are curating an editorial experience. By blending the precision of a modern geometric typeface (**Manrope**) with a tonal palette inspired by roasted beans and steamed milk, we achieve a look that feels both human and sophisticated.

The system breaks the "template" mold through **Intentional Asymmetry**. We favor generous, breathing white space over rigid grids. Elements should feel "placed" rather than "slotted," utilizing overlapping layers and high-contrast typography scales to guide the eye through a narrative, rather than a list.

---

## 2. Colors & Tonal Architecture
The palette is rooted in organic earth tones. Our goal is to create warmth without sacrificing the "clean" aesthetic required for modern utility.

### Palette Highlights
- **Primary (`#553722`)**: A deep espresso used for high-impact actions and key brand moments.
- **Secondary (`#735a3e`)**: A smooth latte tone for supportive elements.
- **Surface (`#fbf9f7`)**: Our creamy off-white canvas that prevents "snow blindness" caused by pure white.

### The "No-Line" Rule
**Strict Mandate:** Designers are prohibited from using 1px solid borders to define sections. Layout boundaries must be established solely through background color shifts. 
- To separate a sidebar from a main feed, use `surface-container-low` against a `surface` background. 
- For content cards, use `surface-container-lowest` (#ffffff) to create a "lift" against the creamier `background` (#fbf9f7).

### Surface Hierarchy & Nesting
Treat the UI as a physical stack of fine paper. 
- **Base Level:** `background` (#fbf9f7).
- **Secondary Layer:** `surface-container` (#efedec) for inset areas like search bars or code blocks.
- **Floating Layer:** `surface-container-lowest` (#ffffff) for primary interactive cards.

### The Glass & Gradient Rule
To inject "soul" into the interface, use **Glassmorphism** for floating navigation bars or overlays. Utilize `surface` with a 70% opacity and a `20px` backdrop-blur. For hero CTAs, apply a subtle linear gradient from `primary` (#553722) to `primary_container` (#6f4e37) at a 135-degree angle to provide a tactile, premium depth.

---

## 3. Typography: The Editorial Voice
We use **Manrope** across all levels, relying on drastic scale shifts rather than multiple typefaces to create hierarchy.

- **Display (Display-LG: 3.5rem):** Reserved for hero headlines. Use `tight` letter-spacing (-0.02em) to give it an authoritative, editorial feel.
- **Headlines (Headline-MD: 1.75rem):** Use for section headers. Always in `on_surface` (#1b1c1b).
- **Body (Body-LG: 1rem):** Optimized for long-form reading. Use a generous line-height (1.6) to maintain the "Artisanal" airy feel.
- **Labels (Label-SM: 0.6875rem):** All-caps with increased letter-spacing (+0.05em) for small functional text, creating a "technical-chic" contrast against organic body text.

---

## 4. Elevation & Depth
In this design system, shadows are a last resort, not a default. We lean on **Tonal Layering**.

- **The Layering Principle:** A "raised" effect is achieved by placing a `surface-container-lowest` (#ffffff) element onto a `surface_dim` (#dbdad8) background.
- **Ambient Shadows:** If a floating element (like a dropdown) requires a shadow, use a "Coffee-Tinted" shadow. Instead of black, use `on_surface` at 6% opacity with a `32px` blur and `12px` Y-offset. This mimics natural light passing through a warm environment.
- **The "Ghost Border" Fallback:** For high-density data where tonal shifts aren't enough, use a "Ghost Border": `outline_variant` (#d4c3ba) at **15% opacity**. It should be felt, not seen.

---

## 5. Components

### Buttons
- **Primary:** Gradient-filled (Primary to Primary-Container), 8px corner radius (`DEFAULT`). White text. High-density padding: `1rem 2rem`.
- **Secondary:** `surface-container-highest` background with `on_surface` text. No border.
- **Tertiary:** Pure text with an `accent` (#D4A373) underline that expands on hover.

### Input Fields
- Avoid boxes. Use a "Soft Inset" style: `surface-container` background with a `bottom-border` only, using `outline_variant`.
- Focus state: The bottom border transitions to `primary` (#553722) with a subtle `primary_fixed` glow.

### Cards & Lists
- **Forbidden:** Horizontal divider lines.
- **The Alternative:** Use vertical white space from the spacing scale (e.g., `spacing-8` or `2rem`) or subtle alternating background tones (`surface` to `surface-container-low`).
- **Cards:** Use `surface-container-lowest` with a `lg` (1rem) corner radius for a softer, more modern furniture-like feel.

### Artisanal Chips
- Small, pill-shaped (`full` roundedness). Use `secondary_container` (#fdd9b7) for a warm, "latte-foam" highlight effect behind dark brown text.

---

## 6. Do’s and Don’ts

### Do:
- **Use "Asymmetric Breathing Room":** Give more padding to the top of a header than the bottom to create an editorial flow.
- **Mix Weights:** Pair a Bold Headline-LG with a Regular Body-MD for immediate visual hierarchy.
- **Tint your Neutrals:** Ensure every "grey" has a hint of brown/cream (using our `surface_variant` tokens) to avoid a "dead" interface.

### Don't:
- **No Pure Black:** Never use `#000000`. Use `on_surface` (#1b1c1b) for the darkest elements.
- **No Hard Borders:** Avoid the "Bootstrap look." If you find yourself adding a border, try a background color shift first.
- **No Default Shadows:** Avoid standard `0px 2px 4px` shadows. They look cheap. Use our large-blur, low-opacity ambient shadow rules.
- **No Grid-Clutter:** Avoid cramming elements. If a screen feels full, increase the `spacing` scale rather than shrinking the components.