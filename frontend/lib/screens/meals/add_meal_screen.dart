import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_management_frontend/bloc/meals/meals_bloc.dart';
import 'package:grocery_management_frontend/models/meal.dart';
import 'package:grocery_management_frontend/models/pantry_item.dart';
import 'package:grocery_management_frontend/services/managers/pantry_manager.dart';

class AddMealScreen extends StatefulWidget {
  const AddMealScreen({super.key});

  @override
  State<AddMealScreen> createState() => _AddMealScreenState();
}

class _AddMealScreenState extends State<AddMealScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final List<MealIngredient> _ingredients = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Meal'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _submit,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Meal Name', border: OutlineInputBorder()),
              validator: (v) => v!.isEmpty ? 'Enter a name' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description (optional)', border: OutlineInputBorder()),
              maxLines: 2,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Ingredients', style: Theme.of(context).textTheme.titleLarge),
                TextButton.icon(
                  onPressed: _addIngredient,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Ingredient'),
                ),
              ],
            ),
            if (_ingredients.isEmpty)
              const Center(child: Padding(
                padding: EdgeInsets.all(32.0),
                child: Text('No ingredients added yet.'),
              )),
            ..._ingredients.asMap().entries.map((entry) {
              final idx = entry.key;
              final ingredient = entry.value;
              return Card(
                child: ListTile(
                  title: Text(ingredient.pantryItemTemplate?.name ?? 'Unknown Item'),
                  subtitle: Text('${ingredient.quantity} ${ingredient.unit ?? ""}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: () => setState(() => _ingredients.removeAt(idx)),
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  void _addIngredient() async {
    final pantryManager = context.read<PantryManager>();
    final items = await pantryManager.getPantryItems();
    
    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      builder: (ctx) => ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return ListTile(
            title: Text(item.name),
            onTap: () {
              Navigator.pop(ctx);
              _showQuantityDialog(item);
            },
          );
        },
      ),
    );
  }

  void _showQuantityDialog(PantryItem item) {
    final qtyController = TextEditingController(text: '1');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Quantity for ${item.name}'),
        content: TextField(
          controller: qtyController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Amount'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _ingredients.add(MealIngredient(
                  pantryItemTemplate: item,
                  quantity: double.tryParse(qtyController.text) ?? 1.0,
                  unit: 'units', // Placeholder until unit support is added
                ));
              });
              Navigator.pop(ctx);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.read<MealsBloc>().add(AddMeal(
        name: _nameController.text,
        description: _descriptionController.text,
        ingredients: _ingredients,
      ));
      Navigator.pop(context);
    }
  }
}
