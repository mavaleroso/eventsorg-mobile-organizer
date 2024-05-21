import 'dart:convert';
import './config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CallApi {
  final String _url = baseUrl;

  _getSharedPreferenceBaseUrl() async {
    final prefs = await SharedPreferences.getInstance();
    final url = prefs.getString('BASE_URL') ?? _url;
    return url;
  }

  _setHeaders() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };

  _errorHandler(res) {
    var data = 'Test';

    switch (res.statusCode) {
      case 200:
        {
          data = res.body;
        }
        break;

      case 422:
        {
          var arr = json.decode(res.body);
          data = json.encode(arr['errors']);
        }
        break;

      case 404:
        {
          data = 'Server not found!';
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

    var response = await http.post(
      Uri.parse(fullUrl),
      body: json.encode(data),
      headers: _setHeaders(),
    );

    return _errorHandler(response);
  }
}
