import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grocery_management_frontend/bloc/trips/trip_bloc.dart';
import 'package:grocery_management_frontend/models/grocery_trip.dart';
import 'package:grocery_management_frontend/services/managers/trip_manager.dart';
import 'package:mocktail/mocktail.dart';

class MockTripManager extends Mock implements TripManager {}

void main() {
  group('TripBloc', () {
    late TripManager tripManager;

    setUp(() {
      tripManager = MockTripManager();
    });

    test('initial state is TripState()', () {
      expect(TripBloc(tripManager: tripManager).state, const TripState());
    });

    blocTest<TripBloc, TripState>(
      'emits [active] when StartTrip succeeds',
      setUp: () {
        when(() => tripManager.startTrip(any())).thenAnswer(
          (_) async => GroceryTrip(
            id: 1,
            store: 1,
            tripDate: DateTime.now(),
            totalSpent: 0.0,
          ),
        );
      },
      build: () => TripBloc(tripManager: tripManager),
      act: (bloc) => bloc.add(StartTrip(storeId: 1)),
      expect: () => [
        isA<TripState>()
            .having((s) => s.status, 'status', TripStatus.active)
            .having((s) => s.trip?.id, 'trip id', 1),
      ],
    );
  });
}
