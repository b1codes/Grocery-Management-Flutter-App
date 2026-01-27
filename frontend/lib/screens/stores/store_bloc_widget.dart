import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_management_frontend/bloc/store/store_bloc.dart';
import 'package:grocery_management_frontend/screens/stores/store_list_screen.dart';
import 'package:grocery_management_frontend/services/managers/store_manager.dart';

class StoreBlocWidget extends StatelessWidget {
  const StoreBlocWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          StoreBloc(storeManager: context.read<StoreManager>())
            ..add(FetchStores()),
      child: const StoreListScreen(),
    );
  }
}
