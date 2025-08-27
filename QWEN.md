# Project Context for Qwen Code

## Project Overview

This is a **Vue 3** application built with **Vite**. It's a simple shopping list app that allows users to add items with a name, quantity, and unit price. The app calculates the total cost for each item and the overall expenses. It also features a budgeting section where users can set a budget and track their spending against it. Data is persisted using `localStorage`.

Key technologies used:
- **Vue 3** (Composition API)
- **Vite** as the build tool and development server.
- **Tailwind CSS** for styling, configured with **daisyUI** for pre-built components.
- **localStorage** for client-side data persistence.

## Project Structure

The main entry point is `src/main.js`, which mounts the root `App.vue` component. The application logic is primarily contained within `App.vue` and its child components located in `src/components/`.

### Key Files and Components

- **`src/App.vue`**: The main application component. It manages the state of shopping items, handles adding/updating/deleting items, and interacts with `localStorage`. It renders the `BudgetSection`, list of `ShoppingItem`s, and the `AddItemButton`.
- **`src/components/BudgetSection.vue`**: Displays the current budget, total expenses, and the remaining balance. It includes logic to open a modal for setting or adjusting the budget, and persists the budget value to `localStorage`.
- **`src/components/ShoppingItem.vue`**: Represents a single item in the shopping list. Displays the item's name, quantity, unit price, and total cost. Provides buttons to edit or delete the item.
- **`src/components/AddItemButton.vue`**: Contains the floating action button to add new items and the modal form for adding or editing items. It handles the logic for calculating the item's total cost and emitting events to the parent (`App.vue`) to add or update items.

## Building and Running

- **Setup:** `npm install`
- **Development Server:** `npm run dev` (Starts the Vite development server with hot-reloading).
- **Production Build:** `npm run build` (Compiles and minifies the application for production).
- **Preview Production Build:** `npm run preview` (Locally preview the production build).

## Development Conventions

- **Vue 3 Composition API**: The project uses the Composition API with `<script setup>` syntax for components.
- **Styling**: Tailwind CSS classes are used directly in the template for styling. daisyUI provides additional utility classes and component styles.
- **State Management**: Simple state management is handled within the `App.vue` component using `ref` and `computed` from Vue. Child components communicate with the parent via events (`emit`) and `defineExpose` for direct method calls (used for opening the edit modal).
- **Persistence**: `localStorage` is used to persist the list of shopping items and the budget value across browser sessions.