import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_management_frontend/bloc/trips/trip_bloc.dart';
import 'package:grocery_management_frontend/screens/trips/active_trip_screen.dart';
import 'package:grocery_management_frontend/services/managers/trip_manager.dart';

class TripBlocWidget extends StatelessWidget {
  const TripBlocWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TripBloc(tripManager: context.read<TripManager>()),
      child: const ActiveTripScreen(),
    );
  }
}
