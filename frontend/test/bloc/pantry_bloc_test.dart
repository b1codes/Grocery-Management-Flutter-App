import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grocery_management_frontend/bloc/pantry/pantry_bloc.dart';
import 'package:grocery_management_frontend/models/pantry_item.dart';
import 'package:grocery_management_frontend/services/managers/pantry_manager.dart';
import 'package:mocktail/mocktail.dart';

class MockPantryManager extends Mock implements PantryManager {}

void main() {
  group('PantryBloc', () {
    late PantryManager pantryManager;

    setUp(() {
      pantryManager = MockPantryManager();
    });

    test('initial state is PantryState()', () {
      expect(
        PantryBloc(pantryManager: pantryManager).state,
        const PantryState(),
      );
    });

    blocTest<PantryBloc, PantryState>(
      'emits [loading, success] when FetchPantryItems adds items',
      setUp: () {
        when(() => pantryManager.getPantryItems()).thenAnswer(
          (_) async => [
            PantryItem(
              id: 1,
              name: 'Milk',
              quantity: 1,
              regularPrice: 2.0,
              lastUpdated: DateTime.now(),
            ),
          ],
        );
      },
      build: () => PantryBloc(pantryManager: pantryManager),
      act: (bloc) => bloc.add(FetchPantryItems()),
      expect: () => [
        const PantryState(status: PantryStatus.loading),
        isA<PantryState>()
            .having((s) => s.status, 'status', PantryStatus.success)
            .having((s) => s.items.length, 'items length', 1),
      ],
    );

    blocTest<PantryBloc, PantryState>(
      'emits [success] with new item when AddPantryItem is added',
      setUp: () {
        when(
          () => pantryManager.createPantryItem(any(), any(), any()),
        ).thenAnswer(
          (_) async => PantryItem(
            id: 2,
            name: 'Bread',
            quantity: 1,
            regularPrice: 3.0,
            lastUpdated: DateTime.now(),
          ),
        );
      },
      build: () => PantryBloc(pantryManager: pantryManager),
      act: (bloc) =>
          bloc.add(AddPantryItem(name: 'Bread', quantity: 1, categoryId: 1)),
      expect: () => [
        isA<PantryState>().having((s) => s.items.length, 'items length', 1),
      ],
    );
  });
}
