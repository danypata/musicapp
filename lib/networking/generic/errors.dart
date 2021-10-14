class ApiError extends Error {
  static final int noInternet = -1010;
  final int statusCode;
  final String message;
  final Map<dynamic, dynamic>? extraParams;

  ApiError(this.statusCode, {String? message, this.extraParams})
      : this.message = message ?? _parseError(extraParams);

  static String _parseError(Map<dynamic, dynamic>? json) {
    return "";
  }

  factory ApiError.fromUnknownError(dynamic error) {
    return ApiError(101);
  }

  factory ApiError.noInternetError() {
    return ApiError(noInternet, message: "No internet connection");
  }

  @override
  String toString() {
    return "Status code: $statusCode\nError:$message";
  }
}

class UserUnauthorized extends Error {
  static final int code = 1001;

  @override
  String toString() {
    return "User is not authorized. Please login into the app and try again.";
  }
}
