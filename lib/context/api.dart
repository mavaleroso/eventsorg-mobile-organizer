import 'dart:convert';
import './config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CallApi {
  final String _url = baseUrl;
  late String _token = '';
  final int timoutSeconds = 5;

  _getSharedPreferenceBaseUrl() async {
    final prefs = await SharedPreferences.getInstance();
    final url = prefs.getString('BASE_URL') ?? _url;
    _token = prefs.getString('token') ?? '';
    return url;
  }

  _setHeaders() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $_token',
      };

  _errorHandler(res) {
    var data = 'Test';

    switch (res.statusCode) {
      case 200:
      case 201:
      case 202:
        {
          data = res.body;
        }
        break;

      case 400:
        {
          data = res.body ?? 'Unknown Error!';
        }

      case 401:
        {
          var arr = json.decode(res.body);
          data = json.encode(arr['message']);
        }
        break;

      case 404:
        {
          data = res.body ?? 'Server not found!';
        }
        break;

      case 422:
        {
          var arr = json.decode(res.body);
          data = json.encode(arr['errors']);
        }
        break;

      case 500:
        {
          data = 'Server error!';
        }
        break;

      default:
        {
          data = 'Unknown Error!';
        }
        break;
    }

    var result = {
      'code': res.statusCode,
      'data': data,
    };
    return result;
  }

  postData(data, apiUrl) async {
    var baseUrl = await _getSharedPreferenceBaseUrl();
    var fullUrl = baseUrl + apiUrl;

    try {
      var response = await http
          .post(
            Uri.parse(fullUrl),
            body: json.encode(data),
            headers: _setHeaders(),
          )
          .timeout(Duration(seconds: timoutSeconds));

      return _errorHandler(response);
    } catch (e) {
      return {
        'code': '101',
        'data': 'Server not found!',
      };
    }
  }

  putData(data, apiUrl) async {
    var baseUrl = await _getSharedPreferenceBaseUrl();
    var fullUrl = baseUrl + apiUrl;

    try {
      var response = await http
          .put(
            Uri.parse(fullUrl),
            body: json.encode(data),
            headers: _setHeaders(),
          )
          .timeout(Duration(seconds: timoutSeconds));

      return _errorHandler(response);
    } catch (e) {
      return {
        'code': '404',
        'data': 'Server not found!',
      };
    }
  }

  deleteData(apiUrl) async {
    var baseUrl = await _getSharedPreferenceBaseUrl();
    var fullUrl = baseUrl + apiUrl;

    try {
      var response = await http
          .delete(
            Uri.parse(fullUrl),
            headers: _setHeaders(),
          )
          .timeout(Duration(seconds: timoutSeconds));

      return _errorHandler(response);
    } catch (e) {
      return {
        'code': '404',
        'data': 'Server not found!',
      };
    }
  }

  getData(apiUrl) async {
    var baseUrl = await _getSharedPreferenceBaseUrl();
    var fullUrl = baseUrl + apiUrl;

    try {
      var response = await http.get(
        Uri.parse(fullUrl),
        headers: _setHeaders(),
      );
      return _errorHandler(response);
    } catch (e) {
      return {
        'code': '404',
        'data': 'Server not found!',
      };
    }
  }
}
