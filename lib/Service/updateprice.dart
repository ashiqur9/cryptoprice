import 'dart:convert';
import 'package:cryptoprice/modes/cryptoprice.dart';
import 'package:dio/dio.dart';

class Updateprice {
  static Future<Cryptoprice> request(String symbol) async {
    final dio = Dio();
    Response response;
    response = await dio
        .get('https://api.binance.com/api/v3/ticker/price?symbol=$symbol');

    var data = jsonDecode(response.toString());

    return Cryptoprice.fromjson(data);
  }
}
