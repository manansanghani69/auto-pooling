typedef ResultFuture<T> = Future<Result<T>>;

class Result<T> {
  final T? data;
  final Object? error;

  const Result._({this.data, this.error});

  const Result.success(T data) : this._(data: data);

  const Result.failure(Object error) : this._(error: error);

  R fold<R>(R Function(Object error) onFailure, R Function(T data) onSuccess) {
    final failure = error;
    if (failure != null) {
      return onFailure(failure);
    }

    final value = data;
    if (value == null) {
      return onFailure(Exception('Unknown error'));
    }

    return onSuccess(value);
  }
}
