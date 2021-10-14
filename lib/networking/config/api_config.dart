import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiConfig {
  late String apiHost; //This is the API server
  late ConfigEnv _env;
  late String apiKey;
  late String responseFormat;

  Map<String, String> headers = {};

  ConfigEnv get env => _env;

  bool get allowStagingUI => false;

  @protected
  static final ApiConfig _instance = ApiConfig._();

  factory ApiConfig() {
    return _instance;
  }

  ApiConfig._();

  void setEnv(ConfigEnv env) {
    _env = env;
    if (env == ConfigEnv.staging) {
      apiHost = "ws.audioscrobbler.com";
      apiKey = "ebe600364ad36fc6ca31716cee3c81b9";
      responseFormat = "json";
    } else {
      apiHost = "ws.audioscrobbler.com";
      apiKey = "ebe600364ad36fc6ca31716cee3c81b9";
      responseFormat = "json";
    }
    // SharedPreferences.getInstance()
    //     .then((value) => {value.setString("env", envKey())});
  }

  Future<bool> loadEnv() {
    return SharedPreferences.getInstance().then((value) {
      if (envKey() == "prod") {
        setEnv(ConfigEnv.production);
      } else {
        setEnv(ConfigEnv.staging);
      }
      return true;
    });
  }

  String envKey() {
    if (_env == ConfigEnv.staging) {
      return "staging";
    }
    return "prod";
  }
}

enum ConfigEnv { production, staging }
