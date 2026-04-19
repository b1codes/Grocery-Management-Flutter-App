import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_management_frontend/bloc/meals/meals_bloc.dart';
import 'package:grocery_management_frontend/bloc/trips/trip_bloc.dart';
import 'package:grocery_management_frontend/models/meal.dart';

class MealDetailScreen extends StatelessWidget {
  final Meal meal;

  const MealDetailScreen({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(meal.name),
      ),
      body: BlocBuilder<TripBloc, TripState>(
        builder: (context, tripState) {
          final hasActiveTrip = tripState.status == TripStatus.active && tripState.trip != null;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (meal.description != null) ...[
                Text(
                  meal.description!,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 24),
              ],
              Text(
                'Ingredients',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              ...meal.ingredients.map((ingredient) => Card(
                child: ListTile(
                  title: Text(ingredient.pantryItemTemplate.name),
                  subtitle: Text('${ingredient.quantity} ${ingredient.unit ?? ""}'),
                ),
              )),
              const SizedBox(height: 32),
              if (hasActiveTrip) ...[
                ElevatedButton.icon(
                  onPressed: () => _addToTrip(context, tripState.trip!.id!),
                  icon: const Icon(Icons.add_shopping_cart),
                  label: const Text('Add to Current Trip'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 16),
              ],
              ElevatedButton.icon(
                onPressed: () => _cookMeal(context),
                icon: const Icon(Icons.restaurant),
                label: const Text('Cook Meal (Decrement Pantry)'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _addToTrip(BuildContext context, int tripId) {
    context.read<MealsBloc>().add(AddMealToTrip(tripId: tripId, meal: meal));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Ingredients for "${meal.name}" added to trip!')),
    );
  }

  void _cookMeal(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cook Meal?'),
        content: const Text('This will subtract the required ingredients from your pantry inventory.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              context.read<MealsBloc>().add(CookMeal(meal));
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Meal "cooked"! Pantry updated.')),
              );
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}
