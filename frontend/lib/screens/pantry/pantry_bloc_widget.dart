import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_management_frontend/bloc/pantry/pantry_bloc.dart';
import 'package:grocery_management_frontend/screens/pantry/pantry_list_screen.dart';
import 'package:grocery_management_frontend/services/managers/pantry_manager.dart';

class PantryBlocWidget extends StatelessWidget {
  const PantryBlocWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          PantryBloc(pantryManager: context.read<PantryManager>())
            ..add(FetchPantryItems()),
      child: const PantryListScreen(),
    );
  }
}
