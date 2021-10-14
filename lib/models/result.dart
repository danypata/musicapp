import 'package:musicapp/networking/generic/errors.dart';

class Result<T> {
  final ResultStatus status;
  final T? data;
  final ApiError? apiError;

  const Result({
    required this.status,
    this.data,
    this.apiError,
  });

  factory Result.inProgress() {
    return Result<T>(status: ResultStatus.progres);
  }

  factory Result.done(T data) {
    return Result(status: ResultStatus.done, data: data);
  }

  factory Result.error(ApiError error) {
    return Result(status: ResultStatus.error, apiError: error);
  }
}

enum ResultStatus { progres, done, error }
