import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_management_frontend/bloc/meals/meals_bloc.dart';
import 'package:grocery_management_frontend/models/meal.dart';
import 'add_meal_screen.dart';

class MealListScreen extends StatelessWidget {
  const MealListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meals')),
      body: BlocBuilder<MealsBloc, MealsState>(
        builder: (context, state) {
          if (state.status == MealsStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == MealsStatus.failure) {
            return const Center(child: Text('Failed to fetch meals'));
          }
          if (state.meals.isEmpty) {
            return const Center(child: Text('No meals found. Create one to get started!'));
          }
          return ListView.builder(
            itemCount: state.meals.length,
            itemBuilder: (context, index) {
              final meal = state.meals[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.restaurant)),
                  title: Text(meal.name),
                  subtitle: Text(meal.description ?? '${meal.ingredients.length} ingredients'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          meal.isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: meal.isFavorite ? Colors.red : null,
                        ),
                        onPressed: () => context.read<MealsBloc>().add(
                          ToggleMealFavorite(id: meal.id!, isFavorite: !meal.isFavorite),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => _confirmDelete(context, meal),
                      ),
                    ],
                  ),
                  onTap: () {
                    // TODO: Navigate to Detail/Edit
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
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
          TextButton(
            onPressed: () {
              context.read<MealsBloc>().add(DeleteMeal(meal.id!));
              Navigator.pop(dialogContext);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
