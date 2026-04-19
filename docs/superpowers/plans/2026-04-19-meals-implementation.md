# Meals & Ingredient Bundles Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Implement a "Meals" system to group ingredients, bulk-add them to trips, and track pantry consumption.

**Architecture:** A new Django app `meals` handles relationships between users, meals, and pantry templates. The frontend uses a `MealManager` to coordinate between trips and pantry inventory.

**Tech Stack:** Flutter (BLoC), Django (DRF).

---

### Task 1: Create Backend `meals` App and Models

**Files:**
- Create: `backend/apps/meals/models.py`
- Create: `backend/apps/meals/apps.py`
- Modify: `backend/config/settings.py`

- [ ] **Step 1: Define the Meal and MealIngredient models**
- [ ] **Step 2: Register app in settings**
- [ ] **Step 3: Run migrations**
- [ ] **Step 4: Commit**

---

### Task 2: Implement Meal API Endpoints

**Files:**
- Create: `backend/apps/meals/serializers.py`
- Create: `backend/apps/meals/views.py`
- Create: `backend/apps/meals/urls.py`
- Modify: `backend/config/urls.py`

- [ ] **Step 1: Create Serializers**
- [ ] **Step 2: Create ViewSets for CRUD operations**
- [ ] **Step 3: Register URLs**
- [ ] **Step 4: Test API with cURL or simple script**
- [ ] **Step 5: Commit**

---

### Task 3: Frontend Models and Manager

**Files:**
- Create: `frontend/lib/models/meal.dart`
- Create: `frontend/lib/services/managers/meal_manager.dart`

- [ ] **Step 1: Define Dart Mappable classes for Meal and MealIngredient**
- [ ] **Step 2: Run build_runner**
- [ ] **Step 3: Implement MealManager for API interaction**
- [ ] **Step 4: Commit**

---

### Task 5: Bulk-Add and Consumption Logic

**Files:**
- Modify: `frontend/lib/services/managers/trip_manager.dart`
- Modify: `frontend/lib/screens/meals/meal_detail_screen.dart`

- [ ] **Step 1: Add `addMealToTrip` method to TripManager**
- [ ] **Step 2: Implement "Cook Meal" action in MealManager to decrement pantry stock**
- [ ] **Step 3: Verify end-to-end**
- [ ] **Step 4: Commit**
