import 'dart:convert';
import './config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CallApi {
  final String _url = baseUrl;

  _getSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final url = prefs.getString('BASE_URL') ?? _url;
    final token = prefs.getString('token');

    return {'url': url, 'token': token};
  }

  _setHeaders(token) => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
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
    var preference = await _getSharedPreferences();

    var fullUrl = preference['url'] + apiUrl;
    var token = preference['token'];

    var response = await http.post(
      Uri.parse(fullUrl),
      body: json.encode(data),
      headers: _setHeaders(token),
    );

    return _errorHandler(response);
  }
}
