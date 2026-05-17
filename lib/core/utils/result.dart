import 'package:itrip/core/errors/failures.dart';

/// Functional result type for repository operations.
sealed class Result<T> {
  const Result();
}

class Success<T> extends Result<T> {
  const Success(this.data);
  final T data;
}

class Error<T> extends Result<T> {
  const Error(this.failure);
  final Failure failure;
}

extension ResultExtension<T> on Result<T> {
  R when<R>({
    required R Function(T data) success,
    required R Function(Failure failure) error,
  }) {
    return switch (this) {
      Success(data: final data) => success(data),
      Error(failure: final failure) => error(failure),
    };
  }

  T? get dataOrNull => switch (this) {
        Success(data: final data) => data,
        Error() => null,
      };
}
