import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_management_frontend/bloc/store/store_bloc.dart';
import 'package:grocery_management_frontend/bloc/trips/trip_bloc.dart';
import 'package:grocery_management_frontend/models/pantry_item.dart';
import 'package:grocery_management_frontend/bloc/pantry/pantry_bloc.dart';
import 'package:grocery_management_frontend/screens/pantry/pantry_search_screen.dart';
import 'package:grocery_management_frontend/theme/app_theme.dart';

class ActiveTripScreen extends StatelessWidget {
  const ActiveTripScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shopping Trip')),
      body: BlocBuilder<TripBloc, TripState>(
        builder: (context, state) {
          if (state.status == TripStatus.initial) {
            return const StoreSelection();
          }
          if (state.status == TripStatus.active) {
            return const ActiveTripView();
          }
          if (state.status == TripStatus.finished) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle_outline, size: 64, color: AppTheme.cyanSignal),
                  const SizedBox(height: 16),
                  Text('Trip Finished!', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('Pantry inventory and budget logs updated.', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.textSecondary)),
                ],
              ),
            );
          }
          if (state.status == TripStatus.error) {
            return const Center(child: Text('An error occurred during trip execution.'));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class StoreSelection extends StatelessWidget {
  const StoreSelection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<StoreBloc, StoreState>(
      builder: (context, state) {
        if (state.status == StoreStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.stores.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.storefront_outlined, size: 64, color: theme.colorScheme.secondary),
                  const SizedBox(height: 16),
                  Text('Select a Store to Start', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(
                    'No stores found in directory. Add a store in the Stores tab to begin a shopping trip.',
                    style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: state.stores.length,
          itemBuilder: (context, index) {
            final store = state.stores[index];
            return Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: theme.colorScheme.primaryContainer,
                  child: Icon(Icons.shopping_bag_outlined, color: theme.colorScheme.primary),
                ),
                title: Text(store.name, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                subtitle: Text(store.address?.addressLine ?? 'Select to start shopping trip'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  context.read<TripBloc>().add(StartTrip(storeId: store.id));
                },
              ),
            );
          },
        );
      },
    );
  }
}

class ActiveTripView extends StatelessWidget {
  const ActiveTripView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Expanded(
          child: BlocBuilder<TripBloc, TripState>(
            builder: (context, state) {
              if (state.purchasedItems.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_cart_outlined, size: 64, color: theme.colorScheme.secondary),
                        const SizedBox(height: 16),
                        Text('Your Cart is Empty', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text(
                          'Scan or search items to check them off as you navigate store aisles.',
                          style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.purchasedItems.length,
                itemBuilder: (context, index) {
                  final item = state.purchasedItems[index];
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.check_box, color: AppTheme.thermalCore),
                      title: Text('Item ID: ${item.pantryItem}', style: theme.textTheme.titleMedium),
                      subtitle: Text(
                        'Qty: ${item.quantityBought}  |  Price: \$${item.purchasePrice}',
                        style: theme.textTheme.bodyMedium?.copyWith(fontFamily: 'JetBrains Mono'),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: const BoxDecoration(
            color: AppTheme.surfaceDark,
            border: Border(top: BorderSide(color: AppTheme.glassBorder, width: 1)),
          ),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final tripBloc = context.read<TripBloc>();
                    final pantryItem = await Navigator.of(context).push<PantryItem>(
                      MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          value: BlocProvider.of<PantryBloc>(context),
                          child: const PantrySearchScreen(),
                        ),
                      ),
                    );

                    if (pantryItem != null && context.mounted) {
                      final result = await _showAddItemDialog(context, pantryItem);
                      if (result != null) {
                        tripBloc.add(AddItemToTrip(
                          pantryItemId: pantryItem.id,
                          price: result['price'],
                          quantity: result['quantity'],
                        ));
                      }
                    }
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add Item'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () {
                    context.read<TripBloc>().add(FinishTrip());
                  },
                  icon: const Icon(Icons.check),
                  label: const Text('Finish Trip'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<Map<String, dynamic>?> _showAddItemDialog(
      BuildContext context, PantryItem item) async {
    final priceController =
        TextEditingController(text: item.regularPrice.toString());
    final quantityController = TextEditingController(text: '1');
    final formKey = GlobalKey<FormState>();

    return showDialog<Map<String, dynamic>>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('Add ${item.name} (${item.unit})'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: priceController,
                  decoration: const InputDecoration(labelText: 'Price'),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a price';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: quantityController,
                  decoration: InputDecoration(labelText: 'Quantity (${item.unit})'),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
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
                  Navigator.of(dialogContext).pop({
                    'price': double.parse(priceController.text),
                    'quantity': double.parse(quantityController.text),
                  });
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
