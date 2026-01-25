import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_management_frontend/bloc/pantry/pantry_bloc.dart';
import 'package:grocery_management_frontend/models/pantry_item.dart';

class PantryItemCard extends StatelessWidget {
  final PantryItem item;

  const PantryItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(item.name,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                Text(item.quantity.toString(),
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
    );
  }
}
