# Design Spec: Meals & AI Nutritional Insights

**Date:** 2026-04-19  
**Status:** Approved  
**Topic:** Typical Meal Logging and Gemini-Powered Recommendations

## 1. Overview
This feature introduces a "Meals" system to the Grocery Manager App, allowing users to group ingredients into reusable "Ingredient Bundles." It also adds a reactive AI Insights feature using the Gemini API to provide nutritional recommendations based on the user's shopping history.

## 2. Typical Meal Logging (Ingredient Bundles)

### 2.1 Backend Architecture
A new Django app `meals` will be created with the following models:

- **`Meal`**:
    - `name` (CharField)
    - `description` (TextField, optional)
    - `user` (FK to User)
    - `is_favorite` (BooleanField)
- **`MealIngredient`**:
    - `meal` (FK to Meal)
    - `pantry_item_template` (FK to PantryItem) - Represents the "type" of item needed.
    - `quantity` (DecimalField) - Quantity required for the meal.
    - `unit` (CharField) - Unit of measurement (to be integrated with Unit Support task).

### 2.2 Core Workflows
- **Bulk Add to Trip**: A frontend action to add all ingredients of a Meal to an active `GroceryTrip`.
- **Inventory Consumption**: A "Cook Meal" action that automatically decrements the `quantity` of the relevant `PantryItems`. 
    - *Logic*: Matches `MealIngredient` templates to the user's actual `PantryItems` and subtracts the specified quantity.

## 3. Gemini Nutritional Analysis (Reactive)

### 3.1 Backend Integration
- **Service Layer**: A new service `GeminiNutritionService` will handle communication with the Gemini API.
- **Input Data**: A JSON summary of:
    - Top 10-15 most frequent `PurchasedItems`.
    - User's defined `Meals`.
- **Prompt Strategy**: "Based on this user's shopping history and common meals, suggest 3-5 specific, healthier grocery swaps that maintain a similar flavor profile. Focus on actionable item-for-item replacements."

### 3.2 Frontend UI
- **Health Insights Screen**: A new screen accessible via the Dashboard/SideBar.
- **Interaction**: A prominent "Refresh Analysis" button to trigger the reactive request.
- **Display**: Results shown as cards with "Current Item" vs "Suggested Swap" and a brief "Why" (e.g., "Higher Fiber", "Lower Sodium").

## 4. Technical Requirements
- **Frontend**: New `MealManager` and `InsightManager` services.
- **State Management**: New BLoCs for `Meals` and `Insights`.
- **API**: New endpoints for `/api/meals/` and `/api/insights/recommend/`.

## 5. Success Criteria
- [ ] User can create a Meal with multiple ingredients and specific quantities.
- [ ] User can add all ingredients of a Meal to a Grocery Trip in one action.
- [ ] Pantry quantities are updated correctly when a meal is "cooked."
- [ ] Gemini API returns relevant, non-judgmental recommendations based on actual user data.
