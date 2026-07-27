import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_management_frontend/bloc/pantry/pantry_bloc.dart';
import 'package:grocery_management_frontend/components/pantry_item_card.dart';
import 'package:grocery_management_frontend/models/category.dart';

class PantryListScreen extends StatelessWidget {
  const PantryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pantry'),
        actions: [
          BlocBuilder<PantryBloc, PantryState>(
            builder: (context, state) {
              return PopupMenuButton<int?>(
                tooltip: 'Filter by category',
                icon: const Icon(Icons.filter_list),
                onSelected: (categoryId) {
                  context.read<PantryBloc>().add(SetCategoryFilter(categoryId));
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: null,
                    child: Text('All Categories'),
                  ),
                  ...state.categories.map((category) => PopupMenuItem(
                        value: category.id,
                        child: Text(category.name),
                      )),
                ],
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<PantryBloc, PantryState>(
        builder: (context, state) {
          if (state.status == PantryStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == PantryStatus.failure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48, color: theme.colorScheme.error),
                  const SizedBox(height: 16),
                  Text('Failed to fetch pantry items', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () => context.read<PantryBloc>().add(FetchPantryItems()),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Try Again'),
                  ),
                ],
              ),
            );
          }
          
          final items = state.filteredItems;
          
          if (items.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.kitchen_outlined, size: 64, color: theme.colorScheme.secondary),
                    const SizedBox(height: 16),
                    Text('Pantry is Empty', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(
                      'Keep track of your food stock, quantities, and expiration thresholds.',
                      style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: () => _showAddPantryItemDialog(context),
                      icon: const Icon(Icons.add),
                      label: const Text('Add First Item'),
                    ),
                  ],
                ),
              ),
            );
          }
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return PantryItemCard(item: item);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add new item to pantry',
        onPressed: () {
          _showAddPantryItemDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddPantryItemDialog(BuildContext context) {
    final nameController = TextEditingController();
    final quantityController = TextEditingController();
    final minThresholdController = TextEditingController(text: '1');
    int? selectedCategoryId;
    String selectedUnit = 'count';
    final formKey = GlobalKey<FormState>();
    final List<Category> categories =
        context.read<PantryBloc>().state.categories;

    final unitChoices = [
      {'value': 'count', 'label': 'Count'},
      {'value': 'kg', 'label': 'Kilograms'},
      {'value': 'g', 'label': 'Grams'},
      {'value': 'lb', 'label': 'Pounds'},
      {'value': 'oz', 'label': 'Ounces'},
      {'value': 'l', 'label': 'Liters'},
      {'value': 'ml', 'label': 'Milliliters'},
    ];

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: const Text('Add Pantry Item'),
            content: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter a name' : null,
                    ),
                    TextFormField(
                      controller: quantityController,
                      decoration: const InputDecoration(labelText: 'Quantity'),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a quantity';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: minThresholdController,
                      decoration:
                          const InputDecoration(labelText: 'Low Stock Threshold'),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a threshold';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                    DropdownButtonFormField<String>(
                      initialValue: selectedUnit,
                      decoration: const InputDecoration(labelText: 'Unit'),
                      items: unitChoices.map((unit) {
                        return DropdownMenuItem(
                          value: unit['value'],
                          child: Text(unit['label']!),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedUnit = value!;
                        });
                      },
                    ),
                    DropdownButtonFormField<int>(
                      initialValue: selectedCategoryId,
                      decoration: const InputDecoration(labelText: 'Category'),
                      items: categories.map((category) {
                        return DropdownMenuItem(
                          value: category.id,
                          child: Text(category.name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCategoryId = value;
                        });
                      },
                      validator: (value) =>
                          value == null ? 'Please select a category' : null,
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    context.read<PantryBloc>().add(
                          AddPantryItem(
                            name: nameController.text,
                            quantity: double.parse(quantityController.text),
                            minThreshold:
                                double.parse(minThresholdController.text),
                            categoryId: selectedCategoryId!,
                            unit: selectedUnit,
                          ),
                        );
                    Navigator.of(dialogContext).pop();
                  }
                },
                child: const Text('Add'),
              ),
            ],
          );
        });
      },
    );
  }
}
