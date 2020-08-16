import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:http_auth/http_auth.dart';

class PayPalService {
  final String domain = "https://api.sandbox.paypal.com"; // for sandbox mode
// final String domain = "https://api.paypal.com"; // for production mode
  String clientId =
      'AcWZY5FlC7irxXeRWDw8tHP58juX5133L--Z8BcivKxuxAh7NQw7Vw883nAN-Y8fdJ7Wv26874t-GEuw';
  String secret =
      'EGAt6qa1avrwRB7WQQx8fEyyXHpglU9rys6444tI7qDEoW9yzIlUmmRE1mofY9BHkch7kAOEKZEMOwnT';

//getting Access token
  Future<String> getAccessToken() async {
    try {
      var client = BasicAuthClient(clientId, secret);
      var response = await client
          .post('$domain/v1/oauth2/token?grant_type=client_credentials');
      if (response.statusCode == 200) {
        final body = convert.jsonDecode(response.body);
        return body["access_token"];
      }
      return null;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

//creating payment

  Future<Map<String, String>> createPayment(transactions, accessToken) async {
    try {
      var response = await http.post("$domain/v1/payments/payment",
          body: convert.jsonEncode(transactions),
          headers: {
            "content-type": "application/json",
            'Authorization': 'Bearer ' + accessToken
          });
      final body = convert.jsonDecode(response.body);
      if (response.statusCode == 201) {
        if (body["links"] != null && body["links"].length > 0) {
          List links = body["links"];
          String executeUrl = '';
          String approvalUrl = '';
          final item = links.firstWhere(
              (element) => element["rel"] == "approval_url",
              orElse: () => null);
          if (item != null) {
            approvalUrl = item['href'];
          }
          final item1 = links.firstWhere(
              (element) => element["rel"] == "execute",
              orElse: () => null);
          if (item1 != null) {
            executeUrl = item1["href"];
          }
          return {"executeUrl": executeUrl, "approvalUrl": approvalUrl};
        }
        return null;
      } else {
        throw Exception(body["message"]);
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  //Execute payment

  Future<String> executePayment(url, payerId, accessToken) async {
    try {
      var response =await http.post(url,body: convert.jsonEncode({'payer_id':payerId}),
      headers: {
        "content-type": "application/json",
        'Authorization': 'Bearer ' + accessToken
      });
      final body=convert.jsonDecode(response.body);
      if(response.statusCode==200){
        return body["id"];
      }
      return null;
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
