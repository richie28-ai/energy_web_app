import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/data_point.dart';


class ApiService {
  static const _apiKey = 'WOiDKR5hRfL2szBMtwISMTHUDX89Lx1JH6P6TQsE';
  // static const _baseUrl = 'https://api.eia.gov/v2/seriesid/SEDS.SOTCB.CA.A';
  static const _baseUrl = 'https://api.eia.gov/v2/seds/data';


  static Future<List<DataPoint>> fetchSolarData({
    List<String> states = const ['CA', 'TX', 'NY'],
    List<String> seriesIds = const ['SOTCB'],
    int offset = 0,
    int length = 100,
  })
  async {
    final uri = Uri.parse("$_baseUrl?api_key=$_apiKey&frequency=annual&data[]=value"
        + states.map((s) => '&facets[stateId][]=$s').join()
        + seriesIds.map((s) => '&facets[seriesId][]=$s').join()
        + '&sort[0][column]=period&sort[0][direction]=desc'
        + '&offset=$offset&length=$length');

    print('url: $uri');

    final response = await http.get(uri);
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final responseData = jsonData['response'];

      if (responseData == null || responseData['data'] == null) {
        throw Exception('Invalid data');
      }

      final List<dynamic> records = responseData['data'];
      return records.map((data) => DataPoint.fromJson(data)).toList();
    } else {
      throw Exception(
        'Failed to fetch data: ${response.statusCode} - ${response.body}',
      );
    }
  }

}
