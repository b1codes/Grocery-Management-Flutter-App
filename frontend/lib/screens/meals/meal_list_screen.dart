import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_management_frontend/bloc/meals/meals_bloc.dart';
import 'package:grocery_management_frontend/models/meal.dart';
import 'package:grocery_management_frontend/theme/app_theme.dart';
import 'add_meal_screen.dart';
import 'meal_detail_screen.dart';

class MealListScreen extends StatelessWidget {
  const MealListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Meal Recipes')),
      body: BlocBuilder<MealsBloc, MealsState>(
        builder: (context, state) {
          if (state.status == MealsStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == MealsStatus.failure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48, color: theme.colorScheme.error),
                  const SizedBox(height: 16),
                  Text('Failed to load meal recipes', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () => context.read<MealsBloc>().add(FetchMeals()),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Try Again'),
                  ),
                ],
              ),
            );
          }
          if (state.meals.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.restaurant_menu, size: 64, color: theme.colorScheme.secondary),
                    const SizedBox(height: 16),
                    Text('No Meal Recipes Saved', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(
                      'Create recipes to automatically plan shopping trips and decrement pantry stock after cooking.',
                      style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => BlocProvider.value(
                          value: context.read<MealsBloc>(),
                          child: const AddMealScreen(),
                        )),
                      ),
                      icon: const Icon(Icons.add),
                      label: const Text('Create First Recipe'),
                    ),
                  ],
                ),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: state.meals.length,
            itemBuilder: (context, index) {
              final meal = state.meals[index];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: theme.colorScheme.primaryContainer,
                    child: Icon(Icons.restaurant, color: theme.colorScheme.primary),
                  ),
                  title: Text(meal.name, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  subtitle: Text(meal.description ?? '${meal.ingredients.length} ingredients'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        tooltip: meal.isFavorite ? 'Remove from favorites' : 'Add to favorites',
                        icon: Icon(
                          meal.isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: meal.isFavorite ? AppTheme.thermalCore : null,
                        ),
                        onPressed: () => context.read<MealsBloc>().add(
                          ToggleMealFavorite(id: meal.id!, isFavorite: !meal.isFavorite),
                        ),
                      ),
                      IconButton(
                        tooltip: 'Delete recipe',
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => _confirmDelete(context, meal),
                      ),
                    ],
                  ),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: context.read<MealsBloc>(),
                        child: MealDetailScreen(meal: meal),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Create new meal recipe',
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => BlocProvider.value(
            value: context.read<MealsBloc>(),
            child: const AddMealScreen(),
          )),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _confirmDelete(BuildContext context, Meal meal) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Meal?'),
        content: Text('Are you sure you want to delete "${meal.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.thermalCore),
            onPressed: () {
              context.read<MealsBloc>().add(DeleteMeal(meal.id!));
              Navigator.pop(dialogContext);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
