import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_management_frontend/bloc/store/store_bloc.dart';

class StoreListScreen extends StatelessWidget {
  const StoreListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Stores Directory'),
      ),
      body: BlocBuilder<StoreBloc, StoreState>(
        builder: (context, state) {
          if (state.status == StoreStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == StoreStatus.failure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48, color: theme.colorScheme.error),
                  const SizedBox(height: 16),
                  Text('Failed to load store directory', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () => context.read<StoreBloc>().add(FetchStores()),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Try Again'),
                  ),
                ],
              ),
            );
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
                    Text('No Stores Saved Yet', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(
                      'Save your favorite grocery stores to organize trips and track location spending.',
                      style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: () => _showAddStoreDialog(context),
                      icon: const Icon(Icons.add),
                      label: const Text('Add Favorite Store'),
                    ),
                  ],
                ),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: state.stores.length,
            itemBuilder: (context, index) {
              final store = state.stores[index];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: theme.colorScheme.primaryContainer,
                    child: Icon(Icons.store, color: theme.colorScheme.primary),
                  ),
                  title: Text(
                    store.name,
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    store.address?.addressLine ?? 'No address set',
                    style: theme.textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Text(
                    '${store.tripCount} trips',
                    style: theme.textTheme.labelLarge?.copyWith(fontFamily: 'JetBrains Mono'),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add a new grocery store location',
        onPressed: () {
          _showAddStoreDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddStoreDialog(BuildContext context) {
    final nameController = TextEditingController();
    final addressLineController = TextEditingController();
    final cityController = TextEditingController();
    final stateController = TextEditingController();
    final zipCodeController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Add Store'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
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
                    controller: addressLineController,
                    decoration: const InputDecoration(labelText: 'Address Line'),
                  ),
                  TextFormField(
                    controller: cityController,
                    decoration: const InputDecoration(labelText: 'City'),
                  ),
                  TextFormField(
                    controller: stateController,
                    decoration: const InputDecoration(labelText: 'State'),
                  ),
                  TextFormField(
                    controller: zipCodeController,
                    decoration: const InputDecoration(labelText: 'Zip Code'),
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
                  context.read<StoreBloc>().add(
                        AddStore(
                          name: nameController.text,
                          address: addressLineController.text,
                          city: cityController.text,
                          state: stateController.text,
                          zipCode: zipCodeController.text,
                        ),
                      );
                  Navigator.of(dialogContext).pop();
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
