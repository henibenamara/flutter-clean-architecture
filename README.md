# Flutter Clean Architecture

![CI](https://github.com/henibenamara/flutter-clean-architecture/actions/workflows/ci.yml/badge.svg)

A small task manager built to show how I structure Flutter apps: three layers with a strict dependency rule, BLoC for state, dependency injection in one place, errors as values, and tests at every layer. The features are deliberately simple so the architecture is easy to read.

## What it demonstrates

- **Clean architecture.** Presentation depends on domain, data depends on domain, and domain depends on nothing. The domain layer is plain Dart.
- **BLoC.** `TodoBloc` turns events into use-case calls and results into immutable states. It never sees the data layer.
- **Errors as values.** Use cases and repositories return a sealed `Result<T>` (`Ok` or `Err`) instead of throwing. Data-layer exceptions are mapped to domain `Failure`s at the repository boundary, and the UI has to handle both outcomes.
- **Business rules in the domain.** "A title cannot be blank" lives in the `AddTodo` use case, so it holds whichever UI or data source is used.
- **Dependency injection.** `get_it` wires every layer in `lib/injection.dart`, the only file that knows all the concrete classes.
- **Tests at every layer.** Use case, repository, bloc and widget tests (16 in total).
- **CI.** Every push runs `flutter analyze`, `flutter test` and a release web build on GitHub Actions.

## Structure

```text
lib/
├── core/
│   ├── error/               Failure (domain) and StorageException (data)
│   └── result.dart          sealed Result: Ok | Err
├── features/todos/
│   ├── domain/              pure Dart, depends on nothing
│   │   ├── entities/        Todo
│   │   ├── repositories/    TodoRepository (contract)
│   │   └── usecases/        GetTodos, AddTodo, ToggleTodo, DeleteTodo
│   ├── data/
│   │   ├── models/          TodoModel (JSON and mapping to the entity)
│   │   ├── datasources/     TodoLocalDataSource + in-memory implementation
│   │   └── repositories/    TodoRepositoryImpl (exceptions to Failures)
│   └── presentation/
│       ├── bloc/            TodoBloc, events, state
│       └── pages/           TodoPage
├── injection.dart           get_it wiring
├── app.dart
└── main.dart
```

A tap on a checkbox travels like this:

```text
TodoPage --TodoToggled--> TodoBloc --> ToggleTodo --> TodoRepository (contract)
                                                          |
                                                 TodoRepositoryImpl --> TodoLocalDataSource
                                                          |
TodoPage <--TodoState-- TodoBloc <-------- Result<Todo> --+
```

## Design decisions

- **Sealed classes and pattern matching** for events, failures and results, so the compiler checks that every case is handled.
- **In-memory data source** keeps the demo free of storage dependencies. Swapping in SQLite, Hive or a REST client means adding one class that implements `TodoLocalDataSource` and changing one line in `injection.dart`.
- **Reload after every write.** After a successful change the bloc reloads the list, so the screen always shows what the data source actually holds.
- **Separate model and entity.** `TodoModel` owns serialization, `Todo` stays free of storage details.

## Getting started

The repository contains the Dart code and tests. Generate the platform folders once, then run it:

```bash
flutter create . --platforms=android,ios,web
flutter pub get
flutter run
```

If `flutter create` adds a sample `test/widget_test.dart`, delete it: this project has its own tests.

## Tests

```bash
flutter test
```

| Layer | What is tested |
| --- | --- |
| Domain | `AddTodo` trims titles, rejects blank ones and never calls the repository for them |
| Data | `TodoRepositoryImpl` maps models to entities and turns a `StorageException` into a `StorageFailure` |
| Presentation (bloc) | Every event, including the loading, success and failure states, using `bloc_test` and `mocktail` |
| Presentation (widget) | The real layers wired together: loading, adding, blank input, completing and deleting a todo |

## Continuous integration

The workflow in `.github/workflows/ci.yml` runs on every push and pull request: dependencies, static analysis with `flutter_lints` plus a few extra rules, the test suite, and a release build for web.

## Stack

Flutter, Dart 3, `flutter_bloc`, `equatable`, `get_it`, `bloc_test`, `mocktail`.
