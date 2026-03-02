# Test Suite Expert Skill

Expert guidance for writing and maintaining tests for both Flutter and Django.

## 📋 Instructions

### 🐍 Django (Backend)
1.  **Location**: Place tests in `backend/apps/<module>/tests.py`.
2.  **Pattern**: Inherit from `rest_framework.test.APITestCase`.
3.  **Setup**: Use `setUp` to create necessary test data (users, initial objects).
4.  **Assertions**: Use `self.assertEqual(response.status_code, status.HTTP_200_OK)`.

### 🐦 Flutter (Frontend)
1.  **Location**: Place unit/bloc tests in `frontend/test/`.
2.  **Bloc Tests**: Use the `bloc_test` package.
3.  **Mocking**: Use `mocktail` for dependency injection and service mocking.
4.  **Assertions**: Verify states are emitted in the expected order.

## 🛠️ Resources

-   **Flutter Bloc Test Example**:
    ```dart
    blocTest<MyBloc, MyState>(
      'emits [Loading, Loaded] when FetchData is added',
      build: () => MyBloc(mockService),
      act: (bloc) => bloc.add(FetchData()),
      expect: () => [isA<MyLoading>(), isA<MyLoaded>()],
    );
    ```
