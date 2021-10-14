import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:musicapp/networking/config/api_config.dart';
import 'package:musicapp/networking/generic/errors.dart';
import 'package:rxdart/rxdart.dart';

class Request {
  final ApiConfig config;
  late Map<String, String> headers;
  final HttpClientBuilder _clientBuilder;

  Request({@required ApiConfig? config, HttpClientBuilder? builder})
      : config = config != null ? config : ApiConfig(),
        _clientBuilder = builder ?? HttpClientBuilder() {
    if (this.config.headers.isNotEmpty) {
      headers = Map.from(this.config.headers);
    } else {
      headers = Map();
    }
  }

  Stream<Map<dynamic, dynamic>> post(String path,
      {Map<String, dynamic>? additionalHeaders,
      Map<String, dynamic>? body,
      Map<String, String>? params,
      bool formData = false,
      String? responseFormat}) {
    _checkHeaders(additionalHeaders);
    return _newPostRequest(
      path,
      body: body,
      params: params,
      formData: formData,
    ).map((response) {
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (!(response.json is Map<String, dynamic>)) {
          throw ApiError(response.statusCode,
              message: "Invalid response format");
        }
        var json = response.json;
        if (json == null) {
          throw ApiError(-101, message: "Invalid response");
        }
        return json;
      } else if (response.statusCode == 401) {
        throw UserUnauthorized();
      } else {
        print("Error ${response.statusCode} == ${response.json}");
        throw ApiError(
          response.statusCode,
          extraParams: response.json,
        );
      }
    });
  }

  Stream<Map<dynamic, dynamic>> get(String path,
      {Map<String, dynamic>? additionalHeaders, Map<String, String>? params}) {
    _checkHeaders(additionalHeaders);
    return _newGetRequest(path, params: params).map((response) {
      if (response.statusCode == 200 || response.statusCode == 201) {
        var json = response.json;
        if (json == null) {
          throw ApiError(-101, message: "Invalid response");
        }
        return json;
      } else if (response.statusCode == 401) {
        throw UserUnauthorized();
      } else {
        throw ApiError(
          response.statusCode,
          extraParams: response.json,
        );
      }
    });
  }

  Stream<RawResponse> _newPostRequest(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? params,
    bool formData = false,
  }) {
    body?.removeWhere((value, key) => key == null);

    var url = Uri.https(config.apiHost, path, params);

    http.Client client = _clientBuilder.newClient();
    _printRequest(url.toString(), body);

    String jsonBody = jsonEncode(body);
    Map<String, String> newHeaders = Map.from(headers);
    if (formData) {
      newHeaders["Content-Type"] = "application/x-www-form-urlencoded";
      newHeaders.remove("Accept");
    }

    return Stream.fromFuture(client.post(url,
            headers: newHeaders,
            body: formData
                ? Map<String, String>.from(body != null ? body : {})
                : jsonBody))
        .map((response) {
      dynamic body = json.decode(response.body);
      _printResponse(body);
      if (body is Map) {
        return RawResponse(response.statusCode, body);
      } else {
        return RawResponse(response.statusCode, {"data": body});
      }
    }).doOnError((err, _) {
      print("ERROR _newPostRequest: $err ");

      if (err is Error) {
        print(err.stackTrace);
      }
    }).doOnEach((_) async => client.close());
  }

  _checkHeaders(Map<String, dynamic>? newHeaders) {
    if (newHeaders != null && newHeaders.isNotEmpty) {
      headers.addAll(newHeaders.map((key, value) => MapEntry(key, "$value")));
    }
  }

  Stream<RawResponse> _newGetRequest(String path,
      {Map<String, String>? params}) {
    var url = Uri.https(config.apiHost, path, params);

    http.Client client = _clientBuilder.newClient();
    _printRequest(url.toString(), params);

    return Stream.fromFuture(client.get(url, headers: headers)).map((response) {
      dynamic body = json.decode(response.body);
      _printResponse(body);
      if (body is Map) {
        return RawResponse(response.statusCode, body);
      } else {
        return RawResponse(response.statusCode, {"data": body});
      }
    }).doOnEach((_) => client.close());
  }

  void _printRequest(String url, Map<String, dynamic>? params) {
    JsonEncoder encoder = JsonEncoder.withIndent('  ');
    debugPrint("URL: $url");
    debugPrint("Q: ${encoder.convert(params)}");
    debugPrint("H: ${encoder.convert(headers)}");
  }

  void _printResponse(dynamic json) {
    // JsonEncoder encoder = JsonEncoder.withIndent('  ');
    // debugPrint("R: ${encoder.convert(json)}");
  }
}

class RawResponse {
  final int statusCode;
  final Map<dynamic, dynamic>? json;

  RawResponse(this.statusCode, this.json);
}

class RequestBuilder {
  const RequestBuilder();

  Request newRequest({ApiConfig? config}) {
    print("NEW REQUEST ${config?.apiHost}");
    return Request(config: config != null ? config : ApiConfig());
  }
}

class HttpClientBuilder {
  http.Client newClient() {
    return http.Client();
  }
}
