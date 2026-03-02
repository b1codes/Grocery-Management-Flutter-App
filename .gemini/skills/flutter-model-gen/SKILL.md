# Flutter Model Generation Skill

Expert guidance for creating and updating data models in the Flutter project using `dart_mappable`.

## 📋 Instructions

When creating or modifying a model in `frontend/lib/models/`:

1.  **Annotation**: Every model class must be annotated with `@MappableClass()`.
2.  **Imports**: Ensure you import the mapping library: `import 'package:dart_mappable/dart_mappable.dart';`.
3.  **Part File**: Include the generated part file: `part 'filename.mapper.dart';`.
4.  **Constructor**: Use standard Dart constructors. `dart_mappable` will handle the rest.
5.  **Code Generation**: After any change to a model, you MUST run the build runner:
    ```bash
    cd frontend && dart run build_runner build --delete-conflicting-outputs
    ```
6.  **Verification**: Confirm that the corresponding `.mapper.dart` file has been updated or created.

## 🛠️ Resources

-   **Model Template**:
    ```dart
    import 'package:dart_mappable/dart_mappable.dart';

    part 'my_model.mapper.dart';

    @MappableClass()
    class MyModel with MyModelMappable {
      final String id;
      final String name;

      MyModel({required this.id, required this.name});
    }
    ```
