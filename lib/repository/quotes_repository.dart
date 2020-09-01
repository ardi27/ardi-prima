import 'dart:convert';

import 'package:ardi_prima/constants.dart';
import 'package:ardi_prima/model/quotes.dart';
import 'package:http/http.dart' as http;

class QuotesRepository {
  Future<List<Quotes>> fetchQuotes(int page) async {
    String url = Constants().apiUrl + "/quotes/page/" + page.toString();
    var response = await http.get(url);
    print(response.body);
    if (response.statusCode == 200) {
      List result = jsonDecode(response.body);
      return result.map((e) => Quotes.fromJson(e)).toList();
    } else {
      print("error");
    }
  }
}
