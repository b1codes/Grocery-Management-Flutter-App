import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_management_frontend/bloc/pantry/pantry_bloc.dart';
import 'package:grocery_management_frontend/components/pantry_item_card.dart';
import 'package:grocery_management_frontend/models/category.dart';

class PantryListScreen extends StatelessWidget {
  const PantryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pantry'),
        actions: [
          BlocBuilder<PantryBloc, PantryState>(
            builder: (context, state) {
              return PopupMenuButton<int?>(
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
            return const Center(child: Text('Failed to fetch pantry items'));
          }
          
          final items = state.filteredItems;
          
          if (items.isEmpty) {
            return const Center(child: Text('No items in pantry.'));
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
    int? selectedCategoryId;
    final formKey = GlobalKey<FormState>();
    final List<Category> categories = context.read<PantryBloc>().state.categories;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: const Text('Add Pantry Item'),
            content: Form(
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
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a quantity';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
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
                            quantity: int.parse(quantityController.text),
                            categoryId: selectedCategoryId!,
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
