import 'dart:convert' as convert;

import 'package:http/http.dart' as http;

class ProductRepository {
  Future<dynamic> getProductData() async {
    var jsonResponse;
    var result =
        await http.get(Uri.parse("https://api.npoint.io/44baf1cec4126a8046b6"));
    if (result.statusCode == 200) {
      jsonResponse = convert.jsonDecode(result.body);
      print(jsonResponse);
    }
    return jsonResponse;
  }
}

var productRepository = ProductRepository();
