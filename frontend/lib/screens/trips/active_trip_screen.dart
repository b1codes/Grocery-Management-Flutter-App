import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_management_frontend/bloc/store/store_bloc.dart';
import 'package:grocery_management_frontend/bloc/trips/trip_bloc.dart';
import 'package:grocery_management_frontend/models/pantry_item.dart';
import 'package:grocery_management_frontend/bloc/pantry/pantry_bloc.dart';
import 'package:grocery_management_frontend/screens/pantry/pantry_search_screen.dart';

class ActiveTripScreen extends StatelessWidget {
  const ActiveTripScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Active Trip')),
      body: BlocBuilder<TripBloc, TripState>(
        builder: (context, state) {
          if (state.status == TripStatus.initial) {
            return const StoreSelection();
          }
          if (state.status == TripStatus.active) {
            return const ActiveTripView();
          }
          if (state.status == TripStatus.finished) {
            return const Center(child: Text('Trip Finished!'));
          }
          if (state.status == TripStatus.error) {
            return const Center(child: Text('An error occurred.'));
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
    return BlocBuilder<StoreBloc, StoreState>(
      builder: (context, state) {
        if (state.status == StoreStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.stores.isEmpty) {
          return const Center(child: Text('No stores available.'));
        }
        return ListView.builder(
          itemCount: state.stores.length,
          itemBuilder: (context, index) {
            final store = state.stores[index];
            return ListTile(
              title: Text(store.name),
              onTap: () {
                context.read<TripBloc>().add(StartTrip(storeId: store.id));
              },
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
    return Column(
      children: [
        Expanded(
          child: BlocBuilder<TripBloc, TripState>(
            builder: (context, state) {
              if (state.purchasedItems.isEmpty) {
                return const Center(child: Text('No items in cart.'));
              }
              return ListView.builder(
                itemCount: state.purchasedItems.length,
                itemBuilder: (context, index) {
                  final item = state.purchasedItems[index];
                  // Ideally we'd have the pantry item name here, but item only has pantryItem ID.
                  return ListTile(
                    title: Text('Pantry Item ID: ${item.pantryItem}'),
                    subtitle: Text(
                        'Quantity: ${item.quantityBought} | Price: \$${item.purchasePrice}'),
                  );
                },
              );
            },
          ),
        ),
        ElevatedButton(
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
          child: const Text('Add Item'),
        ),
        ElevatedButton(
          onPressed: () {
            context.read<TripBloc>().add(FinishTrip());
          },
          child: const Text('Finish Trip'),
        )
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
