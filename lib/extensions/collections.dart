extension SaveArgs on Map<dynamic, dynamic> {
  double doubleValue(String key) {
    return double.tryParse("${this[key]}") ?? 0;
  }

  int intValue(String key) {
    int? value = int.tryParse("${this[key]}");
    if (value == null) {
      value = double.tryParse("${this[key]}")?.toInt();
    }
    return value ?? 0;
  }

  bool boolValue(String key) {
    if (!this.containsKey(key)) {
      return false;
    }
    if (this[key] is int) {
      return this.intValue(key) == 0 ? false : true;
    }
    if ("${this[key]}".toLowerCase() == "true") {
      return true;
    }
    if ("${this[key]}".toLowerCase() == "false") {
      return false;
    }
    if (this.intValue(key) == 0) {
      return false;
    }
    if (this.intValue(key) == 1) {
      return true;
    }
    return this[key] as bool;
  }

  String stringValue(String key) {
    if (this[key] == null) {
      return "";
    }
    return "${this[key]}";
  }

  Map<String, dynamic> mapValue(String key) {
    if (this[key] == null) {
      return {};
    }
    return Map.from(this[key]);
  }

  List<dynamic> listValue(String key) {
    if (this[key] == null) {
      return [];
    }
    return List.from(this[key]);
  }
}
