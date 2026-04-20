import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_management_frontend/bloc/pantry/pantry_bloc.dart';
import 'package:grocery_management_frontend/models/pantry_item.dart';
import 'package:grocery_management_frontend/models/category.dart';

class PantryItemCard extends StatelessWidget {
  final PantryItem item;

  const PantryItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final bool isLowStock = item.quantity <= item.minThreshold;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: isLowStock ? Colors.orange.withValues(alpha: 0.1) : null,
      child: InkWell(
        onLongPress: () => _showEditPantryItemDialog(context, item),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.name,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    if (isLowStock)
                      const Text('Low Stock',
                          style: TextStyle(
                              color: Colors.orange,
                              fontSize: 12,
                              fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: item.quantity > 0
                        ? () {
                            context.read<PantryBloc>().add(UpdatePantryItem(
                                  id: item.id,
                                  quantity: item.quantity - 1,
                                ));
                          }
                        : null,
                  ),
                  Text('${item.quantity % 1 == 0 ? item.quantity.toInt() : item.quantity} ${item.unit}',
                      style: const TextStyle(fontSize: 18)),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      context.read<PantryBloc>().add(UpdatePantryItem(
                            id: item.id,
                            quantity: item.quantity + 1,
                          ));
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showEditPantryItemDialog(BuildContext context, PantryItem item) {
    final nameController = TextEditingController(text: item.name);
    final minThresholdController =
        TextEditingController(text: item.minThreshold.toString());
    int? selectedCategoryId = item.category;
    String selectedUnit = item.unit;
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
            title: const Text('Edit Pantry Item'),
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
                          UpdatePantryItem(
                            id: item.id,
                            name: nameController.text,
                            minThreshold:
                                double.parse(minThresholdController.text),
                            categoryId: selectedCategoryId,
                            unit: selectedUnit,
                          ),
                        );
                    Navigator.of(dialogContext).pop();
                  }
                },
                child: const Text('Save'),
              ),
            ],
          );
        });
      },
    );
  }
}
