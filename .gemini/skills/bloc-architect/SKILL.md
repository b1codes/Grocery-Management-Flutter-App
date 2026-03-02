# Flutter BLoC Architecture Skill

Expert guidance for implementing state management using `flutter_bloc`.

## 📋 Instructions

When creating a new BLoC in `frontend/lib/bloc/`:

1.  **Structure**: Create a directory for the bloc (e.g., `frontend/lib/bloc/my_feature/`).
2.  **Files**: Create three files: `my_feature_bloc.dart`, `my_feature_event.dart`, and `my_feature_state.dart`.
3.  **Events**: Define clear, intent-based events using `sealed class` or `abstract class`.
4.  **States**: Define states that represent the UI lifecycle (Initial, Loading, Loaded, Error).
5.  **API Integration**: Inject the `ApiClient` or specific services into the Bloc constructor.
6.  **Error Handling**: Always catch exceptions and emit an `Error` state with a descriptive message.

## 🛠️ Resources

-   **Bloc Pattern**:
    ```dart
    class MyFeatureBloc extends Bloc<MyFeatureEvent, MyFeatureState> {
      final ApiClient _apiClient;

      MyFeatureBloc(this._apiClient) : super(MyFeatureInitial()) {
        on<FetchData>(_onFetchData);
      }

      Future<void> _onFetchData(FetchData event, Emitter<MyFeatureState> emit) async {
        emit(MyFeatureLoading());
        try {
          final data = await _apiClient.getData();
          emit(MyFeatureLoaded(data));
        } catch (e) {
          emit(MyFeatureError(e.toString()));
        }
      }
    }
    ```
